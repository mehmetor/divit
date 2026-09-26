#!/usr/bin/env bash
# Divit'i başlatır. Çift tıklayın.
# Masaüstündeki simge bir bağlantıdır; Divit klasörüne gitmek için çöz.
kaynak="$0"; [ -L "$kaynak" ] && kaynak="$(readlink "$kaynak")"
cd "$(dirname "$kaynak")" || exit 1
clear
cat <<'MSG'

  Divit — akademik yazım tezgâhı

  İsteğinizi aşağıdaki alana yazın. Enter tuşuna basın.

  Örnek istekler:
    · gelen klasöründeki tezi değerlendir
    · bu makaleyi göndermeden kontrol et
    · dekanlığa izin dilekçesi yazalım
    · geri al

  Kılavuzu açmak için şunu yazın:  yardım
  Divit'i kapatmak için şunu yazın:  /exit

MSG
exec claude
