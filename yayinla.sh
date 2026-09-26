#!/usr/bin/env bash
# Divit — eklentiyi hocalara yayınlar (geliştiricinin makinesinde çalışır).
#
#   ./yayinla.sh            zip'i oluştur, marketplace.json'u güncelle, commit et
#   ./yayinla.sh --gonder   ayrıca GitHub'a gönder (hocalara ulaşır)
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

claude plugin validate "$EKLENTI" >/dev/null || { echo "HATA: eklenti doğrulanamadı."; claude plugin validate "$EKLENTI"; exit 1; }

GECICI="$(mktemp -d)"; trap 'rm -rf "$GECICI"' EXIT
cp -R "$EKLENTI" "$GECICI/divit"
find "$GECICI/divit" \( -name '.DS_Store' -o -name '__pycache__' \) -prune -exec rm -rf {} +
# Belirleyici zip: sabit zaman damgası, sabit sıra, ek öznitelik yok.
find "$GECICI/divit" -exec touch -h -t 202601010000 {} +
(cd "$GECICI" && find divit -type f | LC_ALL=C sort | zip -q -X -D "$GECICI/divit.zip" -@)

OZET="$(shasum -a 256 "$GECICI/divit.zip" | cut -c1-64)"
KISA="${OZET:0:12}"
mkdir -p "$DAGITIM"
ZIP="$DAGITIM/divit-$KISA.zip"
if [ -f "$ZIP" ]; then
  echo "Eklentide değişiklik yok (özet $KISA). Yayınlanacak bir şey yok."
  exit 0
fi
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

git add "$ZIP" .claude-plugin/marketplace.json
git commit -q -m "yayın: divit $KISA" -m "Eklenti zip'i ve marketplace.json güncellendi."
echo "Hazır: $ZIP ($KISA)"

if [ "${1:-}" = "--gonder" ]; then
  git push -q origin main && echo "GitHub'a gönderildi. Hocalar birkaç saat içinde güncellemeyi alır."
else
  echo "Göndermek için: git push   (ya da ./yayinla.sh --gonder)"
fi
