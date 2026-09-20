#!/usr/bin/env bash
# Divit'i başlatır. Çift tıklayın.
cd "$(dirname "$0")" || exit 1
clear
cat <<'MSG'

  Divit — akademik yazım tezgâhı

  Ne yapmak istediğinizi kendi cümlelerinizle yazın. Örnek:

    · "gelen klasöründeki tezi oku, rapor çıkar"
    · "şu taslaktaki atıfları kontrol et"
    · "dekanlığa izin dilekçesi yazalım"
    · "bunu Word'e çevir"
    · "bozuldu, geri al"

  Çıkmak için:  Ctrl-C  ya da  /exit

MSG
exec claude
