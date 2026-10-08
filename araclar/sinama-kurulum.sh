#!/usr/bin/env bash
# Divit — kurulum betiğinin (kur.sh) davranışını yalıtılmış ortamda sınar.
#
#   araclar/sinama-kurulum.sh [--sakla]
#
# Bu dalın çalışma ağacından bir zip yapar (commit'lenmemiş değişiklikler
# dahil, izlenmeyen dosyalar hariç) ve kur.sh'yi DIVIT_TEST=1,
# DIVIT_KAYNAK_ZIP, geçici HOME, geçici DIVIT_HEDEF ve geçici
# CLAUDE_CONFIG_DIR ile çalıştırır. Eklenti adımı gerçek pazar yerinden
# (main ve deneme dalları) iner: internet gerekir, origin'e push YOKTUR.
#
#   i    boş klasöre akademisyen
#   ii   boş klasöre yazar
#   iii  dolu profil, türü çelişen DIVIT_TUR → durur, hiçbir dosya değişmez
#   iv   değişkensiz yeniden kurulum → bugünkü gibi
#   v    divit pazar yeri başka adreste → "Kurulum bitti" yok, çözüm var, çıkış ≠ 0
#   vi   son mesajdaki klasör yeri
#   vii  tek kılavuz, kart yok, data-rol türe göre
#   viii settings.json izinleri, CLAUDE.md "Araçlar"
#   ix   kanal: .divit/kanal.txt, DIVIT_DAL'sız yeniden kurulum aynı kanalda
#   x    DIVIT_TEST=1'de "claude update" ve resmî kurulum çağrılmaz
#   xi   yedek: ilk kurulumda yok, değişmeyen dosya yedeklenmez, elle
#        değiştirilen Divit dosyası önceki hâliyle saklanır, hoca dosyası girmez
#
# Her ölçüm için GEÇTİ / KALDI / ATLANDI satırı basar; KALDI varsa çıkış 1.
set -uo pipefail

SAKLA=""
[ "${1:-}" = "--sakla" ] && SAKLA=1

cd "$(dirname "$0")/.."
KOK="$(pwd)"

KALAN=0
sonuc() {  # sonuc GEÇTİ|KALDI|ATLANDI|BİLGİ <kod> <metin>
  printf '%-7s %-5s %s\n' "$1" "$2" "$3"
  [ "$1" = "KALDI" ] && KALAN=$((KALAN+1))
  return 0
}
olc() {    # olc <kod> <metin> <komut...>: komut başarılıysa GEÇTİ
  local kod="$1" metin="$2"; shift 2
  if "$@"; then sonuc GEÇTİ "$kod" "$metin"; else sonuc KALDI "$kod" "$metin"; fi
}
bolum() { printf '\n== %s\n' "$1"; }
py() { python3 -c "$@"; }

# ---------------------------------------------------------------- hazırlık
bolum "Hazırlık"
CLI_SURUM_ONCE="$(/opt/homebrew/bin/claude --version 2>/dev/null)"
GERCEK=(~/.claude/settings.json ~/.claude/plugins/installed_plugins.json ~/.claude/plugins/known_marketplaces.json)
gercek_ozet() { shasum "${GERCEK[@]}" 2>/dev/null; }
GERCEK_ONCE="$(gercek_ozet)"
BELGELER_ONCE="$(stat -f '%m %z' ~/Documents 2>/dev/null)"
echo "claude: $(command -v claude) $(claude --version 2>/dev/null)"

G="$(mktemp -d /tmp/divit-kurulum.XXXXXX)"
temizle() { [ -n "$SAKLA" ] && { echo "Geçiciler saklandı: $G"; return; }; rm -rf "$G"; }
trap temizle EXIT
EV="$G/ev"; B="$EV/Documents"
mkdir -p "$B"
echo "Geçici dizin: $G"

# Çalışma ağacının anlık görüntüsü (stash yığınına dokunmaz).
AGAC="$(git stash create 2>/dev/null)"; AGAC="${AGAC:-HEAD}"
git archive --format=zip --prefix=divit-yerel/ -o "$G/repo.zip" "$AGAC" || { echo "HATA: zip yapılamadı."; exit 1; }
echo "Kaynak: $(git rev-parse --short=12 HEAD)$([ "$AGAC" = HEAD ] || echo ' + commit'"'"'lenmemiş değişiklikler')"
# Araçlar indirilmesin: bu makinedeki kopya geçici eve.
if [ -x ~/.divit/araclar/pandoc ]; then mkdir -p "$EV/.divit" && cp -R ~/.divit/araclar "$EV/.divit/"; fi

# kur <ad> [DEĞİŞKEN=değer …]: kur.sh'yi geçici evde çalıştırır; çıktı $G/<ad>.log, kod $G/<ad>.kod
kur() {
  local ad="$1"; shift
  (cd "$G" && env -u CLAUDE_CONFIG_DIR -u DIVIT_DAL -u DIVIT_TUR -u DIVIT_HEDEF -u DIVIT_REPO HOME="$EV" DIVIT_TEST=1 DIVIT_KAYNAK_ZIP="$G/repo.zip" "$@" bash "$KOK/kur.sh") >"$G/$ad.log" 2>&1
  echo $? >"$G/$ad.kod"
  sed 's/\x1b\[[0-9;]*m//g' "$G/$ad.log" >"$G/$ad.txt"
}
kod() { cat "$G/$1.kod"; }
var() { grep -qF -- "$2" "$G/$1.txt"; }        # var <ad> <metin>
imza() { (cd "$1" && find . -type f -print0 | LC_ALL=C sort -z | xargs -0 shasum | shasum | cut -c1-40); }
yc() { local cfg="$1"; shift; (cd "$EV" && CLAUDE_CONFIG_DIR="$cfg" HOME="$EV" claude "$@"); }
SABLON_ROLLU=""
grep -qF '<html lang="tr" data-rol="">' hoca-paketi/Divit/KILAVUZ.html && SABLON_ROLLU=1
PAZAR_MAIN="https://raw.githubusercontent.com/mehmetor/divit/main/.claude-plugin/marketplace.json"
PAZAR_DENEME="https://raw.githubusercontent.com/mehmetor/divit/deneme/.claude-plugin/marketplace.json"
DOLU_PROFIL='# Kim

Ad: Örnek Hoca (sınama profili)
Unvan: Prof. Dr.
Kurum: Örnek Üniversitesi Ziraat Fakültesi
'

# ---------------------------------------------------------------- i
bolum "i) Boş klasöre akademisyen"
A="$B/Divit"
kur i DIVIT_TUR=akademisyen DIVIT_HEDEF="$A" CLAUDE_CONFIG_DIR="$G/cfg-a" DIVIT_DAL=main
grep -E 'Kullanıcı türü|Kurulu ve güncel|UYARI|HATA' "$G/i.txt" | sed 's/^/  kur.sh: /'
olc i1 "çıkış 0, 'Kurulum bitti'" bash -c '[ "$1" = 0 ] && grep -q "Kurulum bitti" "$2"' _ "$(kod i)" "$G/i.txt"
olc i2 "tez-kontrol var, kitaplar yok" bash -c '[ -d "$1/tez-kontrol" ] && [ ! -e "$1/kitaplar" ]' _ "$A"
olc i3 "kimlik.md'ye (şablon) 'Kullanıcı türü: akademisyen' yazıldı" grep -q '^Kullanıcı türü: akademisyen$' "$A/.divit/profil/kimlik.md"
olc i4 "iki eklenti açık, divit kurulu ve güncel" bash -c 'grep -q "\"divit-akademik@divit\": true" "$1" && grep -q "Kurulu ve güncel" "$2"' _ "$A/.claude/settings.local.json" "$G/i.txt"

# ---------------------------------------------------------------- ii / ix
bolum "ii) Boş klasöre yazar (deneme kanalıyla; ix'in ilk yarısı)"
Y="$B/Divit-Yazar"
kur ii DIVIT_TUR=yazar DIVIT_HEDEF="$Y" CLAUDE_CONFIG_DIR="$G/cfg-y" DIVIT_DAL=deneme
grep -E 'Kullanıcı türü|Kanal|Kurulu ve güncel|UYARI|HATA' "$G/ii.txt" | sed 's/^/  kur.sh: /'
olc ii1 "çıkış 0, 'Kurulum bitti'" bash -c '[ "$1" = 0 ] && grep -q "Kurulum bitti" "$2"' _ "$(kod ii)" "$G/ii.txt"
olc ii2 "kitaplar var, tez-kontrol yok" bash -c '[ -d "$1/kitaplar" ] && [ ! -e "$1/tez-kontrol" ]' _ "$Y"
olc ii3 "kimlik.md'ye 'Kullanıcı türü: yazar' yazıldı" grep -q '^Kullanıcı türü: yazar$' "$Y/.divit/profil/kimlik.md"
olc ii4 "akademik eklenti klasörde kapalı" grep -q '"divit-akademik@divit": false' "$Y/.claude/settings.local.json"

# ---------------------------------------------------------------- iii
bolum "iii) Dolu profil + çelişen DIVIT_TUR → durur"
printf '%s' "$DOLU_PROFIL" >"$A/.divit/profil/kimlik.md"          # eski hoca: tür satırı yok
printf '<p>eski kart</p>\n' >"$A/KART.html"                         # eski klasörden kalma (iv/vii)
py 'import json,sys
p=sys.argv[1]; d=json.load(open(p))
d.setdefault("permissions",{}).setdefault("allow",[]).append("Bash(ls *)")
json.dump(d,open(p,"w"),indent=2)' "$A/.claude/settings.local.json"
IMZA_A="$(imza "$A")"
kur iii DIVIT_TUR=yazar DIVIT_HEDEF="$A" CLAUDE_CONFIG_DIR="$G/cfg-a"
sed -n '/Kurulum yapılmadı/,$p' "$G/iii.txt" | sed 's/^/  kur.sh: /'
olc iii1 "çıkış ≠ 0, 'Kurulum bitti' yok" bash -c '[ "$1" != 0 ] && ! grep -q "Kurulum bitti" "$2"' _ "$(kod iii)" "$G/iii.txt"
olc iii2 "açıklama ve yeni klasör komutu (Divit-Yazar)" bash -c 'grep -q "başka bir kullanım türüyle kurulmuş bir Divit var" "$1" && grep -qF "DIVIT_TUR=yazar DIVIT_HEDEF=\"\$HOME/Documents/Divit-Yazar\" bash" "$1"' _ "$G/iii.txt"
olc iii3 "klasördeki hiçbir dosya değişmedi (shasum)" test "$IMZA_A" = "$(imza "$A")"
C="$G/tersi/Divit"; mkdir -p "$(dirname "$C")"; cp -R "$Y" "$C"
printf '# Kim\n\nKullanıcı türü: yazar\nAd: Örnek Yazar\n' >"$C/.divit/profil/kimlik.md"
IMZA_C="$(imza "$C")"
kur iiib DIVIT_TUR=akademisyen DIVIT_HEDEF="$C"
olc iii4 "tersi (dolu yazar profili + DIVIT_TUR=akademisyen) de durur, dosya değişmez" \
  bash -c '[ "$1" != 0 ] && grep -qF "DIVIT_HEDEF=\"\$HOME/Documents/Divit-Akademik\"" "$2" && [ "$3" = "$4" ]' _ "$(kod iiib)" "$G/iiib.txt" "$IMZA_C" "$(imza "$C")"

# ---------------------------------------------------------------- iv
bolum "iv) Değişkensiz yeniden kurulum (hocanın yolu)"
KIMLIK_ONCE="$(shasum <"$A/.divit/profil/kimlik.md")"
IZIN_ONCE="$(py 'import json,sys; print(json.dumps(json.load(open(sys.argv[1])).get("permissions"),sort_keys=True))' "$A/.claude/settings.local.json")"
kur iv DIVIT_HEDEF="$A" CLAUDE_CONFIG_DIR="$G/cfg-a"
grep -E 'Kullanıcı türü|Kurulu ve güncel|UYARI|HATA' "$G/iv.txt" | sed 's/^/  kur.sh: /'
olc iv1 "çıkış 0, 'Kurulum bitti', tür akademisyen" bash -c '[ "$1" = 0 ] && grep -q "Kurulum bitti" "$2" && grep -q "Kullanıcı türü: akademisyen" "$2"' _ "$(kod iv)" "$G/iv.txt"
olc iv2 "dolu kimlik.md değişmedi (tür satırı eklenmedi)" test "$KIMLIK_ONCE" = "$(shasum <"$A/.divit/profil/kimlik.md")"
olc iv3 "elle eklenen izin duruyor, iki eklenti açık" \
  py 'import json,sys; d=json.load(open(sys.argv[1]))
sys.exit(0 if json.dumps(d.get("permissions"),sort_keys=True)==sys.argv[2] and d["enabledPlugins"]=={"divit@divit":True,"divit-akademik@divit":True} else 1)' "$A/.claude/settings.local.json" "$IZIN_ONCE"
olc iv4 "divit kurulu ve güncel (pazar yeri main)" grep -q 'Kurulu ve güncel' "$G/iv.txt"

# ---------------------------------------------------------------- v
bolum "v) divit pazar yeri başka adreste kayıtlı"
V="$B/Divit-V"; CV="$G/cfg-v"
yc "$CV" plugin marketplace add "$PAZAR_DENEME" >"$G/v-hazirlik.log" 2>&1
kur v DIVIT_HEDEF="$V" CLAUDE_CONFIG_DIR="$CV" DIVIT_DAL=main
sed -n '/HATA/,/^$/p;/Kurulum tamamlanmadı/,$p' "$G/v.txt" | sed 's/^/  kur.sh: /'
olc v1 "çıkış ≠ 0, 'Kurulum bitti' yok" bash -c '[ "$1" != 0 ] && ! grep -q "Kurulum bitti" "$2"' _ "$(kod v)" "$G/v.txt"
olc v2 "ne olduğu ve çözüm komutu yazıyor" bash -c 'grep -q "başka bir kaynaktan kurulu" "$1" && grep -qF "claude plugin marketplace remove divit" "$1" && grep -qF "/deneme/" "$1"' _ "$G/v.txt"
yc "$CV" plugin marketplace remove divit >>"$G/v-hazirlik.log" 2>&1
kur v2 DIVIT_HEDEF="$V" CLAUDE_CONFIG_DIR="$CV" DIVIT_DAL=main
olc v3 "çözüm komutundan sonra kurulum biter (çıkış 0, kurulu ve güncel)" \
  bash -c '[ "$1" = 0 ] && grep -q "Kurulum bitti" "$2" && grep -q "Kurulu ve güncel" "$2"' _ "$(kod v2)" "$G/v2.txt"

# ---------------------------------------------------------------- vi
bolum "vi) Son mesajdaki klasör yeri"
olc vi1 "Belgeler altında: 'Belgeler → Divit-Yazar'" grep -qF '"Select folder" → Belgeler → Divit-Yazar' "$G/ii.txt"
olc vi2 "Belgeler altında: 'Belgeler → Divit'" grep -qE '"Select folder" → Belgeler → Divit$' "$G/iv.txt"
D="$G/baska yer/Divit"
kur vi DIVIT_HEDEF="$D"
olc vi3 "Belgeler dışında: tam yol" grep -qF "\"Select folder\" → $D" "$G/vi.txt"

# ---------------------------------------------------------------- vii
bolum "vii) Tek kılavuz"
htmller() { (cd "$1" && ls *.html 2>/dev/null | tr '\n' ' '); }
olc vii1 "yeni klasörlerde yalnız KILAVUZ.html (kart ve yazar kılavuzu yok)" \
  bash -c '[ "$1" = "KILAVUZ.html " ] && [ "$2" = "KILAVUZ.html " ] && [ "$3" = "KILAVUZ.html " ]' _ "$(htmller "$Y")" "$(htmller "$V")" "$(htmller "$D")"
olc vii2 "eski klasördeki KART.html silinmedi" test -f "$A/KART.html"
olc vii3 "klasör CLAUDE.md'si ve şablonlarda kart anılmıyor" \
  bash -c '! grep -rqi "kart" "$1/CLAUDE.md" "$1/.claude" "$1/.divit" "$1/kitaplar" "$2/CLAUDE.md" "$2/tez-kontrol"' _ "$Y" "$A"
if [ -n "$SABLON_ROLLU" ]; then
  olc vii4 "data-rol türe göre (akademisyen / yazar)" \
    bash -c 'grep -qF "<html lang=\"tr\" data-rol=\"akademisyen\">" "$1/KILAVUZ.html" && grep -qF "<html lang=\"tr\" data-rol=\"yazar\">" "$2/KILAVUZ.html"' _ "$A" "$Y"
else
  sonuc ATLANDI vii4 "şablonda data-rol=\"\" yok (kılavuz parçası birleşmemiş); kopya şablonla aynı mı:"
  olc vii5 "şablonda data-rol yokken kopya şablonla birebir" cmp -s hoca-paketi/Divit/KILAVUZ.html "$Y/KILAVUZ.html"
fi

# ---------------------------------------------------------------- viii
bolum "viii) İzinler ve araçlar"
olc viii1 "settings.json: iki kitap-klasoru allow, asil/malzeme deny birebir; mkdir allow duruyor" \
  py 'import json,sys; p=json.load(open(sys.argv[1]))["permissions"]
a,d=p["allow"],p["deny"]
sys.exit(0 if {"Bash(sh */scripts/kitap-klasoru.sh *)","PowerShell(*kitap-klasoru.ps1*)","Bash(mkdir *)"}<=set(a) and {"Edit(./kitaplar/*/asil/**)","Edit(./kitaplar/*/malzeme/**)"}<=set(d) else 1)' "$Y/.claude/settings.json"
olc viii4 "settings.json dalga 2: zip, uploads, openalex, geçmiş ve bağlayıcı allow; gizli, genel arama, git ve gönderme/silme deny" \
  py 'import json,sys; p=json.load(open(sys.argv[1]))["permissions"]
a,d=set(p["allow"]),set(p["deny"])
A={"Bash(zip *)","PowerShell(Compress-Archive *)","Read(~/.claude/uploads/**)","WebFetch(domain:api.openalex.org)","Edit(./sekiller/**)","Edit(./notlar/**)",
"Bash(git -C * show *)","PowerShell(git -C * show *)","Bash(git -C * commit -m *)","PowerShell(git -C * commit -m *)",
"mcp__claude_ai_Gmail__create_draft","mcp__claude_ai_Google_Calendar__create_event"}
D={"Read(./gizli/**)","Edit(./gizli/**)","Bash(*gizli*)","PowerShell(*gizli*)",
"Bash(grep -r*)","Bash(grep -R*)","Bash(rg *)","Bash(find *)","Bash(ls -R*)","PowerShell(*-Recurse*)","PowerShell(Select-String *)",
"Bash(git -C * push *)","PowerShell(git -C * push *)","Bash(git -C * reset *)","PowerShell(git -C * reset *)",
"mcp__claude_ai_Gmail__send_message","mcp__claude_ai_Gmail__reply","mcp__claude_ai_Gmail__forward",
"mcp__claude_ai_Gmail__trash_message","mcp__claude_ai_Gmail__trash_thread","mcp__claude_ai_Google_Calendar__delete_event"}
sys.exit(0 if A<=a and D<=d and not (a&d) and len(d)>=51 else 1)' "$A/.claude/settings.json"
olc viii2 "CLAUDE.md 'Araçlar' dolu (pandoc, pdfcpu tam yol; pdftotext 'yok'; yer tutucu yok)" \
  bash -c 'grep -qF "Word/PDF çevirici: \`$2/.divit/araclar/pandoc\`" "$1" && grep -qF "PDF aracı: \`$2/.divit/araclar/pdfcpu\`" "$1" && grep -qF "PDF metin (Windows): \`yok\`" "$1" && ! grep -q "__[A-Z]*__" "$1"' _ "$Y/CLAUDE.md" "$EV"
olc viii3 "CLAUDE.md çekirdek kuralı: klasör açma ve kopyalama yalnız kitap-klasoru betiğiyle" grep -q 'yalnız kitap-klasoru betiğiyle' "$A/CLAUDE.md"

# ---------------------------------------------------------------- ix
bolum "ix) Kanal"
olc ix1 ".divit/kanal.txt = DIVIT_DAL (deneme / main)" \
  bash -c '[ "$(cat "$1")" = deneme ] && [ "$(cat "$2")" = main ]' _ "$Y/.divit/kanal.txt" "$A/.divit/kanal.txt"
kur ix DIVIT_HEDEF="$Y" CLAUDE_CONFIG_DIR="$G/cfg-y"
grep -E 'Kullanıcı türü|Kanal|Kurulu ve güncel|UYARI|HATA|Güncellemeler şu dağıtımdan' "$G/ix.txt" | sed 's/^/  kur.sh: /'
olc ix2 "DIVIT_DAL'sız yeniden kurulum deneme kanalında kaldı" \
  bash -c '[ "$1" = 0 ] && grep -q "Kanal: deneme" "$2" && grep -q "Güncellemeler şu dağıtımdan gelir: deneme" "$2" && grep -q "Kurulu ve güncel" "$2" && [ "$(cat "$3/.divit/kanal.txt")" = deneme ]' _ "$(kod ix)" "$G/ix.txt" "$Y"
olc ix3 "klasör ayarındaki pazar yeri adresi kanalın adresi" grep -qF "\"url\": \"$PAZAR_DENEME\"" "$Y/.claude/settings.json"
olc ix4 "main kanalında dağıtım satırı yok" bash -c '! grep -q "Güncellemeler şu dağıtımdan" "$1"' _ "$G/iv.txt"
kur ix5 DIVIT_HEDEF="$D" DIVIT_DAL=baska-dal
olc ix5 "izinsiz dal adı → uyarı, main" bash -c 'grep -q "bilinen bir kanal değil" "$1" && [ "$(cat "$2/.divit/kanal.txt")" = main ]' _ "$G/ix5.txt" "$D"
# Kaldırılan 'yeni' kanalı: DIVIT_DAL=yeni ve kanal.txt'sinde 'yeni' kalmış klasör uyarıyla main'e düşer.
kur ix6 DIVIT_HEDEF="$B/Divit-Yeni" DIVIT_DAL=yeni
olc ix6 "'yeni' artık izinli değil: DIVIT_DAL=yeni → uyarı, main" \
  bash -c 'grep -q "bilinen bir kanal değil" "$1" && [ "$(cat "$2/.divit/kanal.txt")" = main ] && grep -qF "\"url\": \"$3\"" "$2/.claude/settings.json"' _ "$G/ix6.txt" "$B/Divit-Yeni" "$PAZAR_MAIN"
printf 'yeni\n' >"$B/Divit-Yeni/.divit/kanal.txt"
kur ix7 DIVIT_HEDEF="$B/Divit-Yeni"
olc ix7 "kanal.txt'sinde 'yeni' kalan klasör, DIVIT_DAL'sız kurulumda uyarıyla main'e döner" \
  bash -c '[ "$1" = 0 ] && grep -q "bilinen bir kanal değil" "$2" && ! grep -q "Güncellemeler şu dağıtımdan" "$2" && [ "$(cat "$3/.divit/kanal.txt")" = main ]' _ "$(kod ix7)" "$G/ix7.txt" "$B/Divit-Yeni"

# ---------------------------------------------------------------- x
bolum "x) DIVIT_TEST=1'de Claude Code güncellenmez"
S="$G/sahte"; mkdir -p "$S"
cat >"$S/claude" <<EOF
#!/bin/sh
echo "claude \$*" >>"$S/cagrilar.log"
[ "\$1" = "--version" ] && echo "2.1.100 (Claude Code)"
exit 0
EOF
cat >"$S/curl" <<EOF
#!/bin/sh
echo "curl \$*" >>"$S/cagrilar.log"
case "\$*" in *claude.ai/install*) exit 1 ;; esac
exec /usr/bin/curl "\$@"
EOF
chmod +x "$S/claude" "$S/curl"
kur x DIVIT_HEDEF="$G/x/Divit" PATH="$S:$PATH"
sed 's/^/  çağrı: /' "$S/cagrilar.log"
olc x1 "sahte claude çağrıldı ama 'update' yok" bash -c 'grep -q "^claude --version" "$1" && ! grep -q "^claude update" "$1"' _ "$S/cagrilar.log"
olc x2 "resmî kurulum (claude.ai/install) indirilmedi" bash -c '! grep -q "claude.ai/install" "$1"' _ "$S/cagrilar.log"
olc x3 "bilgi satırı: güncelleme atlandı" grep -q 'güncelleme atlandı' "$G/x.txt"

# ---------------------------------------------------------------- xi
bolum "xi) Yedek: üstüne yazılan Divit dosyalarının önceki hâli"
XI="$G/xi/Divit"; YED="$XI/.divit/onceki-surumler"
yedekler() { ls -d "$YED"/kurulum-* 2>/dev/null | wc -l | tr -d ' '; }
kur xia DIVIT_TUR=akademisyen DIVIT_HEDEF="$XI"
olc xi1 "(a) ilk kurulum: yedek klasörü yok, yedek satırı yok" bash -c '[ "$1" = 0 ] && [ "$2" = 0 ] && ! grep -q "önceki hâli saklandı" "$3"' _ "$(kod xia)" "$(yedekler)" "$G/xia.txt"
IMZA_XI="$(imza "$XI")"
kur xib DIVIT_TUR=akademisyen DIVIT_HEDEF="$XI"
grep -E 'saklandı|UYARI' "$G/xib.txt" | sed 's/^/  kur.sh: /'
olc xi2 "(b) aynı kurulum yeniden: hiçbir dosya değişmedi, yedek klasörü yok" bash -c '[ "$1" = 0 ] && [ "$2" = "$3" ] && [ "$4" = 0 ]' _ "$(kod xib)" "$IMZA_XI" "$(imza "$XI")" "$(yedekler)"
printf '\n<!-- hocanın notu -->\n' >>"$XI/CLAUDE.md"
py 'import json,sys
p=sys.argv[1]; d=json.load(open(p)); d["hocaNotu"]="elle"; json.dump(d,open(p,"w"),indent=2,ensure_ascii=False)' "$XI/.claude/settings.json"
cp "$XI/CLAUDE.md" "$G/xi-claude-elle.md"; cp "$XI/.claude/settings.json" "$G/xi-settings-elle.json"
printf 'ogrenci tezi' >"$XI/tez-kontrol/gelen/x.docx"
sleep 1
kur xic DIVIT_TUR=akademisyen DIVIT_HEDEF="$XI"
grep -E 'saklandı|UYARI' "$G/xic.txt" | sed 's/^/  kur.sh: /'
YK="$(ls -d "$YED"/kurulum-* 2>/dev/null | head -1)"
olc xi3 "(c) tek yedek klasörü açıldı (kurulum-<tarih-saat>), çıktıda yeri yazıyor" \
  bash -c '[ "$1" = 1 ] && [ -n "$2" ] && grep -qF "önceki hâli saklandı: .divit/onceki-surumler/$(basename "$2")" "$3"' _ "$(yedekler)" "$YK" "$G/xic.txt"
olc xi4 "(c) CLAUDE.md ve .claude/settings.json yedekte, içerik elle değişen hâl" \
  bash -c 'cmp -s "$1/CLAUDE.md" "$2" && cmp -s "$1/.claude/settings.json" "$3"' _ "$YK" "$G/xi-claude-elle.md" "$G/xi-settings-elle.json"
olc xi5 "(c) klasördeki CLAUDE.md ve settings.json yenilendi (not gitti, yer tutucu yok)" \
  bash -c '! grep -q "hocanın notu" "$1/CLAUDE.md" && ! grep -q hocaNotu "$1/.claude/settings.json" && ! grep -q "__[A-Z]*__" "$1/CLAUDE.md"' _ "$XI"
olc xi6 "(c) yedekte yalnız bu iki dosya var; hoca dosyası (gelen/x.docx) yerinde, yedekte değil" \
  bash -c '[ "$(cd "$1" && find . -type f | sort | tr "\n" " ")" = "./.claude/settings.json ./CLAUDE.md " ] && [ "$(cat "$2/tez-kontrol/gelen/x.docx")" = "ogrenci tezi" ]' _ "$YK" "$XI"
olc xi7 "(c) settings.local.json ve kimlik.md değişmedi, yedeğe girmedi" \
  bash -c '! [ -e "$1/.claude/settings.local.json" ] && ! [ -e "$1/.divit/profil/kimlik.md" ]' _ "$YK"

# ---------------------------------------------------------------- son
bolum "Son"
olc G1 "gerçek ~/.claude (settings, installed_plugins, known_marketplaces) değişmedi" test "$GERCEK_ONCE" = "$(gercek_ozet)"
olc G2 "/opt/homebrew/bin/claude sürümü değişmedi ($CLI_SURUM_ONCE)" test "$CLI_SURUM_ONCE" = "$(/opt/homebrew/bin/claude --version 2>/dev/null)"
olc G3 "~/Documents klasör kaydı (değişme zamanı, boyut) değişmedi" test "$BELGELER_ONCE" = "$(stat -f '%m %z' ~/Documents 2>/dev/null)"
echo
[ "$KALAN" -eq 0 ] && { echo "SONUÇ: hepsi geçti (ATLANDI satırları hariç)."; exit 0; }
echo "SONUÇ: $KALAN ölçüm KALDI."; exit 1
