#!/usr/bin/env bash
# Divit — eklenti zip'ini üretir.
#
#   ./yayinla.sh                  deneme: doğrula, zip'i geçici üret, özeti ve
#                                 hocaya gidecek notu göster. Hiçbir şey değişmez.
#   ./yayinla.sh --surum 1.8.0    yayın (CI çalıştırır, elle çalıştırma):
#                                 SURUM.md'de "Sıradaki" → "1.8.0 · tarih",
#                                 dagitim/ zip'i, marketplace.json, commit.
#
# Yayın akışı: develop'ta çalışılır → release-please sürüm PR'ı açar →
# PR birleşince .github/workflows/yayin.yml bu betiği --surum ile çalıştırır
# ve develop'u main'e taşır. main = hocalara giden hâl.
#
# Hocaların makinesinde git yok. Bu yüzden eklenti GitHub'dan git ile değil,
# zip olarak HTTPS üzerinden iner ("archive" kaynağı). Claude Code sürümü
# zip'in SHA-256 özetinden hesaplar: özet değişince hocalara güncelleme gider.
# Zip belirleyici üretilir: eklentide değişiklik yoksa özet de değişmez.
set -euo pipefail

cd "$(dirname "$0")"
REPO="mehmetor/divit"
EKLENTI="plugins/divit"
DAGITIM="dagitim"
SURUM=""
[ "${1:-}" = "--surum" ] && SURUM="${2:?sürüm numarası eksik}"

claude plugin validate "$EKLENTI" >/dev/null || { echo "HATA: eklenti doğrulanamadı."; claude plugin validate "$EKLENTI"; exit 1; }

SIRADAKI="$(grep -c '^## Sıradaki' "$EKLENTI/SURUM.md" || true)"

GECICI="$(mktemp -d)"; trap 'rm -rf "$GECICI"' EXIT

if [ -n "$SURUM" ] && [ "$SIRADAKI" = "1" ]; then
  TARIH="$(TZ=Europe/Istanbul date +%Y-%m-%d)"
  python3 - "$EKLENTI/SURUM.md" "$SURUM" "$TARIH" <<'PY'
import sys
p, surum, tarih = sys.argv[1:]
s = open(p, encoding="utf-8").read()
s = s.replace("## Sıradaki", f"## {surum} · {tarih}", 1)
open(p, "w", encoding="utf-8").write(s)
PY
fi

cp -R "$EKLENTI" "$GECICI/divit"
find "$GECICI/divit" \( -name '.DS_Store' -o -name '__pycache__' \) -prune -exec rm -rf {} +
# Belirleyici zip: sabit zaman damgası, sabit sıra, ek öznitelik yok.
find "$GECICI/divit" -exec touch -h -t 202601010000 {} +
(cd "$GECICI" && find divit -type f | LC_ALL=C sort | zip -q -X -D "$GECICI/divit.zip" -@)

OZET="$(shasum -a 256 "$GECICI/divit.zip" | cut -c1-64)"
KISA="${OZET:0:12}"
ZIP="$DAGITIM/divit-$KISA.zip"

if [ -z "$SURUM" ]; then
  echo "Deneme: özet $KISA"
  if [ -f "$ZIP" ]; then echo "Eklentide yayınlanmamış değişiklik yok."; fi
  if [ "$SIRADAKI" = "1" ]; then
    echo "Hocaya gidecek not:"
    sed -n '/^## Sıradaki/,/^## [0-9]/p' "$EKLENTI/SURUM.md" | sed '$d'
  else
    echo "UYARI: SURUM.md'de '## Sıradaki' yok. Eklenti değiştiyse hocaya not yazın."
  fi
  exit 0
fi

if [ -f "$ZIP" ]; then
  echo "Eklentide değişiklik yok (özet $KISA). Yalnızca main güncellenecek."
  exit 0
fi
if [ "$SIRADAKI" != "1" ]; then
  echo "HATA: eklenti değişti ama $EKLENTI/SURUM.md'de '## Sıradaki' notu yok."
  echo "      Hocanın anlayacağı dille not yazıp develop'a gönderin."
  exit 1
fi

mkdir -p "$DAGITIM"
cp "$GECICI/divit.zip" "$ZIP"
URL="https://raw.githubusercontent.com/$REPO/main/$ZIP"

python3 - "$URL" "$OZET" <<'PY'
import json, sys
url, ozet = sys.argv[1], sys.argv[2]
p = ".claude-plugin/marketplace.json"
d = json.load(open(p, encoding="utf-8"))
for e in d["plugins"]:
    if e["name"] == "divit":
        e["source"] = {"source": "archive", "url": url, "sha256": ozet}
json.dump(d, open(p, "w", encoding="utf-8"), ensure_ascii=False, indent=2)
open(p, "a").write("\n")
PY

claude plugin validate . >/dev/null || { echo "HATA: marketplace doğrulanamadı."; claude plugin validate .; exit 1; }

git add "$ZIP" .claude-plugin/marketplace.json "$EKLENTI"
git commit -q -m "chore(yayin): divit $SURUM ($KISA)" -m "Eklenti zip'i ve marketplace.json güncellendi."
echo "Hazır: sürüm $SURUM, $ZIP ($KISA)"
