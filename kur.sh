#!/usr/bin/env bash
# Divit — yazım tezgâhı · macOS kurulumu
#
# Tek komut (Terminal'e yapıştırın):
#   curl -fsSL https://raw.githubusercontent.com/mehmetor/divit/main/kur.sh | bash
# Kitap yazarı için:
#   curl -fsSL https://divit.simetri.app/kur.sh | DIVIT_TUR=yazar bash
#
# Git, Homebrew ya da yönetici parolası gerekmez. Yeniden çalıştırmak
# güvenlidir: kullanıcının dosyalarına dokunmaz, yalnızca Divit'i günceller.
#
# Kullanıcı türü (akademisyen | yazar) klasörleri, kılavuzu ve açık
# eklentileri belirler. Öncelik: DIVIT_TUR > .divit/profil/kimlik.md'deki
# "Kullanıcı türü:" satırı > akademisyen. Türü değiştirmek kurulum
# skill'inin işidir; betik var olan satırı değiştirmez.
#
# Sınama değişkenleri (geliştirici için):
#   DIVIT_TEST=1           Claude uygulaması ve komut satırı kurulmaz, kılavuz açılmaz
#   DIVIT_KAYNAK_ZIP=yol   GitHub yerine yerel repo zip'i kullan
#   DIVIT_HEDEF=yol        Divit klasörünün yeri (varsayılan: ~/Documents/Divit)
#   DIVIT_TUR=yazar        kullanıcı türü (akademisyen | yazar)
set -uo pipefail

REPO="${DIVIT_REPO:-mehmetor/divit}"
DAL="${DIVIT_DAL:-main}"
PANDOC_SURUM="3.11"
PDFCPU_SURUM="0.15.0"
TEST="${DIVIT_TEST:-}"
HEDEF="${DIVIT_HEDEF:-$HOME/Documents/Divit}"
ARACLAR="$HOME/.divit/araclar"
PAZAR_URL="https://raw.githubusercontent.com/$REPO/$DAL/.claude-plugin/marketplace.json"

adim()  { printf '\n\033[1;32m▸ %s\033[0m\n' "$1"; }
bilgi() { printf '  %s\n' "$1"; }
uyari() { printf '  \033[1;33mUYARI:\033[0m %s\n' "$1"; UYARILAR=$((UYARILAR+1)); }
UYARILAR=0

[ "$(uname)" = "Darwin" ] || { echo "Bu betik macOS içindir. Windows'ta kur.ps1 kullanın."; exit 1; }
GECICI="$(mktemp -d)"; trap 'rm -rf "$GECICI"' EXIT

printf '\n\033[1mDivit — yazım tezgâhı · kurulum\033[0m\n'

# ---------------------------------------------------------------- 1
adim "1/6 Claude uygulaması"
if [ -d "/Applications/Claude.app" ] || [ -d "$HOME/Applications/Claude.app" ]; then
  bilgi "Kurulu."
elif [ -n "$TEST" ]; then
  bilgi "(sınama: atlandı)"
else
  bilgi "İndiriliyor…"
  if curl -fsSL -o "$GECICI/Claude.dmg" "https://claude.ai/api/desktop/darwin/universal/dmg/latest/redirect"; then
    MNT="$(hdiutil attach -nobrowse -readonly "$GECICI/Claude.dmg" 2>/dev/null | awk -F'\t' '/\/Volumes\//{print $NF; exit}')"
    if [ -n "$MNT" ] && [ -d "$MNT/Claude.app" ]; then
      if cp -R "$MNT/Claude.app" /Applications/ 2>/dev/null; then
        bilgi "Uygulamalar klasörüne kuruldu."
      else
        mkdir -p "$HOME/Applications" && cp -R "$MNT/Claude.app" "$HOME/Applications/" \
          && bilgi "Kişisel Uygulamalar klasörüne kuruldu."
      fi
      hdiutil detach -quiet "$MNT" 2>/dev/null
    else
      uyari "Uygulama açılamadı. https://claude.ai/download adresinden elle kurun."
    fi
  else
    uyari "İndirilemedi. https://claude.ai/download adresinden elle kurun."
  fi
fi

# ---------------------------------------------------------------- 2
adim "2/6 Claude Code (eklenti kurulumu için)"
export PATH="$HOME/.local/bin:$PATH"
EN_AZ="2.1.224"   # eklentinin zip olarak inmesi (archive kaynağı) bu sürümle geldi
surum() { claude --version 2>/dev/null | head -1 | grep -oE '^[0-9]+\.[0-9]+\.[0-9]+'; }
eski_mi() { [ "$(printf '%s\n%s\n' "$EN_AZ" "$1" | sort -V | head -1)" != "$EN_AZ" ]; }
if command -v claude >/dev/null 2>&1; then
  SV="$(surum)"
  if eski_mi "$SV"; then bilgi "Sürüm $SV eski; güncelleniyor…"; claude update >/dev/null 2>&1; SV="$(surum)"; fi
  if eski_mi "$SV" && [ -z "$TEST" ]; then
    # Eski kopya çoğu zaman npm kurulumudur ve npm'e ulaşamayınca güncellenemez.
    bilgi "Güncellenemedi; resmî kurulum yapılıyor…"
    curl -fsSL https://claude.ai/install.sh | bash >/dev/null 2>&1
    hash -r; SV="$(surum)"     # ~/.local/bin PATH'in başında: yeni kopya öne geçer
  fi
  if eski_mi "$SV"; then
    uyari "Claude Code $SV eski (en az $EN_AZ gerekli) ve güncellenemedi. Eklenti kurulamaz."
    bilgi "  Çözüm: curl -fsSL https://claude.ai/install.sh | bash   (sonra bu kurulumu yeniden çalıştırın)"
  else
    bilgi "Kurulu: $SV"
  fi
elif [ -n "$TEST" ]; then
  bilgi "(sınama: atlandı)"
else
  if curl -fsSL https://claude.ai/install.sh | bash >/dev/null 2>&1 && command -v claude >/dev/null 2>&1; then
    bilgi "Kuruldu."
  else
    uyari "Kurulamadı. Eklenti, uygulama ilk açıldığında kendiliğinden inecek."
  fi
fi

# ---------------------------------------------------------------- 3
adim "3/6 Word ve PDF araçları"
PANDOC="$ARACLAR/pandoc"
if [ -x "$PANDOC" ] && "$PANDOC" --version 2>/dev/null | grep -q "$PANDOC_SURUM"; then
  bilgi "Kurulu."
else
  [ "$(uname -m)" = "arm64" ] && MIMARI="arm64" || MIMARI="x86_64"
  URL="https://github.com/jgm/pandoc/releases/download/$PANDOC_SURUM/pandoc-$PANDOC_SURUM-$MIMARI-macOS.zip"
  if curl -fsSL -o "$GECICI/pandoc.zip" "$URL" && unzip -q "$GECICI/pandoc.zip" -d "$GECICI/pandoc"; then
    BUL="$(find "$GECICI/pandoc" -type f -name pandoc -perm -u+x | head -1)"
    mkdir -p "$ARACLAR" && cp "$BUL" "$PANDOC" && chmod +x "$PANDOC"
    xattr -d com.apple.quarantine "$PANDOC" 2>/dev/null
    "$PANDOC" --version >/dev/null 2>&1 && bilgi "Kuruldu." || uyari "pandoc çalışmadı. Word dosyaları PDF olarak verilmeli."
  else
    uyari "pandoc indirilemedi. Word dosyaları PDF olarak verilmeli."
  fi
fi

# PDF aracı (pdfcpu): birleştirme, sayfa çıkarma, işaretleme.
PDFCPU="$ARACLAR/pdfcpu"
if [ -x "$PDFCPU" ] && "$PDFCPU" version 2>/dev/null | grep -q "$PDFCPU_SURUM"; then
  bilgi "PDF aracı kurulu."
else
  [ "$(uname -m)" = "arm64" ] && PMIMARI="arm64" || PMIMARI="x86_64"
  URL="https://github.com/pdfcpu/pdfcpu/releases/download/v$PDFCPU_SURUM/pdfcpu_${PDFCPU_SURUM}_Darwin_$PMIMARI.tar.xz"
  if curl -fsSL -o "$GECICI/pdfcpu.tar.xz" "$URL" && mkdir -p "$GECICI/pdfcpu" && tar -xf "$GECICI/pdfcpu.tar.xz" -C "$GECICI/pdfcpu"; then
    BUL="$(find "$GECICI/pdfcpu" -type f -name pdfcpu | head -1)"
    mkdir -p "$ARACLAR" && cp "$BUL" "$PDFCPU" && chmod +x "$PDFCPU"
    xattr -d com.apple.quarantine "$PDFCPU" 2>/dev/null
    "$PDFCPU" version >/dev/null 2>&1 && bilgi "PDF aracı kuruldu." || uyari "PDF aracı çalışmadı. PDF birleştirme ve sayfa işleri yapılamaz."
  else
    uyari "PDF aracı indirilemedi. PDF birleştirme ve sayfa işleri yapılamaz."
  fi
fi
# Türkçe harfler için yazı tipi (bir kez).
if [ -x "$PDFCPU" ] && ! "$PDFCPU" fonts list 2>/dev/null | grep -q ArialMT; then
  for f in "/System/Library/Fonts/Supplemental/Arial.ttf" "/Library/Fonts/Arial.ttf"; do
    [ -f "$f" ] && "$PDFCPU" fonts install "$f" >/dev/null 2>&1 && break
  done
fi

# ---------------------------------------------------------------- 4
adim "4/6 Divit klasörü"
if [ -n "${DIVIT_KAYNAK_ZIP:-}" ]; then
  cp "$DIVIT_KAYNAK_ZIP" "$GECICI/repo.zip"
else
  curl -fsSL -o "$GECICI/repo.zip" "https://codeload.github.com/$REPO/zip/refs/heads/$DAL" \
    || { echo "HATA: Divit indirilemedi. İnternet bağlantısını kontrol edin."; exit 1; }
fi
unzip -q "$GECICI/repo.zip" -d "$GECICI/repo"
SABLON="$(find "$GECICI/repo" -maxdepth 3 -type d -path '*/hoca-paketi/Divit' | head -1)"
[ -d "$SABLON" ] || { echo "HATA: Divit şablonu bulunamadı."; exit 1; }

# Kullanıcı türü: DIVIT_TUR > kimlik.md satırı > akademisyen.
KIMLIK="$HEDEF/.divit/profil/kimlik.md"
TUR_VERILDI=""
case "${DIVIT_TUR:-}" in
  akademisyen|yazar) TUR="$DIVIT_TUR"; TUR_VERILDI=1 ;;
  "") ;;
  *) uyari "DIVIT_TUR='$DIVIT_TUR' tanınmadı (akademisyen ya da yazar olmalı); yok sayıldı." ;;
esac
if [ -z "$TUR_VERILDI" ]; then
  TUR="$(sed -n 's/^Kullanıcı türü: *\([a-z]*\).*/\1/p' "$KIMLIK" 2>/dev/null | head -1)"
  [ "$TUR" = "yazar" ] || TUR="akademisyen"
fi
if [ "$TUR" = "yazar" ]; then
  KILAVUZ="KILAVUZ-YAZAR.html"; KART="KART-YAZAR.html"; TUR_KLASORU="kitaplar"; AKADEMIK=false
else
  KILAVUZ="KILAVUZ.html"; KART="KART.html"; TUR_KLASORU="tez-kontrol"; AKADEMIK=true
fi
bilgi "Kullanıcı türü: $TUR"

# kimlik.md'de tür satırı yoksa ilk başlığın hemen altına yazar; varsa dokunmaz.
tur_satiri_yaz() {
  [ -f "$KIMLIK" ] || return
  grep -q '^Kullanıcı türü:' "$KIMLIK" && return
  awk -v s="Kullanıcı türü: $TUR" '{print} !y && /^# /{print s; y=1}' "$KIMLIK" > "$GECICI/kimlik.md" \
    && cat "$GECICI/kimlik.md" > "$KIMLIK"
}

if [ -d "$HEDEF" ]; then
  bilgi "Klasör zaten var. Kişisel dosyalara dokunmadan Divit dosyaları güncelleniyor."
  for f in CLAUDE.md "$KILAVUZ" "$KART"; do cp "$SABLON/$f" "$HEDEF/$f"; done
  [ -d "$HEDEF/tez-kontrol" ] && cp "$SABLON/tez-kontrol/CLAUDE.md" "$HEDEF/tez-kontrol/CLAUDE.md"
  # Türün klasörü yoksa eklenir; hiçbir klasör silinmez.
  [ -d "$HEDEF/$TUR_KLASORU" ] || { cp -R "$SABLON/$TUR_KLASORU" "$HEDEF/" && bilgi "Eklendi: $TUR_KLASORU"; }
  mkdir -p "$HEDEF/.claude/rules" "$HEDEF/.divit"
  cp -R "$SABLON/.claude/rules/." "$HEDEF/.claude/rules/"
  cp -Rn "$SABLON/.divit/." "$HEDEF/.divit/" 2>/dev/null
  for f in "$SABLON/.divit/profil/"*.md; do          # yeni eklenen profil dosyaları
    [ -f "$HEDEF/.divit/profil/$(basename "$f")" ] || cp "$f" "$HEDEF/.divit/profil/"
  done
else
  mkdir -p "$HEDEF"
  # Şablon türe göre: başka türün klasörü ve kılavuzu kopyalanmaz.
  for f in "$SABLON"/* "$SABLON"/.[!.]*; do
    [ -e "$f" ] || continue
    case "$(basename "$f")" in
      tez-kontrol|KILAVUZ.html|KART.html)       [ "$TUR" = "akademisyen" ] || continue ;;
      kitaplar|KILAVUZ-YAZAR.html|KART-YAZAR.html) [ "$TUR" = "yazar" ] || continue ;;
    esac
    cp -R "$f" "$HEDEF/"
  done
  bilgi "Oluşturuldu: $HEDEF"
fi
[ -n "$TUR_VERILDI" ] && tur_satiri_yaz
# Ayarlar Divit'e aittir, her kurulumda yenilenir. Kullanıcının "bir daha sorma"
# izinleri settings.local.json'da durur; orada yalnız iki eklenti anahtarı değişir.
sed -e "s|__PANDOC__|$PANDOC|" -e "s|__PDFCPU__|$PDFCPU|" -e "s|__PDFTOTEXT__||" "$SABLON/.claude/settings.json" > "$HEDEF/.claude/settings.json"
sed -n "s/^## \([0-9][0-9.]*\) ·.*/\1/p" "$(dirname "$SABLON")/../plugins/divit/SURUM.md" | head -1 > "$HEDEF/.divit/kurulum-surumu.txt"
# Hangi eklenti bu klasörde açık: akademik eklenti yalnız akademisyende.
YEREL="$HEDEF/.claude/settings.local.json"
if [ ! -f "$YEREL" ]; then
  printf '{\n  "enabledPlugins": { "divit@divit": true, "divit-akademik@divit": %s }\n}\n' "$AKADEMIK" > "$YEREL"
elif [ "$(tr -d ' \t\r\n' < "$YEREL" | head -c1)" != "{" ] || ! plutil -convert json -o /dev/null "$YEREL" 2>/dev/null; then
  uyari "Klasör ayar dosyası okunamadı; dokunulmadı: .claude/settings.local.json"
else
  # plutil izinleri ve diğer anahtarları korur; önce kopyada denenir.
  cp "$YEREL" "$GECICI/yerel.json"
  plutil -insert enabledPlugins -json '{}' "$GECICI/yerel.json" >/dev/null 2>&1   # varsa hata verir, yok sayılır
  if plutil -replace 'enabledPlugins.divit@divit' -bool true "$GECICI/yerel.json" >/dev/null 2>&1 \
    && plutil -replace 'enabledPlugins.divit-akademik@divit' -bool "$AKADEMIK" "$GECICI/yerel.json" >/dev/null 2>&1; then
    cat "$GECICI/yerel.json" > "$YEREL"
  else
    uyari "Klasör ayar dosyası güncellenemedi; dokunulmadı: .claude/settings.local.json"
  fi
fi
xattr -dr com.apple.quarantine "$HEDEF" 2>/dev/null
find "$HEDEF" -name .gitkeep -delete 2>/dev/null   # git kalıntısı; kullanıcıya görünmesin

# ---------------------------------------------------------------- 5
adim "5/6 Divit eklentisi"
if [ -n "$TEST" ] && [ -z "${CLAUDE_CONFIG_DIR:-}" ]; then
  bilgi "(sınama: atlandı)"
elif command -v claude >/dev/null 2>&1; then
  KAYIT="$GECICI/eklenti.log"
  # Her çalıştırmada: ekle (yoksa), katalogu yenile, kur (yoksa), güncelle (varsa).
  # "Zaten kurulu" da başarı döndüğü için sonuç eklenti listesinden okunur.
  claude plugin marketplace add "$PAZAR_URL" >>"$KAYIT" 2>&1
  claude plugin marketplace update divit >>"$KAYIT" 2>&1
  claude plugin install divit@divit >>"$KAYIT" 2>&1
  claude plugin update divit@divit >>"$KAYIT" 2>&1
  # Akademik eklenti her türde kurulur; klasörde yalnız akademisyende açıktır.
  claude plugin install divit-akademik@divit >>"$KAYIT" 2>&1
  claude plugin update divit-akademik@divit >>"$KAYIT" 2>&1
  LISTE="$(claude plugin list 2>&1)"
  CEKIRDEK='(^|[^-[:alnum:]])divit@divit'   # divit-akademik@divit ile karışmasın
  if printf '%s' "$LISTE" | grep -qE "$CEKIRDEK"; then
    bilgi "Kurulu ve güncel (sürüm $(printf '%s' "$LISTE" | grep -E -A2 "$CEKIRDEK" | grep -oE 'Version: *[^ ]+' | head -1 | awk '{print $2}'))."
  else
    uyari "Şimdi kurulamadı; uygulama ilk açıldığında kendiliğinden inecek."
    bilgi "Ayrıntı (geliştiriciye gönderin):"
    grep -v '^[[:space:]]*$' "$KAYIT" | tail -12 | sed 's/^/    /'
  fi
  if ! printf '%s' "$LISTE" | grep -q 'divit-akademik@divit'; then
    # Henüz yayında olmayabilir; kurulum durmaz. Yazarda bu eklenti zaten kapalı.
    if [ "$TUR" = "akademisyen" ]; then
      uyari "Üniversite işleri eklentisi (divit-akademik) şimdi kurulamadı; kurulumu sonra yeniden çalıştırın."
    else
      bilgi "Ek eklenti (divit-akademik) kurulamadı; sizin işlerinizi etkilemez."
    fi
  fi
else
  bilgi "Uygulama ilk açıldığında kendiliğinden inecek."
fi

# ---------------------------------------------------------------- 6
adim "6/6 Masaüstü kısayolu ve kılavuz"
if [ -d "$HOME/Desktop" ] && [ ! -e "$HOME/Desktop/Divit" ]; then
  ln -s "$HEDEF" "$HOME/Desktop/Divit" && bilgi "Masaüstüne 'Divit' klasör kısayolu kondu."
fi
[ -z "$TEST" ] && open "$HEDEF/$KILAVUZ" 2>/dev/null

printf '\n\033[1mKurulum bitti.\033[0m'
[ "$UYARILAR" -gt 0 ] && printf ' (%s uyarı — yukarıya bakın)' "$UYARILAR"
cat <<'MSG'


Şimdi:
  1. Claude uygulamasını açın. Divit'i kullanacak kişinin hesabıyla giriş yapın.
  2. Üstteki "Code" sekmesine tıklayın.
  3. "Local" seçin → "Select folder" → Belgeler → Divit.
  4. "merhaba" yazın. Divit gerisini kendisi sorar.

MSG
