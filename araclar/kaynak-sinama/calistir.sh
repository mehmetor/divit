#!/usr/bin/env bash
# Divit — kaynak doğrulama sınaması ("sessiz hata sıfır").
#
#   araclar/kaynak-sinama/calistir.sh [--model claude-sonnet-5-5] [--md <dosya>] [--eklentiler <dizin>]
#
# --eklentiler: plugins/ yerine başka bir dizindeki divit ve divit-akademik
# (ör. eski sürümü ölçmek için `git archive origin/develop plugins` açılmış hâli).
#
# Geliştirici aracıdır, eklentiye girmez. /tmp altında hoca klasörü kurar
# (hoca-paketi/Divit + klasor/), iki eklentiyi --plugin-dir ile verir,
# `claude -p` ile atıf denetimini ister ve skill'in yazdığı kanıt dosyasını
# (.divit/dogrulama/*.md) beklenen.md ile karşılaştırır.
#
# Çıkış: 0 GEÇTİ · 1 KALDI (tek kaçırma ya da yanlış alarm yeter) ·
#        3 AĞ (Crossref/OpenAlex erişilemedi; sonuç sayılmaz, yeniden dene) ·
#        2 kullanım/kurulum hatası.
# Gerçek ~/.claude ayarlarına dokunmaz: --setting-sources project,local.
set -uo pipefail

MODEL="claude-sonnet-5-5"; MD=""; EK=""
while [ $# -gt 0 ]; do
  case "$1" in
    --model) MODEL="${2:-}"; shift 2 ;;
    --md) MD="${2:-}"; shift 2 ;;
    --eklentiler) EK="${2:-}"; shift 2 ;;
    *) echo "Bilinmeyen argüman: $1"; exit 2 ;;
  esac
done

BU="$(cd "$(dirname "$0")" && pwd)"
KOK="$(cd "$BU/../.." && pwd)"
[ -n "$EK" ] || EK="$KOK/plugins"
CLI="$(command -v claude)" || { echo "claude bulunamadı"; exit 2; }
PANDOC="$(command -v pandoc || echo "$HOME/.divit/araclar/pandoc")"
ZAMAN="$(date +%Y%m%d-%H%M%S)"
G="/tmp/kaynak-sinama-$ZAMAN"; H="$G/Divit"
mkdir -p "$G"

# --- Ağ ön denetimi: API'ler yoksa sınama anlamsız (AĞ, KALDI değil) ---
for u in "https://api.crossref.org/works?filter=doi:10.1038/nature01014&select=DOI" \
         "https://api.openalex.org/works/doi:10.1038/nature01014?select=id" \
         "https://dergipark.org.tr/tr/pub/akdenizfderg/article/19372"; do
  kod="$(curl -s -o /dev/null -w '%{http_code}' -A 'Mozilla/5.0' --max-time 20 "$u")"
  if [ "$kod" != "200" ]; then echo "AĞ: $u → $kod"; exit 3; fi
done

# --- Hoca klasörü ---
cp -R "$KOK/hoca-paketi/Divit" "$H"
cp -R "$BU/klasor/." "$H/"
python3 - "$H" "$PANDOC" "$EK" <<'PY'
import json, os, sys
h, pandoc, ek = sys.argv[1:4]
c = os.path.join(h, "CLAUDE.md")
s = open(c, encoding="utf-8").read()
s = s.replace("__PANDOC__", pandoc).replace("__PDFCPU__", "yok").replace("__PDFTOTEXT__", "yok")
open(c, "w", encoding="utf-8").write(s)
p = os.path.join(h, ".claude", "settings.json")
d = json.load(open(p))
d.pop("extraKnownMarketplaces", None); d.pop("enabledPlugins", None); d.pop("env", None)
izin = d["permissions"]["allow"]
# Skill'in kullandığı alan adları; hoca-paketi'ne eklenmesi gereken satır raporda.
# Eklenti --plugin-dir ile verildiği için yolu ~/.claude/plugins değil; gerçek
# kurulumdaki Read(~/.claude/plugins/**) izninin karşılığı.
for a in ("WebFetch(domain:api.openalex.org)", f"Read(/{ek}/**)"):
    if a not in izin:
        izin.append(a)
json.dump(d, open(os.path.join(h, ".claude", "settings.local.json"), "w"), indent=2, ensure_ascii=False)
# Güvenilmemiş klasörde settings.json'daki allow yok sayılır ("Ignoring" satırı);
# izinler yalnız settings.local.json'da kalsın, settings.json'da yalnız deny.
d["permissions"].pop("allow", None)
json.dump(d, open(p, "w"), indent=2, ensure_ascii=False)
PY

ISTEM="yazilar/makale.md dosyasındaki atıfları kontrol et, kaynakça doğru mu?"
echo "Klasör: $H"; echo "Model: $MODEL"; echo "İstem: $ISTEM"
BAS=$(date +%s)
(cd "$H" && "$CLI" -p "$ISTEM" --model "$MODEL" --setting-sources project,local \
  --permission-mode acceptEdits --no-session-persistence \
  --plugin-dir "$EK/divit" --plugin-dir "$EK/divit-akademik" \
  --output-format stream-json --verbose </dev/null >"$G/akis.jsonl" 2>"$G/stderr.txt")
SURE=$(( $(date +%s) - BAS ))

KANIT="$(ls -t "$H"/.divit/dogrulama/*.md 2>/dev/null | head -1)"
[ -n "$KANIT" ] || KANIT="-"

python3 - "$G/akis.jsonl" >"$G/ozet.txt" <<'PY'
import json, sys
son, araclar, skill = None, {}, []
for l in open(sys.argv[1], encoding="utf-8"):
    try: d = json.loads(l)
    except Exception: continue
    if d.get("type") == "result": son = d
    m = d.get("message")
    for p in (m.get("content") if isinstance(m, dict) else None) or []:
        if isinstance(p, dict) and p.get("type") == "tool_use":
            araclar[p["name"]] = araclar.get(p["name"], 0) + 1
            if p["name"] == "Skill": skill.append(p["input"].get("skill"))
print("Araç çağrıları:", ", ".join(f"{k} {v}" for k, v in sorted(araclar.items())))
print("Yüklenen skill'ler:", ", ".join(skill) or "yok")
if son:
    print("Maliyet (USD):", round(son.get("total_cost_usd") or 0, 2), "· tur:", son.get("num_turns"))
    red = son.get("permission_denials") or []
    print("İzin reddi:", "izin reddi yok" if not red else "")
    for r in red: print("  -", r.get("tool_name"), json.dumps(r.get("tool_input"), ensure_ascii=False)[:200])
    print("\nSon mesaj:\n" + (son.get("result") or "")[:3000])
else:
    print("Sonuç satırı yok (oturum yarıda kesildi)")
PY

python3 "$BU/karsilastir.py" "$BU/beklenen.md" "$KANIT" "$G/akis.jsonl" >"$G/karsilastirma.md"
KOD=$?
case $KOD in 0) DURUM="GEÇTİ" ;; 3) DURUM="AĞ" ;; *) DURUM="KALDI" ;; esac

IGN="$(grep -c 'Ignoring' "$G/stderr.txt" 2>/dev/null || true)"
{
  echo "## Koşu $ZAMAN — $DURUM"
  echo
  echo "- Eklentiler: \`$EK\`"
  echo "- Model: \`$MODEL\` · süre: ${SURE} sn · klasör: \`$H\`"
  echo "- Kanıt dosyası: \`$KANIT\`"
  echo "- stderr'de 'Ignoring' satırı: ${IGN:-0}"
  echo
  echo '```'
  cat "$G/ozet.txt"
  echo '```'
  echo
  cat "$G/karsilastirma.md"
  echo
} >"$G/rapor.md"
cat "$G/rapor.md"
[ -n "$MD" ] && cat "$G/rapor.md" >>"$MD"
echo "SONUÇ: $DURUM"
exit $KOD
