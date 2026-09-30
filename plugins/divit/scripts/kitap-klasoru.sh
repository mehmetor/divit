#!/bin/sh
# Mac: kitap klasörünü açar ve kullanıcının dosyasını bir kez yerleştirir.
# Divit klasöründe çalışır; yollar klasöre göredir. Var olan dosyaya dokunmaz.
# Kullanım: sh kitap-klasoru.sh ac <kitap-adi>
#           sh kitap-klasoru.sh koy <kitap-adi> asil|malzeme "<kaynak dosya>"
# Çıktı tek satır: ACILDI <yol> | KOPYALANDI <yol> | VAR <yol> | HATA <neden>
# Çıkış: 0 tamam, 3 aynı adlı dosya zaten var, 1 hata.
# Windows eşi: kitap-klasoru.ps1 (aynı arayüz).

hata() {
  echo "HATA $1"
  exit 1
}

islem=$1
ad=$2

case "$ad" in
  '' | -* | *[!a-z0-9-]*)
    hata "Kitap adı yalnız küçük harf, rakam ve tire olabilir (ör. yonetim-notlari)." ;;
esac

kok="kitaplar/$ad"

klasorleri_ac() {
  mkdir -p "$kok/asil" "$kok/malzeme" || hata "Kitap klasörü açılamadı: $kok"
}

case "$islem" in
  ac)
    [ $# -eq 2 ] || hata "Kullanım: ac <kitap-adi>"
    klasorleri_ac
    echo "ACILDI $kok"
    ;;
  koy)
    [ $# -eq 4 ] || hata "Kullanım: koy <kitap-adi> asil|malzeme \"<dosya>\""
    bolum=$3
    kaynak=$4
    case "$bolum" in
      asil | malzeme) ;;
      *) hata "Yer yalnız asil ya da malzeme olabilir." ;;
    esac
    [ -f "$kaynak" ] || hata "Dosya bulunamadı: $kaynak"
    klasorleri_ac
    hedef="$kok/$bolum/$(basename "$kaynak")"
    if [ -e "$hedef" ]; then
      echo "VAR $hedef"
      exit 3
    fi
    cp "$kaynak" "$hedef" || hata "Dosya kopyalanamadı: $kaynak"
    echo "KOPYALANDI $hedef"
    ;;
  *)
    hata "Bilinmeyen iş: '$islem' (ac ya da koy olmalı)."
    ;;
esac
