#!/usr/bin/env bash
# Divit kurulum betiği — hocanın makinesinde BİR KEZ çalıştırılır.
# Mehmet çalıştırır; hocanın hiçbir şey yazmasına gerek yok.
set -uo pipefail

GITHUB_KULLANICI="${DIVIT_GITHUB_KULLANICI:-mehmetor}"
PROFIL="${DIVIT_PROFIL:-}"     # opsiyonel: ön doldurulmuş kimlik.md / alan.md klasörü
ALAN="${DIVIT_ALAN:-}"         # opsiyonel: plugins/divit/alan/<ALAN>.md
SESSIZ="${DIVIT_SESSIZ:-}"     # sınama: Claude Code/eklenti kurma, kılavuz açma
HEDEF="${1:-$HOME/Divit}"
KAYNAK="$(cd "$(dirname "$0")" && pwd)/Divit"

echo "Divit kuruluyor → $HEDEF"

if [ -z "$GITHUB_KULLANICI" ]; then  # boş bırakılırsa
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
# İndirilen/AirDrop ile gelen dosyalardaki karantina işaretini kaldır;
# yoksa hocanın çift tıkladığı simge "tanınmayan geliştirici" diye engellenir.
command -v xattr >/dev/null && xattr -dr com.apple.quarantine "$HEDEF" 2>/dev/null
chmod +x "$HEDEF/BASLA.command"

# marketplace adresini yerleştir
ayar="$HEDEF/.claude/settings.json"
sed -i '' "s|GITHUB_KULLANICI|$GITHUB_KULLANICI|" "$ayar" 2>/dev/null \
  || sed -i "s|GITHUB_KULLANICI|$GITHUB_KULLANICI|" "$ayar"

# --- ön doldurulmuş profil (opsiyonel) ---
# Kurulum skill'i bu dosyaları hocaya gösterip onaylatır; onaysız satır silinir.
# Alan kılavuzu: paket içinde (alan/) ya da repo içinde (plugins/divit/alan/)
BURASI="$(cd "$(dirname "$0")" && pwd)"
for aday in "$BURASI/alan/$ALAN.md" "$BURASI/../plugins/divit/alan/$ALAN.md"; do
  if [ -n "$ALAN" ] && [ -f "$aday" ]; then
    cp "$aday" "$HEDEF/.claude/profil/alan.md"; echo "Alan kılavuzu: $ALAN"; break
  fi
done
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

# --- Claude Code ---
if [ -n "$SESSIZ" ]; then echo "(sınama kipi: Claude Code ve eklenti adımı atlandı)"
elif ! command -v claude >/dev/null 2>&1 && [ ! -x "$HOME/.local/bin/claude" ]; then
  echo "Claude Code kuruluyor…"
  curl -fsSL https://claude.ai/install.sh | bash
fi
export PATH="$HOME/.local/bin:$PATH"

# --- Divit eklentisi ---
[ -n "$SESSIZ" ] || {
# Klasöre güven verildiğinde otomatik kurulum da var; ama ona güvenmeyip
# burada açıkça kuruyoruz. Başarısız olursa kurulum yine de sürer.
if command -v claude >/dev/null 2>&1; then
  if claude plugin marketplace add "$GITHUB_KULLANICI/divit" >/dev/null 2>&1 \
     && (cd "$HEDEF" && claude plugin install divit@divit --scope project >/dev/null 2>&1); then
    echo "Divit eklentisi kuruldu."
  else
    echo "UYARI: Divit eklentisi kurulamadı (internet ya da GitHub reposu?)."
    echo "       İlk açılışta klasöre güven verilince yeniden denenecek."
  fi
else
  echo "UYARI: Claude Code kurulamadı. https://claude.ai/code adresinden kurun."
fi
}

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

# --- kılavuzu aç ---
[ -z "$SESSIZ" ] && [ -f "$HEDEF/KILAVUZ.html" ] && command -v open >/dev/null && open "$HEDEF/KILAVUZ.html"

cat <<MSG

Kuruldu.

  Klasör    : $HEDEF
  Başlatmak : masaüstündeki "Divit" simgesine çift tıklayın

Sıradaki adımlar (belgeler/KURULUM-REHBERI.md, Bölüm C):
  1. Masaüstündeki Divit simgesine çift tıklayın.
  2. Claude hesabıyla giriş yapın (yalnızca ilk kez).
  3. Klasöre güven sorusuna "Yes" deyin.
  4. Hoca şunu yazsın: başlayalım

MSG
