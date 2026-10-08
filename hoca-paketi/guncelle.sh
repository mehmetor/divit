#!/bin/sh
# Divit güncelleyici (macOS). Kurulum bunu ~/.divit/guncelle.sh olarak koyar
# ve klasör ayarına bu yolla tam eşleşen tek bir izin kuralı yazar; böylece
# Divit'in "güncelle"si kurulumu soru ve güvenlik denetimine takılmadan
# başlatabilir (DVT-67). Divit'in çağırdığı biçim (yol tırnaksız):
#
#   sh /Users/<ad>/.divit/guncelle.sh <kanal> "<Divit klasörünün tam yolu>"
#
# En yeni kur.sh'yi kanaldan indirir, klasörü DIVIT_HEDEF olarak verir
# (DVT-66). Tür verilmez: kur.sh onu klasördeki kimlik.md'den okur.
kanal="${1:-main}"
hedef="${2:-}"
case "$kanal" in
  main|deneme|deneme-?*) ;;
  *) kanal="main" ;;
esac
if [ -z "$hedef" ] || [ ! -d "$hedef/.divit" ]; then
  echo "HATA: Divit klasörü bulunamadı: $hedef"
  exit 1
fi
gecici="$(mktemp)" || exit 1
trap 'rm -f "$gecici"' EXIT
if ! curl -fsSL -o "$gecici" "https://raw.githubusercontent.com/mehmetor/divit/$kanal/kur.sh"; then
  echo "HATA: Divit indirilemedi. İnternet bağlantısını kontrol edin."
  exit 1
fi
unset DIVIT_TUR
DIVIT_DAL="$kanal" DIVIT_HEDEF="$hedef" bash "$gecici"
