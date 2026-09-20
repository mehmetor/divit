#!/usr/bin/env bash
# Divit — ortam kontrolü.
# Hangi araçlar kurulu, bağlama yazar. HİÇBİR ŞEY KURMAZ.
# Tespit betiğin, karar insanındır.
set -uo pipefail

kok="${CLAUDE_PROJECT_DIR:-$PWD}"
[ -f "$kok/.divit-vault" ] || exit 0

var=(); yok=()
kontrol() { # kontrol <komut> <insanca-ad> <ne-ise-yarar>
  if command -v "$1" >/dev/null 2>&1; then var+=("$2"); else yok+=("$2 — $3"); fi
}

kontrol pandoc     "pandoc"      "Word/PDF çıktısı almak için gerekli"
kontrol pdftotext  "poppler"     "PDF kaynaklardan metin okumak için gerekli"
kontrol git        "git"         "otomatik yedekleme için gerekli"
kontrol latexmk    "LaTeX"       "PDF çıktısı için (opsiyonel, Word yeterli)"

bib=$(find "$kok" -maxdepth 2 -name '*.bib' 2>/dev/null | head -1)
pdf_sayi=$(find "$kok/kaynaklar" -maxdepth 2 -iname '*.pdf' 2>/dev/null | wc -l | tr -d ' ')

echo "## Divit ortam durumu"
echo
echo "Kurulu: ${var[*]:-yok}"
if [ ${#yok[@]} -gt 0 ]; then
  echo
  echo "Eksik:"
  for e in "${yok[@]}"; do echo "- $e"; done
  echo
  echo "Bir işi yaparken bunlardan biri gerekirse hocaya tek cümleyle"
  echo "söyle ve kurmayı teklif et. Kendiliğinden kurma."
fi
echo
if [ -n "$bib" ]; then
  echo "Kaynakça: ${bib#$kok/} (atıflar yalnız buradan kurulur)"
else
  echo "Kaynakça: YOK. Atıf gerektiren bir iş çıkarsa önce kaynakça"
  echo "kurulmalı — \`kaynak-dogrula\` skill'i yol gösterir."
fi
echo "Yerel kaynak PDF sayısı: $pdf_sayi"
