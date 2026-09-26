#!/usr/bin/env bash
# Divit — hoca için kurulum paketi hazırlar (Mehmet'in makinesinde çalışır).
#
#   ./hoca-paketi/paketle.sh <hoca-klasörü> <alan>
#   ./hoca-paketi/paketle.sh hocalar/ad-soyad ziraat
#
# Çıktı: dist/Divit-Kurulum-<ad>.zip
# Pakette: kur.sh, çalışma klasörü şablonu, alan kılavuzu, hocanın profili.
# Pakette OLMAYANLAR: CV, makaleler, öğrenci dosyaları, raporlar — bunlar
# kişisel veridir; gerekiyorsa kurulumdan sonra elle kopyalanır.
set -euo pipefail

HOCA="${1:?Kullanım: paketle.sh <hoca-klasörü> <alan>}"
ALAN="${2:?Alan adı gerekli (ör. ziraat)}"
REPO="$(cd "$(dirname "$0")/.." && pwd)"
AD="$(basename "$HOCA")"
[ -d "$HOCA" ] || { echo "Hoca klasörü yok: $HOCA"; exit 1; }
[ -f "$REPO/plugins/divit/alan/$ALAN.md" ] || { echo "Alan kılavuzu yok: $ALAN"; exit 1; }

GECICI="$(mktemp -d)"; P="$GECICI/Divit-Kurulum"
mkdir -p "$P/alan" "$P/profil"
cp "$REPO/hoca-paketi/kur.sh" "$P/"
cp -R "$REPO/hoca-paketi/Divit" "$P/"
cp "$REPO/plugins/divit/alan/$ALAN.md" "$P/alan/"
for f in kimlik.md uslup.md alan.md; do
  [ -f "$HOCA/$f" ] && cp "$HOCA/$f" "$P/profil/"
done
cat > "$P/BENİ-OKU.txt" <<MSG
Divit kurulum paketi — $AD

Bu paketi hocanın bilgisayarında Terminal ile çalıştırın:

  cd ~/Downloads/Divit-Kurulum
  DIVIT_ALAN=$ALAN DIVIT_PROFIL=./profil bash kur.sh

Ayrıntı: belgeler/KURULUM-REHBERI.md, Bölüm C.
MSG
mkdir -p "$REPO/dist"
ZIP="$REPO/dist/Divit-Kurulum-$AD.zip"
rm -f "$ZIP"
(cd "$GECICI" && zip -qr "$ZIP" Divit-Kurulum -x '*.DS_Store')
rm -rf "$GECICI"
echo "Hazır: $ZIP"
unzip -l "$ZIP" | tail -1
