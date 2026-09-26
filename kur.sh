#!/usr/bin/env bash
# Divit — akademik yazım tezgâhı · macOS kurulumu
#
# Tek komut (Terminal'e yapıştırın):
#   curl -fsSL https://raw.githubusercontent.com/mehmetor/divit/main/kur.sh | bash
#
# Git, Homebrew ya da yönetici parolası gerekmez. Yeniden çalıştırmak
# güvenlidir: hocanın dosyalarına dokunmaz, yalnızca Divit'i günceller.
#
# Sınama değişkenleri (geliştirici için):
#   DIVIT_TEST=1           Claude uygulaması ve komut satırı kurulmaz, kılavuz açılmaz
#   DIVIT_KAYNAK_ZIP=yol   GitHub yerine yerel repo zip'i kullan
#   DIVIT_HEDEF=yol        Divit klasörünün yeri (varsayılan: ~/Documents/Divit)
set -uo pipefail

REPO="${DIVIT_REPO:-mehmetor/divit}"
DAL="${DIVIT_DAL:-main}"
PANDOC_SURUM="3.11"
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

printf '\n\033[1mDivit — akademik yazım tezgâhı · kurulum\033[0m\n'

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
adim "3/6 Word dönüştürücü (pandoc $PANDOC_SURUM)"
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

if [ -d "$HEDEF" ]; then
  bilgi "Klasör zaten var. Kişisel dosyalara dokunmadan Divit dosyaları güncelleniyor."
  for f in CLAUDE.md KILAVUZ.html KART.html tez-kontrol/CLAUDE.md; do
    mkdir -p "$HEDEF/$(dirname "$f")"; cp "$SABLON/$f" "$HEDEF/$f"
  done
  mkdir -p "$HEDEF/.claude/rules" "$HEDEF/.divit"
  cp -R "$SABLON/.claude/rules/." "$HEDEF/.claude/rules/"
  cp -Rn "$SABLON/.divit/." "$HEDEF/.divit/" 2>/dev/null
  for f in "$SABLON/.divit/profil/"*.md; do          # yeni eklenen profil dosyaları
    [ -f "$HEDEF/.divit/profil/$(basename "$f")" ] || cp "$f" "$HEDEF/.divit/profil/"
  done
else
  mkdir -p "$HEDEF" && cp -R "$SABLON/." "$HEDEF/"
  bilgi "Oluşturuldu: $HEDEF"
fi
# Ayarlar Divit'e aittir, her kurulumda yenilenir. Hocanın "bir daha sorma"
# izinleri settings.local.json'da durur; ona dokunulmaz.
sed "s|__PANDOC__|$PANDOC|" "$SABLON/.claude/settings.json" > "$HEDEF/.claude/settings.json"
[ -f "$HEDEF/.claude/settings.local.json" ] || \
  printf '{\n  "enabledPlugins": { "divit@divit": true }\n}\n' > "$HEDEF/.claude/settings.local.json"
xattr -dr com.apple.quarantine "$HEDEF" 2>/dev/null
find "$HEDEF" -name .gitkeep -delete 2>/dev/null   # git kalıntısı; hocaya görünmesin

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
  LISTE="$(claude plugin list 2>&1)"
  if printf '%s' "$LISTE" | grep -q 'divit@divit'; then
    bilgi "Kurulu ve güncel (sürüm $(printf '%s' "$LISTE" | grep -A2 'divit@divit' | grep -oE 'Version: *[^ ]+' | awk '{print $2}'))."
  else
    uyari "Şimdi kurulamadı; uygulama ilk açıldığında kendiliğinden inecek."
    bilgi "Ayrıntı (geliştiriciye gönderin):"
    grep -v '^[[:space:]]*$' "$KAYIT" | tail -12 | sed 's/^/    /'
  fi
else
  bilgi "Uygulama ilk açıldığında kendiliğinden inecek."
fi

# ---------------------------------------------------------------- 6
adim "6/6 Masaüstü kısayolu ve kılavuz"
if [ -d "$HOME/Desktop" ] && [ ! -e "$HOME/Desktop/Divit" ]; then
  ln -s "$HEDEF" "$HOME/Desktop/Divit" && bilgi "Masaüstüne 'Divit' klasör kısayolu kondu."
fi
[ -z "$TEST" ] && open "$HEDEF/KILAVUZ.html" 2>/dev/null

printf '\n\033[1mKurulum bitti.\033[0m'
[ "$UYARILAR" -gt 0 ] && printf ' (%s uyarı — yukarıya bakın)' "$UYARILAR"
cat <<'MSG'


Şimdi:
  1. Claude uygulamasını açın. Hocanın hesabıyla giriş yapın.
  2. Üstteki "Code" sekmesine tıklayın.
  3. "Local" seçin → "Select folder" → Belgeler → Divit.
  4. "merhaba" yazın. Divit gerisini kendisi sorar.

MSG
