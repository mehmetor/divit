#!/usr/bin/env bash
# Divit — eklenti zip'lerini üretir (divit ve divit-akademik).
#
#   ./yayinla.sh                  deneme: doğrula, zip'leri geçici üret, iki
#                                 özeti ve hocaya gidecek notu göster. Hiçbir
#                                 şey değişmez.
#   ./yayinla.sh --surum 1.8.0    yayın (CI çalıştırır, elle çalıştırma):
#                                 SURUM.md'de "Sıradaki" → "1.8.0 · tarih",
#                                 dagitim/ zip'leri, marketplace.json, commit.
#
# Yayın akışı: develop'ta çalışılır → release-please sürüm PR'ı açar →
# PR birleşince .github/workflows/yayin.yml bu betiği --surum ile çalıştırır
# ve develop'u main'e taşır. main = hocalara giden hâl.
#
# Hocaların makinesinde git yok. Bu yüzden eklenti GitHub'dan git ile değil,
# zip olarak HTTPS üzerinden iner ("archive" kaynağı). Claude Code sürümü
# zip'in SHA-256 özetinden hesaplar: özet değişince hocalara güncelleme gider.
# Zip belirleyici üretilir: eklentide değişiklik yoksa özet de değişmez.
#
# İki eklenti aynı pazar yerindedir: divit (çekirdek, her kullanıcıda açık)
# ve divit-akademik (yalnız akademisyen klasöründe açık). Sürüm notu tektir,
# çekirdeğin SURUM.md'sinde durur ve iki eklentiyi birlikte anlatır.
set -euo pipefail

cd "$(dirname "$0")"
REPO="mehmetor/divit"
EKLENTILER=(divit divit-akademik)
EKLENTI="plugins/divit"
DAGITIM="dagitim"
SURUM=""
[ "${1:-}" = "--surum" ] && SURUM="${2:?sürüm numarası eksik}"

for AD in "${EKLENTILER[@]}"; do
  claude plugin validate "plugins/$AD" >/dev/null || { echo "HATA: $AD eklentisi doğrulanamadı."; claude plugin validate "plugins/$AD"; exit 1; }
done

SIRADAKI="$(grep -c '^## Sıradaki' "$EKLENTI/SURUM.md" || true)"

GECICI="$(mktemp -d)"; trap 'rm -rf "$GECICI"' EXIT

if [ -n "$SURUM" ] && [ "$SIRADAKI" = "1" ]; then
  TARIH="$(TZ=Europe/Istanbul date +%Y-%m-%d)"
  python3 - "$EKLENTI/SURUM.md" "$SURUM" "$TARIH" <<'PY'
import re, sys
p, surum, tarih = sys.argv[1:]
s = open(p, encoding="utf-8").read()
s = re.sub(r"^## Sıradaki", f"## {surum} · {tarih}", s, count=1, flags=re.M)
open(p, "w", encoding="utf-8").write(s)
PY
fi

# Belirleyici zip: sabit zaman damgası, sabit sıra, ek öznitelik yok.
# Zip'in kök dizini eklentinin adıdır. Özeti basar.
paketle() {
  local ad="$1"
  cp -R "plugins/$ad" "$GECICI/$ad"
  find "$GECICI/$ad" \( -name '.DS_Store' -o -name '__pycache__' \) -prune -exec rm -rf {} +
  find "$GECICI/$ad" -exec touch -h -t 202601010000 {} +
  (cd "$GECICI" && find "$ad" -type f | LC_ALL=C sort | zip -q -X -D "$GECICI/$ad.zip" -@)
  shasum -a 256 "$GECICI/$ad.zip" | cut -c1-64
}

OZETLER=()
ZIPLER=()
DEGISEN=0
for i in "${!EKLENTILER[@]}"; do
  AD="${EKLENTILER[$i]}"
  OZETLER[$i]="$(paketle "$AD")"
  ZIPLER[$i]="$DAGITIM/$AD-${OZETLER[$i]:0:12}.zip"
  [ -f "${ZIPLER[$i]}" ] || DEGISEN=1
done

if [ -z "$SURUM" ]; then
  for i in "${!EKLENTILER[@]}"; do
    DURUM="yayınlanmamış değişiklik var"
    [ -f "${ZIPLER[$i]}" ] && DURUM="değişiklik yok"
    echo "Deneme: ${EKLENTILER[$i]} özet ${OZETLER[$i]:0:12} (${OZETLER[$i]}) — $DURUM"
  done
  if [ "$SIRADAKI" = "1" ]; then
    echo "Hocaya gidecek not:"
    sed -n '/^## Sıradaki/,/^## [0-9]/p' "$EKLENTI/SURUM.md" | sed '$d'
  else
    echo "UYARI: SURUM.md'de '## Sıradaki' yok. Eklenti değiştiyse hocaya not yazın."
  fi
  exit 0
fi

if [ "$DEGISEN" = "0" ]; then
  echo "Eklentilerde değişiklik yok. Yalnızca main güncellenecek."
  exit 0
fi
if [ "$SIRADAKI" != "1" ]; then
  echo "HATA: eklenti değişti ama $EKLENTI/SURUM.md'de '## Sıradaki' notu yok."
  echo "      Hocanın anlayacağı dille not yazıp develop'a gönderin."
  exit 1
fi

mkdir -p "$DAGITIM"
for i in "${!EKLENTILER[@]}"; do
  AD="${EKLENTILER[$i]}"
  [ -f "${ZIPLER[$i]}" ] || cp "$GECICI/$AD.zip" "${ZIPLER[$i]}"
  URL="https://raw.githubusercontent.com/$REPO/main/${ZIPLER[$i]}"
  python3 - "$AD" "$URL" "${OZETLER[$i]}" <<'PY'
import json, sys
ad, url, ozet = sys.argv[1:]
p = ".claude-plugin/marketplace.json"
d = json.load(open(p, encoding="utf-8"))
kaynak = {"source": "archive", "url": url, "sha256": ozet}
for e in d["plugins"]:
    if e["name"] == ad:
        e["source"] = kaynak
        break
else:
    d["plugins"].append({"name": ad, "source": kaynak})
json.dump(d, open(p, "w", encoding="utf-8"), ensure_ascii=False, indent=2)
open(p, "a").write("\n")
PY
done

claude plugin validate . >/dev/null || { echo "HATA: marketplace doğrulanamadı."; claude plugin validate .; exit 1; }

git add "${ZIPLER[@]}" .claude-plugin/marketplace.json "${EKLENTILER[@]/#/plugins/}"
git commit -q -m "chore(yayin): divit $SURUM (${OZETLER[0]:0:12} · ${OZETLER[1]:0:12})" -m "Eklenti zip'leri ve marketplace.json güncellendi."
echo "Hazır: sürüm $SURUM, ${ZIPLER[*]}"
