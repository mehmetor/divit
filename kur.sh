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
# Divit'in koyduğu ve bu kurulumun üstüne yazacağı dosyaların (CLAUDE.md,
# kılavuz, .claude/ ayarları, kurallar) önceki hâli, içerik değişiyorsa,
# .divit/onceki-surumler/kurulum-<tarih-saat>/ altına kopyalanır.
#
# Kullanıcı türü (akademisyen | yazar) klasörleri, kılavuzun açılış
# sekmesini ve açık eklentileri belirler. Öncelik: DIVIT_TUR >
# .divit/profil/kimlik.md'deki "Kullanıcı türü:" satırı > akademisyen.
# Tür satırı yalnız doldurulmamış (şablon) profile yazılır. Dolu profilin
# türüyle çelişen DIVIT_TUR verilirse betik hiçbir şeye dokunmadan durur:
# aynı bilgisayarda ikinci kullanım ayrı klasördür (DIVIT_HEDEF).
#
# Kanal (yayın dalı): DIVIT_DAL > klasördeki .divit/kanal.txt > main.
# İzinli: main, deneme, deneme-*. Klasör kanalını kanal.txt'de
# hatırlar; "güncelle" aynı kanalda kalır.
#
# Sınama değişkenleri (geliştirici için):
#   DIVIT_TEST=1           Claude uygulaması ve komut satırı kurulmaz, kılavuz açılmaz
#   DIVIT_KAYNAK_ZIP=yol   GitHub yerine yerel repo zip'i kullan
#   DIVIT_HEDEF=yol        Divit klasörünün yeri (varsayılan: ~/Documents/Divit)
#   DIVIT_TUR=yazar        kullanıcı türü (akademisyen | yazar)
#   DIVIT_DAL=deneme       kanal (yayın dalı)
set -uo pipefail

REPO="${DIVIT_REPO:-mehmetor/divit}"
PANDOC_SURUM="3.11"
PDFCPU_SURUM="0.15.0"
TEST="${DIVIT_TEST:-}"
HEDEF="${DIVIT_HEDEF:-$HOME/Documents/Divit}"
case "$HEDEF" in /*) ;; *) HEDEF="$PWD/$HEDEF" ;; esac
ARACLAR="$HOME/.divit/araclar"

adim()  { printf '\n\033[1;32m▸ %s\033[0m\n' "$1"; }
bilgi() { printf '  %s\n' "$1"; }
uyari() { printf '  \033[1;33mUYARI:\033[0m %s\n' "$1"; UYARILAR=$((UYARILAR+1)); }
UYARILAR=0

[ "$(uname)" = "Darwin" ] || { echo "Bu betik macOS içindir. Windows'ta kur.ps1 kullanın."; exit 1; }
GECICI="$(mktemp -d)"; trap 'rm -rf "$GECICI"' EXIT

printf '\n\033[1mDivit — yazım tezgâhı · kurulum\033[0m\n'

# Kanal: DIVIT_DAL > klasörün kanal.txt'si > main.
KANAL_DOSYASI="$HEDEF/.divit/kanal.txt"
if [ -n "${DIVIT_DAL:-}" ]; then
  DAL="$DIVIT_DAL"
elif [ -f "$KANAL_DOSYASI" ]; then
  DAL="$(head -1 "$KANAL_DOSYASI" | tr -d ' \t\r')"
else
  DAL="main"
fi
case "$DAL" in
  main|deneme|deneme-?*) ;;
  *) uyari "'$DAL' bilinen bir kanal değil; main kullanılıyor."; DAL="main" ;;
esac
PAZAR_URL="https://raw.githubusercontent.com/$REPO/$DAL/.claude-plugin/marketplace.json"

# Kullanıcı türü: DIVIT_TUR > kimlik.md satırı > akademisyen.
KIMLIK="$HEDEF/.divit/profil/kimlik.md"
PROFIL_DOLU=""
[ -f "$KIMLIK" ] && ! grep -q 'Henüz doldurulmadı' "$KIMLIK" && PROFIL_DOLU=1
PROFIL_TUR="$(sed -n 's/^Kullanıcı türü: *\([a-z]*\).*/\1/p' "$KIMLIK" 2>/dev/null | head -1)"
[ -n "$PROFIL_TUR" ] || PROFIL_TUR="akademisyen"    # satır yoksa akademisyen
TUR_VERILDI=""
case "${DIVIT_TUR:-}" in
  akademisyen|yazar) TUR="$DIVIT_TUR"; TUR_VERILDI=1 ;;
  "") ;;
  *) uyari "DIVIT_TUR='$DIVIT_TUR' tanınmadı (akademisyen ya da yazar olmalı); yok sayıldı." ;;
esac
[ -n "$TUR_VERILDI" ] || { [ "$PROFIL_TUR" = "yazar" ] && TUR="yazar" || TUR="akademisyen"; }

# Dolu profil başka türdense hiçbir şeye dokunmadan dur: bu klasör
# başka bir kullanıma ait (ör. aynı hesapta önceden kurulmuş bir Divit).
if [ -n "$PROFIL_DOLU" ] && [ -n "$TUR_VERILDI" ] && [ "$TUR" != "$PROFIL_TUR" ]; then
  [ "$TUR" = "yazar" ] && YENI_AD="Divit-Yazar" || YENI_AD="Divit-Akademik"
  ONEK=""; [ "$DAL" = "main" ] || ONEK="DIVIT_DAL=$DAL "
  printf '\n\033[1;31mKurulum yapılmadı.\033[0m\n'
  printf 'Bu klasörde başka bir kullanım türüyle kurulmuş bir Divit var:\n  %s\n' "$HEDEF"
  printf 'Klasöre ve içindeki bilgilere dokunulmadı.\n\n'
  printf 'Aynı bilgisayarda ikinci bir kullanım için yeni klasör:\n'
  printf '  curl -fsSL https://raw.githubusercontent.com/%s/%s/kur.sh | %sDIVIT_TUR=%s DIVIT_HEDEF="$HOME/Documents/%s" bash\n\n' \
    "$REPO" "$DAL" "$ONEK" "$TUR" "$YENI_AD"
  exit 2
fi

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
EN_AZ="2.1.280"   # klasör ayarındaki model bu sürümü istiyor (zip kaynağı 2.1.224'ten beri var)
surum() { claude --version 2>/dev/null | head -1 | grep -oE '^[0-9]+\.[0-9]+\.[0-9]+'; }
eski_mi() { [ "$(printf '%s\n%s\n' "$EN_AZ" "$1" | sort -V | head -1)" != "$EN_AZ" ]; }
if command -v claude >/dev/null 2>&1; then
  SV="$(surum)"
  if eski_mi "$SV" && [ -n "$TEST" ]; then
    # Sınama geliştiricinin kendi Claude Code'unu değiştirmez.
    bilgi "(sınama: sürüm $SV eski; güncelleme atlandı)"
  elif eski_mi "$SV"; then
    bilgi "Sürüm $SV eski; güncelleniyor…"; claude update >/dev/null 2>&1; SV="$(surum)"
    if eski_mi "$SV"; then
      # Eski kopya çoğu zaman npm kurulumudur ve npm'e ulaşamayınca güncellenemez.
      bilgi "Güncellenemedi; resmî kurulum yapılıyor…"
      curl -fsSL https://claude.ai/install.sh | bash >/dev/null 2>&1
      hash -r; SV="$(surum)"     # ~/.local/bin PATH'in başında: yeni kopya öne geçer
    fi
  fi
  if eski_mi "$SV"; then
    uyari "Claude Code $SV eski (en az $EN_AZ gerekli) ve güncellenemedi. Divit klasörü açılınca 'model desteklenmiyor' hatası çıkabilir."
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

if [ "$TUR" = "yazar" ]; then
  TUR_KLASORU="kitaplar"; AKADEMIK=false
else
  TUR_KLASORU="tez-kontrol"; AKADEMIK=true
fi
bilgi "Kullanıcı türü: $TUR"
[ "$DAL" = "main" ] || bilgi "Kanal: $DAL"

# Tür satırı yalnız doldurulmamış profile yazılır (ilk başlığın altına ya da
# var olan satırın yerine). Dolu profile hiç dokunulmaz.
tur_satiri_yaz() {
  [ -f "$KIMLIK" ] || return
  grep -q 'Henüz doldurulmadı' "$KIMLIK" || return
  awk -v s="Kullanıcı türü: $TUR" '/^Kullanıcı türü:/{next} {print} !y && /^# /{print s; y=1}' "$KIMLIK" > "$GECICI/kimlik.md" \
    && yerlestir ".divit/profil/kimlik.md" "$GECICI/kimlik.md"
}
# Önceki sürüm kuralı: üstüne yazılacak Divit dosyasının klasördeki hâli,
# yeni içerikten farklıysa, .divit/onceki-surumler/kurulum-<zaman>/<göreli yol>
# altına kopyalanır. İlk kurulumda ve değişmeyen dosyada yedek yoktur; yedek
# alınamazsa dosyaya dokunulmaz (uyarı). Yalnız bu betiğin yazdığı dosyalar
# için kullanılır; kullanıcının belgeleri bu yoldan geçmez.
YEDEK_KLASORU="$HEDEF/.divit/onceki-surumler/kurulum-$(date +%Y-%m-%d-%H%M%S)"
YEDEK_SAYISI=0
# yedekle <göreli yol> <yeni içeriğin dosyası>: 0 = yazılabilir, 1 = dokunma
ILK_KURULUM=""                                     # klasör bu çalıştırmada açıldıysa 1
yedekle() {
  local gore="$1" yeni="$2" eski="$HEDEF/$1"
  [ -z "$ILK_KURULUM" ] && [ -f "$eski" ] || return 0   # ilk kurulum ya da dosya yok: yedeklenecek şey yok
  cmp -s "$eski" "$yeni" && return 0               # içerik aynı: yedek gereksiz
  if mkdir -p "$YEDEK_KLASORU/$(dirname "$gore")" && cp -p "$eski" "$YEDEK_KLASORU/$gore"; then
    YEDEK_SAYISI=$((YEDEK_SAYISI+1)); return 0
  fi
  uyari "Önceki hâli saklanamadı, dosyaya dokunulmadı: $gore"
  return 1
}
# yerlestir <göreli yol> <yeni içeriğin dosyası>: yedekle, sonra üstüne yaz.
yerlestir() {
  yedekle "$1" "$2" || return 1
  mkdir -p "$(dirname "$HEDEF/$1")" && cat "$2" > "$HEDEF/$1"
}
# Kılavuz tek dosyadır; açılış sekmesi kök etiketteki data-rol'dür.
kilavuz_yaz() {
  sed "s|<html lang=\"tr\" data-rol=\"\">|<html lang=\"tr\" data-rol=\"$TUR\">|" "$SABLON/KILAVUZ.html" > "$GECICI/KILAVUZ.html"
  yerlestir "KILAVUZ.html" "$GECICI/KILAVUZ.html"
}
# Klasörün CLAUDE.md'si: araç yolları kurulumda yazılır.
claude_md_yaz() {
  sed -e "s|__PANDOC__|$PANDOC|" -e "s|__PDFCPU__|$PDFCPU|" -e "s|__PDFTOTEXT__|yok|" "$SABLON/CLAUDE.md" > "$GECICI/CLAUDE.md"
  yerlestir "CLAUDE.md" "$GECICI/CLAUDE.md"
}

if [ -d "$HEDEF" ]; then
  bilgi "Klasör zaten var. Kişisel dosyalara dokunmadan Divit dosyaları güncelleniyor."
  claude_md_yaz
  [ -d "$HEDEF/tez-kontrol" ] && yerlestir "tez-kontrol/CLAUDE.md" "$SABLON/tez-kontrol/CLAUDE.md"
  # Türün klasörü yoksa eklenir; hiçbir klasör silinmez.
  [ -d "$HEDEF/$TUR_KLASORU" ] || { cp -R "$SABLON/$TUR_KLASORU" "$HEDEF/" && bilgi "Eklendi: $TUR_KLASORU"; }
  # Gizli bölme (Divit okumaz) akademisyende; eski klasörlere de eklenir.
  if [ "$TUR" = "akademisyen" ] && [ ! -d "$HEDEF/gizli" ]; then cp -R "$SABLON/gizli" "$HEDEF/" && bilgi "Eklendi: gizli"; fi
  mkdir -p "$HEDEF/.claude/rules" "$HEDEF/.divit"
  while IFS= read -r f; do                          # kural dosyaları tek tek (boru yok: sayaç korunsun)
    yerlestir ".claude/rules/${f#./}" "$SABLON/.claude/rules/$f"
  done < <(cd "$SABLON/.claude/rules" && find . -type f)
  cp -Rn "$SABLON/.divit/." "$HEDEF/.divit/" 2>/dev/null
  for f in "$SABLON/.divit/profil/"*.md; do          # yeni eklenen profil dosyaları
    [ -f "$HEDEF/.divit/profil/$(basename "$f")" ] || cp "$f" "$HEDEF/.divit/profil/"
  done
else
  ILK_KURULUM=1
  mkdir -p "$HEDEF"
  # Şablon türe göre: başka türün klasörü ve kılavuzu kopyalanmaz.
  for f in "$SABLON"/* "$SABLON"/.[!.]*; do
    [ -e "$f" ] || continue
    case "$(basename "$f")" in
      tez-kontrol) [ "$TUR" = "akademisyen" ] || continue ;;
      kitaplar)    [ "$TUR" = "yazar" ] || continue ;;
      gizli)       [ "$TUR" = "akademisyen" ] || continue ;;
      *.html|CLAUDE.md) continue ;;     # aşağıda yazılır; eski kart/kılavuzlar kopyalanmaz
    esac
    cp -R "$f" "$HEDEF/"
  done
  claude_md_yaz
  bilgi "Oluşturuldu: $HEDEF"
fi
kilavuz_yaz
[ -n "$TUR_VERILDI" ] && tur_satiri_yaz
printf '%s\n' "$DAL" > "$KANAL_DOSYASI"
# Ayarlar Divit'e aittir, her kurulumda yenilenir. Kullanıcının "bir daha sorma"
# izinleri settings.local.json'da durur; orada yalnız iki eklenti anahtarı değişir.
# Pazar yeri adresi kanala göre (klasör açılınca uygulama da aynı kanaldan alır).
sed -e "s|__PANDOC__|$PANDOC|" -e "s|__PDFCPU__|$PDFCPU|" -e "s|__PDFTOTEXT__||" \
  -e "s|https://raw.githubusercontent.com/[^\"]*/\.claude-plugin/marketplace\.json|$PAZAR_URL|" \
  "$SABLON/.claude/settings.json" > "$GECICI/settings.json"
yerlestir ".claude/settings.json" "$GECICI/settings.json"
sed -n "s/^## \([0-9][0-9.]*\) ·.*/\1/p" "$(dirname "$SABLON")/../plugins/divit/SURUM.md" | head -1 > "$HEDEF/.divit/kurulum-surumu.txt"
# Hangi eklenti bu klasörde açık: akademik eklenti yalnız akademisyende.
YEREL="$HEDEF/.claude/settings.local.json"
if [ ! -f "$YEREL" ]; then
  printf '{\n  "enabledPlugins": { "divit@divit": true, "divit-akademik@divit": %s }\n}\n' "$AKADEMIK" > "$YEREL"
elif [ "$(tr -d ' \t\r\n' < "$YEREL" | head -c1)" != "{" ] || ! plutil -convert json -o /dev/null "$YEREL" 2>/dev/null; then
  uyari "Klasör ayar dosyası okunamadı; dokunulmadı: .claude/settings.local.json"
elif [ "$(plutil -extract 'enabledPlugins.divit@divit' raw -o - "$YEREL" 2>/dev/null)" = "true" ] \
  && [ "$(plutil -extract 'enabledPlugins.divit-akademik@divit' raw -o - "$YEREL" 2>/dev/null)" = "$AKADEMIK" ]; then
  :   # iki anahtar zaten doğru: dosyaya dokunulmaz (plutil her yazışta biçimi değiştirir, gereksiz yedek olmasın)
else
  # plutil izinleri ve diğer anahtarları korur; önce kopyada denenir.
  cp "$YEREL" "$GECICI/yerel.json"
  plutil -insert enabledPlugins -json '{}' "$GECICI/yerel.json" >/dev/null 2>&1   # varsa hata verir, yok sayılır
  if plutil -replace 'enabledPlugins.divit@divit' -bool true "$GECICI/yerel.json" >/dev/null 2>&1 \
    && plutil -replace 'enabledPlugins.divit-akademik@divit' -bool "$AKADEMIK" "$GECICI/yerel.json" >/dev/null 2>&1; then
    yerlestir ".claude/settings.local.json" "$GECICI/yerel.json"
  else
    uyari "Klasör ayar dosyası güncellenemedi; dokunulmadı: .claude/settings.local.json"
  fi
fi
xattr -dr com.apple.quarantine "$HEDEF" 2>/dev/null
find "$HEDEF" -name .gitkeep -delete 2>/dev/null   # git kalıntısı; kullanıcıya görünmesin
[ "$YEDEK_SAYISI" -gt 0 ] && bilgi "Değiştirilen $YEDEK_SAYISI ayar dosyasının önceki hâli saklandı: ${YEDEK_KLASORU#$HEDEF/}"

# ---------------------------------------------------------------- 5
adim "5/6 Divit eklentisi"
if [ -n "$TEST" ] && [ -z "${CLAUDE_CONFIG_DIR:-}" ]; then
  bilgi "(sınama: atlandı)"
elif command -v claude >/dev/null 2>&1; then
  KAYIT="$GECICI/eklenti.log"
  # Ev klasöründen: bir klasörün kendi ayarı pazar yeri adresini karıştırmasın.
  cd "$HOME" 2>/dev/null || cd /
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
  # divit pazar yeri beklenen adreste mi? Başka kaynağa kayıtlıysa ekleme
  # "source differs" ile düşer, güncelleme eski kaynaktan yapılır: başarı sanılmasın.
  PAZARLAR="$(claude plugin marketplace list --json 2>/dev/null)"
  if [ "$(printf '%s' "$PAZARLAR" | tr -d ' \t\r\n' | head -c1)" = "[" ]; then
    DIVIT_PAZAR="$(printf '%s\n' "$PAZARLAR" | awk '/^  \{/{b=""} {b=b $0 "\n"} /^  \}/{if (b ~ /"name": "divit"/) printf "%s", b}')"
    if [ -n "$DIVIT_PAZAR" ] && ! printf '%s' "$DIVIT_PAZAR" | grep -qF "\"url\": \"$PAZAR_URL\""; then
      BASKA_KAYNAK="$(printf '%s' "$DIVIT_PAZAR" | sed -nE 's/.*"(url|repo|path)": "([^"]*)".*/\2/p' | head -1)"
    fi
  fi
  if [ -z "${BASKA_KAYNAK:-}" ] && grep -q 'source differs' "$KAYIT"; then BASKA_KAYNAK="(bilinmiyor)"; fi
  if [ -n "${BASKA_KAYNAK:-}" ]; then
    printf '  \033[1;31mHATA:\033[0m Divit bu bilgisayarda başka bir kaynaktan kurulu:\n    %s\n' "$BASKA_KAYNAK"
  elif printf '%s' "$LISTE" | grep -qE "$CEKIRDEK"; then
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

# Pazar yeri başka kaynaktaysa kurulum bitmiş sayılmaz.
if [ -n "${BASKA_KAYNAK:-}" ]; then
  printf '\n\033[1;31mKurulum tamamlanmadı.\033[0m\n'
  cat <<MSG
Bu bilgisayarda Divit başka bir kaynaktan kurulu; yeni sürüm gelemedi.
Önce şunu çalıştırın:

  claude plugin marketplace remove divit

sonra bu kurulumu yeniden çalıştırın. Klasördeki dosyalarınız silinmez.

MSG
  exit 1
fi

# ---------------------------------------------------------------- 6
adim "6/6 Masaüstü kısayolu ve kılavuz"
if [ -d "$HOME/Desktop" ] && [ ! -e "$HOME/Desktop/Divit" ]; then
  ln -s "$HEDEF" "$HOME/Desktop/Divit" && bilgi "Masaüstüne 'Divit' klasör kısayolu kondu."
fi
[ -z "$TEST" ] && open "$HEDEF/KILAVUZ.html" 2>/dev/null

# Klasör seçerken gösterilecek yer: Belgeler altındaysa kısa ad, değilse tam yol.
if [ "$(cd "$(dirname "$HEDEF")" 2>/dev/null && pwd -P)" = "$(cd "$HOME/Documents" 2>/dev/null && pwd -P)" ]; then
  KLASOR_YERI="Belgeler → $(basename "$HEDEF")"
else
  KLASOR_YERI="$(cd "$HEDEF" && pwd)"
fi

printf '\n\033[1mKurulum bitti.\033[0m'
[ "$UYARILAR" -gt 0 ] && printf ' (%s uyarı — yukarıya bakın)' "$UYARILAR"
cat <<MSG


Şimdi:
  1. Claude uygulamasını açın. Divit'i kullanacak kişinin hesabıyla giriş yapın.
  2. Üstteki "Code" sekmesine tıklayın.
  3. "Local" seçin → "Select folder" → $KLASOR_YERI
  4. "merhaba" yazın. Divit gerisini kendisi sorar.

MSG
[ "$DAL" = "main" ] || printf 'Güncellemeler şu dağıtımdan gelir: %s\n\n' "$DAL"
