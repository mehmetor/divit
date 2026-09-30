#!/bin/sh
# Mac: kitap klasörünü açar ve kullanıcının dosyasını bir kez yerleştirir.
# Divit klasörünün içinde (alt klasörde de) çalışır; kökü .divit klasöründen bulur,
# yollar köke göredir. Var olan dosyaya dokunmaz.
# Kullanım: sh kitap-klasoru.sh ac <kitap-adi>
#           sh kitap-klasoru.sh koy <kitap-adi> asil|malzeme "<kaynak dosya>" [yeni-ad]
# yeni-ad isteğe bağlı: küçük harf, rakam, tire; uzantı kaynaktan korunur
# (ör. 327434a4-image.jpg + el-yazisi-01 → el-yazisi-01.jpg).
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

# Kabuk bir alt klasörde kalmış olabilir: kök, .divit/ içeren ilk üst klasör.
divit_koku() {
  d=$(pwd)
  while [ "$d" != "/" ]; do
    [ -d "$d/.divit" ] && { echo "$d"; return 0; }
    d=$(dirname "$d")
  done
  return 1
}
calisma=$(pwd)
koku=$(divit_koku) || hata "Divit klasörü bulunamadı (.divit yok): $calisma"
cd "$koku" || hata "Divit klasörüne geçilemedi: $koku"

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
    [ $# -eq 4 ] || [ $# -eq 5 ] || hata "Kullanım: koy <kitap-adi> asil|malzeme \"<dosya>\" [yeni-ad]"
    bolum=$3
    kaynak=$4
    yeni=$5
    if [ $# -eq 5 ]; then
      case "$yeni" in
        '' | -* | *[!a-z0-9-]*)
          hata "Yeni ad yalnız küçük harf, rakam ve tire olabilir, uzantısız (ör. el-yazisi-01)." ;;
      esac
    fi
    case "$kaynak" in
      /*) ;;
      *) kaynak="$calisma/$kaynak" ;;
    esac
    case "$bolum" in
      asil | malzeme) ;;
      *) hata "Yer yalnız asil ya da malzeme olabilir." ;;
    esac
    [ -f "$kaynak" ] || hata "Dosya bulunamadı: $kaynak"
    klasorleri_ac
    taban=$(basename "$kaynak")
    if [ -n "$yeni" ]; then
      uzanti=""
      case "$taban" in
        ?*.*) uzanti=".${taban##*.}" ;;
      esac
      [ "$uzanti" = "." ] && uzanti=""
      taban="$yeni$uzanti"
    fi
    hedef="$kok/$bolum/$taban"
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
