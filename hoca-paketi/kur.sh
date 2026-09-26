#!/usr/bin/env bash
# Divit kurulum betiği — hocanın makinesinde BİR KEZ çalıştırılır.
# Mehmet çalıştırır; hocanın hiçbir şey yazmasına gerek yok.
set -uo pipefail

GITHUB_KULLANICI="${DIVIT_GITHUB_KULLANICI:-}"
PROFIL="${DIVIT_PROFIL:-}"     # opsiyonel: ön doldurulmuş kimlik.md / alan.md klasörü
ALAN="${DIVIT_ALAN:-}"         # opsiyonel: plugins/divit/alan/<ALAN>.md
HEDEF="${1:-$HOME/Divit}"
KAYNAK="$(cd "$(dirname "$0")" && pwd)/Divit"

echo "Divit kuruluyor → $HEDEF"

if [ -z "$GITHUB_KULLANICI" ]; then
  echo "HATA: GitHub kullanıcı adı verilmedi."
  echo "Kullanım: DIVIT_GITHUB_KULLANICI=kullaniciadi ./kur.sh"
  exit 1
fi

if [ -e "$HEDEF" ]; then
  echo "HATA: $HEDEF zaten var. Üzerine yazmıyorum."
  echo "Var olan kuruluma güncelleme geçmek için klasörü elle taşıyın."
  exit 1
fi

mkdir -p "$HEDEF"
cp -R "$KAYNAK/." "$HEDEF/"

# marketplace adresini yerleştir
ayar="$HEDEF/.claude/settings.json"
sed -i '' "s|GITHUB_KULLANICI|$GITHUB_KULLANICI|" "$ayar" 2>/dev/null \
  || sed -i "s|GITHUB_KULLANICI|$GITHUB_KULLANICI|" "$ayar"

# --- ön doldurulmuş profil (opsiyonel) ---
# Kurulum skill'i bu dosyaları hocaya gösterip onaylatır; onaysız satır silinir.
DEPO="$(cd "$(dirname "$0")/.." && pwd)"
if [ -n "$ALAN" ] && [ -f "$DEPO/plugins/divit/alan/$ALAN.md" ]; then
  cp "$DEPO/plugins/divit/alan/$ALAN.md" "$HEDEF/.claude/profil/alan.md"
  echo "Alan kılavuzu: $ALAN"
fi
if [ -n "$PROFIL" ]; then
  for f in kimlik.md uslup.md alan.md; do
    [ -f "$PROFIL/$f" ] && cp "$PROFIL/$f" "$HEDEF/.claude/profil/$f" && echo "Profil: $f"
  done
fi

# --- gerekli araçlar ---
eksik=()
for k in git pandoc pdftotext; do command -v "$k" >/dev/null || eksik+=("$k"); done

if [ ${#eksik[@]} -gt 0 ]; then
  echo "Eksik araçlar: ${eksik[*]}"
  if command -v brew >/dev/null; then
    for k in "${eksik[@]}"; do
      case "$k" in
        pdftotext) brew install poppler ;;
        *)         brew install "$k" ;;
      esac
    done
  else
    echo "Homebrew yok. Önce kurun: https://brew.sh"
    echo "Sonra: brew install git pandoc poppler"
  fi
fi

# --- ilk yedek ---
if command -v git >/dev/null; then
  git -C "$HEDEF" init -q
  git -C "$HEDEF" add -A
  git -C "$HEDEF" -c user.name=Divit -c user.email=divit@local \
      commit -q -m "kurulum" || true
fi

# --- masaüstüne kısayol ---
if [ -d "$HOME/Desktop" ]; then
  ln -sf "$HEDEF/BASLA.command" "$HOME/Desktop/Divit.command" 2>/dev/null || true
fi

cat <<MSG

Kuruldu.

  Klasör    : $HEDEF
  Başlatmak : masaüstündeki "Divit" simgesine çift tıklayın

İlk açılışta klasöre güven sorulacak, "evet" denmeli.
Sonra hocaya sadece şunu söyletin: "başlayalım"

MSG
