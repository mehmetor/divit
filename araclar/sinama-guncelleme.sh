#!/usr/bin/env bash
# Divit — kurulu hocanın eski sürümden yeni sürüme geçişini sınar.
#
#   araclar/sinama-guncelleme.sh --dal deneme-gecis-202610011200 [--karma] [--sakla]
#
# Geliştirme makinesinde, yayına gidecek dalda, temiz çalışma ağacıyla
# çalıştırılır. Gerçek güncelleme yolunu (url pazar yeri + zip, aynı adreste
# içerik değişir) GitHub'daki tek kullanımlık bir deneme dalıyla taklit eder:
#
#   A  eski hâl: dal = main'in kopyası, main'in kur.sh'si, hoca taklidi
#   B  yeni sürüm gelir: ./yayinla.sh --deneme <dal>, autoUpdate'in adımı
#      (katalog yenilenir, kurulu divit yeni özete taşınır); kurulum YENİLENMEZ
#   C  kurulum yenilenir: bu dalın kur.sh'si, DIVIT_TUR verilmeden
#
# Her ölçüm için GEÇTİ / KALDI / ATLANDI satırı basar; KALDI varsa çıkış 1.
# Her şey geçici bir config (CLAUDE_CONFIG_DIR), geçici HOME ve /tmp altında
# olur; gerçek ~/.claude'un üç dosyasının özeti önce/sonra karşılaştırılır.
#
# Konuşma ölçümleri (B2, B3, D, C9) giriş ister:
#   - ortamda CLAUDE_CODE_OAUTH_TOKEN ya da ANTHROPIC_API_KEY varsa yalıtılmış
#     config'le çalışır;
#   - yoksa ATLANDI yazar; --karma verilirse gerçek girişle ama gerçek ayar
#     ve eklentiler olmadan çalışır (--setting-sources project,local,
#     --plugin-dir, klasörün eklenti anahtarları çıkarılmış kopyası).
#
# UYARI: origin'e iki kez push yapar (dal adı argümanla verilir, dal önceden
# olmamalı). Dal sonradan elle silinir: git push origin --delete <dal>
set -uo pipefail

SD=""; KARMA=""; SAKLA=""
while [ $# -gt 0 ]; do
  case "$1" in
    --dal) SD="${2:-}"; shift 2 ;;
    --karma) KARMA=1; shift ;;
    --sakla) SAKLA=1; shift ;;
    *) echo "Bilinmeyen argüman: $1"; exit 2 ;;
  esac
done
case "$SD" in
  deneme-gecis-?*) ;;
  *) echo "Kullanım: $0 --dal deneme-gecis-<YYYYMMDDHHMM> [--karma] [--sakla]"; exit 2 ;;
esac

cd "$(dirname "$0")/.."
KOK="$(pwd)"
REPO="mehmetor/divit"
HAM="https://raw.githubusercontent.com/$REPO/$SD"

KALAN=0
sonuc() {  # sonuc GEÇTİ|KALDI|ATLANDI|BİLGİ <kod> <metin>
  printf '%-7s %-4s %s\n' "$1" "$2" "$3"
  [ "$1" = "KALDI" ] && KALAN=$((KALAN+1))
  return 0
}
olc() {    # olc <kod> <metin> <komut...>: komut başarılıysa GEÇTİ
  local kod="$1" metin="$2"; shift 2
  if "$@"; then sonuc GEÇTİ "$kod" "$metin"; else sonuc KALDI "$kod" "$metin"; fi
}
bolum() { printf '\n== %s\n' "$1"; }

# ---------------------------------------------------------------- ön koşullar
bolum "Ön koşullar"
echo "Bu betik origin'e PUSH yapar: '$SD' dalı (önce main'in kopyası, sonra deneme commit'i)."
[ -z "$(git status --porcelain)" ] || { echo "HATA: çalışma ağacı temiz değil; önce commit'leyin."; exit 1; }
git fetch -q origin || { echo "HATA: git fetch başarısız."; exit 1; }
if git ls-remote --exit-code --heads origin "$SD" >/dev/null 2>&1; then
  echo "HATA: '$SD' uzakta zaten var. Tek kullanımlık dal: yeni bir ad verin."; exit 1
fi
EN_AZ="2.1.224"
surum_of() { "$1" --version 2>/dev/null | head -1 | grep -oE '^[0-9]+\.[0-9]+\.[0-9]+'; }
CLI="$(command -v claude)" || { echo "HATA: claude bulunamadı."; exit 1; }
SV="$(surum_of "$CLI")"
[ "$(printf '%s\n%s\n' "$EN_AZ" "$SV" | sort -V | head -1)" = "$EN_AZ" ] \
  || { echo "HATA: claude $SV eski (en az $EN_AZ). kur.sh gerçek CLI'yi güncellemeye kalkar; önce elle güncelleyin."; exit 1; }
# Konuşma için en yeni kopya (klasörün modeli yeni sürüm isteyebilir).
KONUSMA_CLI="$( { which -a claude; echo "$HOME/.local/bin/claude"; } | sort -u | while read -r c; do
  [ -x "$c" ] && printf '%s %s\n' "$(surum_of "$c")" "$c"; done | sort -V | tail -1 | cut -d' ' -f2-)"
echo "claude (eklenti işleri): $CLI $SV · konuşma: $KONUSMA_CLI $(surum_of "$KONUSMA_CLI")"

GIRIS=""
[ -n "${CLAUDE_CODE_OAUTH_TOKEN:-}${ANTHROPIC_API_KEY:-}" ] && GIRIS=1
GERCEK=(~/.claude/settings.json ~/.claude/plugins/installed_plugins.json ~/.claude/plugins/known_marketplaces.json)
gercek_ozet() { shasum "${GERCEK[@]}" 2>/dev/null; }
GERCEK_ONCE="$(gercek_ozet)"

G="$(mktemp -d /tmp/divit-sinama.XXXXXX)"
temizle() { [ -n "$SAKLA" ] && { echo "Geçiciler saklandı: $G"; return; }; rm -rf "$G"; }
trap temizle EXIT
CFG="$G/cfg"; EV="$G/ev"; H="$EV/Documents/Divit"
mkdir -p "$CFG" "$EV/Documents"
echo "Geçici dizin: $G"

# Yalıtılmış claude (eklenti komutları ve init satırı girişsiz çalışır).
yc() { CLAUDE_CONFIG_DIR="$CFG" HOME="$EV" "$CLI" "$@"; }
liste() { (cd "$H" && yc plugin list --json 2>/dev/null) | python3 -c 'import json,sys; s=sys.stdin.read(); print(json.dumps(json.loads(s[s.index("["):])))'; }
init() { (cd "$H" && yc -p ok --output-format stream-json --verbose </dev/null 2>/dev/null | head -1); }
py() { python3 -c "$@"; }
imza() { (cd "$1" && find . -type f -not -path './.divit/*' -print0 | LC_ALL=C sort -z | xargs -0 shasum); }

# Konuşma: yalıtılmış (giriş varsa) ya da karma. $1 durum adı, $2 istem, $3 çıktı.
konus() {
  local istem="$2" cikti="$3" klasor
  if [ -n "$GIRIS" ]; then
    klasor="$H"
    (cd "$klasor" && CLAUDE_CONFIG_DIR="$CFG" HOME="$EV" "$KONUSMA_CLI" -p "$istem" --no-session-persistence \
      --disallowedTools Bash PowerShell --output-format stream-json --verbose </dev/null 2>/dev/null >"$cikti")
  else
    klasor="$G/karma-$1/Divit"
    if [ ! -d "$klasor" ]; then
      mkdir -p "$(dirname "$klasor")"; cp -R "$H" "$klasor"
      py 'import json,sys,os
k=sys.argv[1]
for ad,anahtar in ((".claude/settings.json","extraKnownMarketplaces"),(".claude/settings.local.json","enabledPlugins")):
    p=os.path.join(k,ad); d=json.load(open(p)); d.pop(anahtar,None); d.pop("enabledPlugins",None); json.dump(d,open(p,"w"),indent=2)' "$klasor"
    fi
    local ek=()
    for p in $(liste | py 'import json,sys
yerel=json.load(open(sys.argv[1])).get("enabledPlugins",{})
for p in json.load(sys.stdin):
    if p["scope"]=="user" and yerel.get(p["id"]) is True: print(p["installPath"])' "$H/.claude/settings.local.json"); do
      ek+=(--plugin-dir "$p" --add-dir "$p")
    done
    (cd "$klasor" && "$KONUSMA_CLI" -p "$istem" --no-session-persistence --setting-sources project,local "${ek[@]}" \
      --disallowedTools Bash PowerShell --output-format stream-json --verbose </dev/null 2>/dev/null >"$cikti")
  fi
  KONUSMA_KLASORU="$klasor"
}
# stream-json özetini basar: araç çağrıları ve son metin.
ozet() { py 'import json,sys
for l in open(sys.argv[1]):
    try: d=json.loads(l)
    except Exception: continue
    if d.get("type")=="system" and d.get("subtype")=="init":
        print("  eklentiler:", ", ".join(p["source"]+" "+p["path"] for p in d.get("plugins",[])))
    if d.get("type")=="assistant":
        for c in d["message"]["content"]:
            if c["type"]=="tool_use": print("  araç:", c["name"], json.dumps(c["input"],ensure_ascii=False)[:160])
            elif c["type"]=="text": print("  metin:", c["text"].replace("\n","\n         "))' "$1"; }
# Karma yolda yüklenen eklentilerin hepsi --plugin-dir'den (…@inline) ve geçici config'ten gelmeli.
kaynak_dogru() { [ -n "$GIRIS" ] && return 0; py 'import json,sys
d=json.loads(open(sys.argv[1]).readline())
ps=[p for p in d.get("plugins",[]) if "divit" in p["name"]]
sys.exit(0 if ps and all(p["source"].endswith("@inline") and p["path"].startswith(sys.argv[2]) for p in ps) else 1)' "$1" "$CFG"; }
arac_var() { py 'import json,sys,re
r=re.compile(sys.argv[3])
for l in open(sys.argv[1]):
    try: d=json.loads(l)
    except Exception: continue
    if d.get("type")=="assistant":
        for c in d["message"]["content"]:
            if c["type"]=="tool_use" and c["name"]==sys.argv[2] and r.search(json.dumps(c["input"],ensure_ascii=False)): sys.exit(0)
sys.exit(1)' "$@"; }
son_metin() { py 'import json,sys
t=""
for l in open(sys.argv[1]):
    try: d=json.loads(l)
    except Exception: continue
    if d.get("type")=="result": t=d.get("result") or ""
print(t)' "$1"; }
export -f py imza kaynak_dogru arac_var
export GIRIS CFG
KARMA_KOMUTU="$0 --dal <yeni-dal> --karma"
konusma_atlansin_mi() { [ -z "$GIRIS" ] && [ -z "$KARMA" ]; }

# ---------------------------------------------------------------- A
bolum "A) Eski hâl (main)"
git push -q origin "origin/main:refs/heads/$SD" || { echo "HATA: push başarısız."; exit 1; }
echo "Gönderildi: $SD = origin/main ($(git rev-parse --short=12 origin/main))"
git show origin/main:kur.sh > "$G/kur-eski.sh"
ESKI_OZET="$(git show origin/main:.claude-plugin/marketplace.json | py 'import json,sys; print([p for p in json.load(sys.stdin)["plugins"] if p["name"]=="divit"][0]["source"]["sha256"][:12])')"
DIVIT_DAL="$SD" DIVIT_TEST=1 CLAUDE_CONFIG_DIR="$CFG" HOME="$EV" DIVIT_HEDEF="$H" bash "$G/kur-eski.sh" >"$G/a-kur.log" 2>&1
grep -E 'Kurulu ve güncel|UYARI|HATA' "$G/a-kur.log" | sed 's/^/  kur.sh: /'

# Hoca taklidi: iki elle izin, tür satırsız dolu profil, öğrenci dosyası, kendi yazısı.
py 'import json,sys
p=sys.argv[1]; d=json.load(open(p))
d.setdefault("permissions",{}).setdefault("allow",[]).extend(["Bash(ls *)","WebFetch(domain:scholar.google.com)"])
json.dump(d,open(p,"w"),indent=2)' "$H/.claude/settings.local.json"
cat > "$H/.divit/profil/kimlik.md" <<'EOF'
# Kim

Ad: Örnek Hoca (sınama profili)
Unvan: Prof. Dr.
Kurum: Örnek Üniversitesi Ziraat Fakültesi, Bahçe Bitkileri Bölümü
Alan: Bahçe bitkileri — meyve yetiştiriciliği
Danışmanlık: 4 yüksek lisans, 2 doktora öğrencisi.
EOF
mkdir -p "$H/tez-kontrol/gelen" "$H/yazilar"
printf '# Yüksek lisans tezi — Bölüm 3\n\nElma çeşitlerinde verim (kg/da) üç yıl ölçülmüştür. Ortalama verim 3.200 kg/da bulunmuştur (Yılmaz, 2019).\n' > "$H/tez-kontrol/gelen/ab-tez-bolum3.md"
printf '# Dekanlığa dilekçe taslağı\n\nBölümümüz laboratuvarı için cihaz alımı talebimizi arz ederim.\n' > "$H/yazilar/dilekce-taslak.md"

L="$(liste)"
olc A1 "yalnız divit@divit kurulu, sürüm main'deki özet ($ESKI_OZET)" \
  py 'import json,sys; l=json.loads(sys.argv[1]); sys.exit(0 if {p["id"] for p in l}=={"divit@divit"} and all(p["version"]==sys.argv[2] for p in l) else 1)' "$L" "$ESKI_OZET"
init > "$G/a-init.json"
olc A2 "init'te divit:tez-kontrol var" py 'import json,sys; sys.exit(0 if "divit:tez-kontrol" in json.load(open(sys.argv[1]))["slash_commands"] else 1)' "$G/a-init.json"
AU="$(py 'import json,sys; d=json.load(open(sys.argv[1])).get("divit",{}); print(d.get("autoUpdate","yok (anahtar yazılmamış)"))' "$CFG/plugins/known_marketplaces.json")"
sonuc BİLGİ A3 "pazar yeri kaydında divit autoUpdate: $AU (kur.sh CLI ile ekler; Desktop klasöre güvenince şablondaki autoUpdate:true işlenebilir)"

# ---------------------------------------------------------------- B
bolum "B) Yeni sürüm gelir, kurulum yenilenmez"
./yayinla.sh --deneme "$SD" >"$G/b-yayinla.log" 2>&1 || { cat "$G/b-yayinla.log"; echo "HATA: yayinla.sh --deneme başarısız."; exit 1; }
head -3 "$G/b-yayinla.log" | sed 's/^/  yayinla: /'
git fetch -q origin "+refs/heads/$SD:refs/remotes/origin/$SD"
BEKLENEN="$(git show "origin/$SD:.claude-plugin/marketplace.json" | shasum | cut -c1-40)"
YENI_OZET="$(git show "origin/$SD:.claude-plugin/marketplace.json" | py 'import json,sys; print(" ".join(p["source"]["sha256"][:12] for p in json.load(sys.stdin)["plugins"]))')"
read -r YENI_CEKIRDEK YENI_AKADEMIK <<<"$YENI_OZET"
echo "  Beklenen sürümler: divit $YENI_CEKIRDEK · divit-akademik $YENI_AKADEMIK. Ham adres önbelleği bekleniyor…"
TAMAM=""
for i in $(seq 1 21); do
  [ "$(curl -fsSL "$HAM/.claude-plugin/marketplace.json" 2>/dev/null | shasum | cut -c1-40)" = "$BEKLENEN" ] && { TAMAM=1; break; }
  sleep 30
done
[ -n "$TAMAM" ] || { sonuc KALDI B0 "raw marketplace.json 10 dakikada güncellenmedi"; exit 1; }
sonuc GEÇTİ B0 "raw marketplace.json deneme commit'iyle aynı ($(( (i-1)*30 )) sn)"
# autoUpdate'in yaptığı: katalog yenilenir, kurulu eklenti yeni özete taşınır; yeni eklenti kurulmaz.
(cd "$H" && yc plugin marketplace update divit && yc plugin update divit@divit) >"$G/b-guncelle.log" 2>&1
L="$(liste)"
olc B1a "divit yeni özette ($YENI_CEKIRDEK), divit-akademik kurulu değil" \
  py 'import json,sys; l=json.loads(sys.argv[1]); u=[p for p in l if p["scope"]=="user"]
sys.exit(0 if [(p["id"],p["version"]) for p in u]==[("divit@divit",sys.argv[2])] and not any("akademik" in p["id"] for p in l) else 1)' "$L" "$YENI_CEKIRDEK"
init > "$G/b-init.json"
olc B1b "init: divit-akademik:* yok, divit:tez-kontrol yok, divit yeni yoldan" \
  py 'import json,sys; d=json.load(open(sys.argv[1])); c=d["slash_commands"]
sys.exit(0 if not [x for x in c if x.startswith("divit-akademik:")] and "divit:tez-kontrol" not in c and any(sys.argv[2] in p["path"] for p in d["plugins"] if p["name"]=="divit") else 1)' "$G/b-init.json" "$YENI_CEKIRDEK"

# B4 (okuma): eski klasör dosyaları yeni eklentiyle uyumlu mu.
olc B4a "eski CLAUDE.md divit:kurallar'ı yüklüyor (tür kurallar'da çözülür)" grep -q 'divit:kurallar' "$H/CLAUDE.md"
olc B4b "eski settings.json eklenti dosyalarını okumaya izin veriyor (akademisyen.md)" grep -qF 'Read(~/.claude/plugins/**)' "$H/.claude/settings.json"
grep -q '`tez-kontrol` skill' "$H/tez-kontrol/CLAUDE.md" && sonuc BİLGİ B4c "eski tez-kontrol/CLAUDE.md eski skill adını anıyor; B3 güvenlik ağı bunu karşılamalı"
grep -qF 'kitaplar/*/asil' "$H/.claude/settings.json" || sonuc BİLGİ B4d "eski settings.json'da kitaplar/ yasakları yok (akademisyende kitaplar/ yok; C'de gelir)"
sonuc BİLGİ B5 "açık oturum eski eklentiyle sürer; yeni sürüm Claude kapatılıp açılınca gelir"

if konusma_atlansin_mi; then
  for k in B2 B3 D; do sonuc ATLANDI "$k" "konuşma ölçümü: giriş yok. Karma yol: $KARMA_KOMUTU"; done
else
  IMZA_ONCE="$(imza "$H")"
  konus b "merhaba" "$G/b2.jsonl"; ozet "$G/b2.jsonl"
  olc B2 "merhaba → kurallar akademisyen.md'yi Read ile okudu" \
    bash -c 'kaynak_dogru "$1" && arac_var "$1" Read "skills/kurallar/akademisyen\\.md"' _ "$G/b2.jsonl"
  IMZA_K_ONCE="$(imza "$KONUSMA_KLASORU")"
  konus b "tez-kontrol/gelen'deki dosyayı değerlendir" "$G/b3.jsonl"; ozet "$G/b3.jsonl"
  METIN="$(son_metin "$G/b3.jsonl")"
  olc B3a "tez isteği → 'kurulumu bir kez yenilemek' yönlendirmesi" \
    bash -c 'printf "%s" "$1" | grep -qi "kurulum" && printf "%s" "$1" | grep -qi "yenile"' _ "$METIN"
  olc B3b "sade Türkçe (eklenti/plugin/terminal/zip/JSON geçmiyor)" \
    bash -c '! printf "%s" "$1" | grep -qiE "eklenti|plugin|terminal|zip|json|marketplace"' _ "$METIN"
  olc B3c "rapor yazılmadı, hiçbir dosya değişmedi (.divit/ dışı)" \
    bash -c '[ "$1" = "$2" ] && ! arac_var "$3" Write "tez-kontrol/rapor" && ! arac_var "$3" Edit "tez-kontrol/rapor"' _ "$IMZA_K_ONCE" "$(imza "$KONUSMA_KLASORU")" "$G/b3.jsonl"
  konus b "güncelle" "$G/d.jsonl"; ozet "$G/d.jsonl"
  METIN="$(son_metin "$G/d.jsonl")"
  olc D1 "güncelle → guncelleme skill'i yenilikleri anlatıp onay istiyor" \
    bash -c 'arac_var "$1" Skill "divit:guncelleme" && printf "%s" "$2" | grep -q "?"' _ "$G/d.jsonl" "$METIN"
  olc D2 "kurulum onaysız çalıştırılmadı (kur.sh/kur.ps1 çağrısı yok)" \
    bash -c '! arac_var "$1" Bash "kur\\.(sh|ps1)" && ! arac_var "$1" PowerShell "kur\\.(sh|ps1)"' _ "$G/d.jsonl"
  olc D3 "akademik madde (komut adları, kurulumu yenileme) hocaya söylendi" \
    bash -c 'printf "%s" "$1" | grep -q "divit-akademik"' _ "$METIN"
  [ -n "$GIRIS" ] && olc B3d "hoca klasöründe .divit/ dışı dosya değişmedi" test "$IMZA_ONCE" = "$(imza "$H")"
fi

# ---------------------------------------------------------------- C
bolum "C) Kurulum yenilenir (DIVIT_TUR yok)"
KORU=("$H/.divit/profil/"*.md "$H/tez-kontrol/gelen/"* "$H/yazilar/"*)
KORU_ONCE="$(shasum "${KORU[@]}")"
IZIN_ONCE="$(py 'import json,sys; print(json.dumps(json.load(open(sys.argv[1])).get("permissions"),sort_keys=True))' "$H/.claude/settings.local.json")"
git show HEAD:kur.sh > "$G/kur-yeni.sh"
DIVIT_DAL="$SD" DIVIT_TEST=1 CLAUDE_CONFIG_DIR="$CFG" HOME="$EV" DIVIT_HEDEF="$H" bash "$G/kur-yeni.sh" >"$G/c-kur.log" 2>&1
grep -E 'Kullanıcı türü|Kurulu ve güncel|UYARI|HATA' "$G/c-kur.log" | sed 's/^/  kur.sh: /'
L="$(liste)"
olc C1 "iki eklenti kurulu: divit $YENI_CEKIRDEK, divit-akademik $YENI_AKADEMIK" \
  py 'import json,sys; u={p["id"]:p["version"] for p in json.loads(sys.argv[1]) if p["scope"]=="user"}
sys.exit(0 if u=={"divit@divit":sys.argv[2],"divit-akademik@divit":sys.argv[3]} else 1)' "$L" "$YENI_CEKIRDEK" "$YENI_AKADEMIK"
olc C2 "settings.local.json: iki eklenti açık, elle eklenen izinler duruyor" \
  py 'import json,sys; d=json.load(open(sys.argv[1]))
sys.exit(0 if d.get("enabledPlugins")=={"divit@divit":True,"divit-akademik@divit":True} and json.dumps(d.get("permissions"),sort_keys=True)==sys.argv[2] else 1)' "$H/.claude/settings.local.json" "$IZIN_ONCE"
olc C3 "profil, tez-kontrol/gelen, yazilar değişmedi; kimlik.md'ye tür satırı eklenmedi" \
  bash -c '[ "$1" = "$(shasum "${@:3}")" ] && ! grep -q "^Kullanıcı türü:" "$2"' _ "$KORU_ONCE" "$H/.divit/profil/kimlik.md" "${KORU[@]}"
olc C4 "settings.json yeni: kitaplar yasakları var, pazar yeri $SD" \
  bash -c 'grep -qF "Edit(./kitaplar/*/asil/**)" "$1" && grep -qF "/$2/.claude-plugin/marketplace.json" "$1"' _ "$H/.claude/settings.json" "$SD"
olc C5 ".claude/rules/taslak-yazim.md yeni" bash -c 'git show HEAD:hoca-paketi/Divit/.claude/rules/taslak-yazim.md | cmp -s - "$1"' _ "$H/.claude/rules/taslak-yazim.md"
# Kılavuz tek dosya; kopyada yalnız kök etiketteki data-rol türe göre doldurulur.
olc C6 "KILAVUZ.html yeni (/divit-akademik:, data-rol akademisyen), KILAVUZ-YAZAR.html ve kitaplar/ yok" \
  bash -c 'sed "s|<html lang=\"tr\" data-rol=\"akademisyen\">|<html lang=\"tr\" data-rol=\"\">|" "$1/KILAVUZ.html" | cmp -s - <(git show HEAD:hoca-paketi/Divit/KILAVUZ.html) && grep -q "/divit-akademik:" "$1/KILAVUZ.html" && [ ! -e "$1/KILAVUZ-YAZAR.html" ] && [ ! -e "$1/kitaplar" ]' _ "$H"
olc C10 ".divit/kanal.txt = $SD, CLAUDE.md 'Araçlar' dolu" \
  bash -c '[ "$(cat "$1/.divit/kanal.txt")" = "$2" ] && grep -q "^## Araçlar" "$1/CLAUDE.md" && ! grep -q "__PANDOC__" "$1/CLAUDE.md"' _ "$H" "$SD"
olc C7 ".divit/kurulum-surumu.txt yazıldı ($(cat "$H/.divit/kurulum-surumu.txt" 2>/dev/null))" test -s "$H/.divit/kurulum-surumu.txt"
init > "$G/c-init.json"
olc C8 "init'te beş divit-akademik skill'i, eklentiler yeni yollardan" \
  py 'import json,sys; d=json.load(open(sys.argv[1])); c=set(d["slash_commands"])
bes={"divit-akademik:"+a for a in ("tez-kontrol","sinav","yayin-oncesi","kaynak-dogrula","bolum-yaz")}
yol={p["name"]:p["path"] for p in d["plugins"]}
sys.exit(0 if bes<=c and sys.argv[2] in yol.get("divit","") and sys.argv[3] in yol.get("divit-akademik","") else 1)' "$G/c-init.json" "$YENI_CEKIRDEK" "$YENI_AKADEMIK"
if konusma_atlansin_mi; then
  sonuc ATLANDI C9 "konuşma ölçümü: giriş yok. Karma yol: $KARMA_KOMUTU"
else
  konus c "tez-kontrol/gelen'deki dosyayı değerlendir" "$G/c9.jsonl"; ozet "$G/c9.jsonl"
  olc C9 "tez isteği → divit-akademik:tez-kontrol çalıştı, öğrenci dosyası değişmedi" \
    bash -c 'kaynak_dogru "$1" && arac_var "$1" Skill "divit-akademik:tez-kontrol" && [ "$2" = "$(cd "$3" && shasum tez-kontrol/gelen/* | sed "s|tez-kontrol/gelen/||")" ]' \
    _ "$G/c9.jsonl" "$(cd "$H" && shasum tez-kontrol/gelen/* | sed 's|tez-kontrol/gelen/||')" "$KONUSMA_KLASORU"
fi

# ---------------------------------------------------------------- son
bolum "Son"
olc G1 "gerçek ~/.claude (settings, installed_plugins, known_marketplaces) değişmedi" test "$GERCEK_ONCE" = "$(gercek_ozet)"
echo
echo "Uzak deneme dalı silinmedi. İş bitince: git push origin --delete $SD"
[ "$KALAN" -eq 0 ] && { echo "SONUÇ: hepsi geçti (ATLANDI satırları hariç)."; exit 0; }
echo "SONUÇ: $KALAN ölçüm KALDI."; exit 1
