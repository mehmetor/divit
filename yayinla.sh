#!/usr/bin/env bash
# Divit — eklenti zip'lerini üretir (divit ve divit-akademik).
#
#   ./yayinla.sh                  deneme: doğrula, zip'leri geçici üret, iki
#                                 özeti ve hocaya gidecek notu göster. Hiçbir
#                                 şey değişmez.
#   ./yayinla.sh --surum 1.8.0    yayın (CI çalıştırır, elle çalıştırma):
#                                 SURUM.md'de "Sıradaki" → "1.8.0 · tarih",
#                                 dagitim/ zip'leri, marketplace.json, commit.
#   ./yayinla.sh --kanal yeni     yayın kanalı: zip'leri ve bu dalı gösteren
#                                 marketplace.json'u GitHub'daki kanal dalına
#                                 gönderir. Mevcut dal, main ve SURUM.md
#                                 değişmez. İzinli dallar: deneme, deneme-*,
#                                 yeni. (--deneme <dal> eski adıdır, aynıdır.)
#                                 Adım adım: belgeler/DENEME-KANALI.md,
#                                 belgeler/YENI-KURULUM.md
#
# Yayın akışı: develop'ta çalışılır → release-please sürüm PR'ı açar →
# PR birleşince .github/workflows/yayin.yml bu betiği --surum ile çalıştırır
# ve develop'u main'e taşır. main = hocalara giden hâl.
#
# Hocaların makinesinde git yok. Bu yüzden eklenti GitHub'dan git ile değil,
# zip olarak HTTPS üzerinden iner ("archive" kaynağı). Claude Code sürümü
# zip'in SHA-256 özetinden hesaplar: özet değişince hocalara güncelleme gider.
# Zip belirleyici üretilir: eklentide değişiklik yoksa özet de değişmez.
#
# İki eklenti aynı pazar yerindedir: divit (çekirdek, her kullanıcıda açık)
# ve divit-akademik (yalnız akademisyen klasöründe açık). Sürüm notu tektir,
# çekirdeğin SURUM.md'sinde durur ve iki eklentiyi birlikte anlatır.
set -euo pipefail

cd "$(dirname "$0")"
REPO="mehmetor/divit"
EKLENTILER=(divit divit-akademik)
EKLENTI="plugins/divit"
DAGITIM="dagitim"
SURUM=""
KANAL=""
[ "${1:-}" = "--surum" ] && SURUM="${2:?sürüm numarası eksik}"
if [ "${1:-}" = "--kanal" ] || [ "${1:-}" = "--deneme" ]; then
  KANAL="${2:?kanal dalı eksik (ör. --kanal yeni ya da --kanal deneme)}"
  case "$KANAL" in
    main|develop) echo "HATA: '$KANAL' kanal dalı olamaz; hocalara giden yayın --surum ile yapılır."; exit 1 ;;
    deneme|deneme-*|yeni) ;;
    *) echo "HATA: kanal dalı 'deneme', 'deneme-…' ya da 'yeni' olmalı."; exit 1 ;;
  esac
  git check-ref-format --branch "$KANAL" >/dev/null 2>&1 || { echo "HATA: '$KANAL' geçerli bir dal adı değil."; exit 1; }
  [ -z "$(git status --porcelain)" ] || { echo "HATA: çalışma ağacı temiz değil; önce commit'leyin."; git status --short; exit 1; }
fi

for AD in "${EKLENTILER[@]}"; do
  claude plugin validate "plugins/$AD" >/dev/null || { echo "HATA: $AD eklentisi doğrulanamadı."; claude plugin validate "plugins/$AD"; exit 1; }
done

SIRADAKI="$(grep -c '^## Sıradaki' "$EKLENTI/SURUM.md" || true)"

GECICI="$(mktemp -d)"; trap 'rm -rf "$GECICI"' EXIT

if [ -n "$SURUM" ] && [ "$SIRADAKI" = "1" ]; then
  TARIH="$(TZ=Europe/Istanbul date +%Y-%m-%d)"
  python3 - "$EKLENTI/SURUM.md" "$SURUM" "$TARIH" <<'PY'
import re, sys
p, surum, tarih = sys.argv[1:]
s = open(p, encoding="utf-8").read()
s = re.sub(r"^## Sıradaki", f"## {surum} · {tarih}", s, count=1, flags=re.M)
open(p, "w", encoding="utf-8").write(s)
PY
fi

# Belirleyici zip: sabit zaman damgası, sabit sıra, ek öznitelik yok.
# Zip'in kök dizini eklentinin adıdır. Özeti basar.
paketle() {
  local ad="$1"
  cp -R "plugins/$ad" "$GECICI/$ad"
  find "$GECICI/$ad" \( -name '.DS_Store' -o -name '__pycache__' \) -prune -exec rm -rf {} +
  find "$GECICI/$ad" -exec touch -h -t 202601010000 {} +
  (cd "$GECICI" && find "$ad" -type f | LC_ALL=C sort | zip -q -X -D "$GECICI/$ad.zip" -@)
  shasum -a 256 "$GECICI/$ad.zip" | cut -c1-64
}

OZETLER=()
ZIPLER=()
DEGISEN=0
for i in "${!EKLENTILER[@]}"; do
  AD="${EKLENTILER[$i]}"
  OZETLER[$i]="$(paketle "$AD")"
  ZIPLER[$i]="$DAGITIM/$AD-${OZETLER[$i]:0:12}.zip"
  [ -f "${ZIPLER[$i]}" ] || DEGISEN=1
done

# Yayın kanalı: mevcut dala dokunmadan HEAD'in ağacına zip'leri ve kanal
# dalını gösteren iki adresi (marketplace.json, şablonun settings.json'u)
# ekleyen bir commit üretir; uzaktaki dala hızlı ileri gönderir.
if [ -n "$KANAL" ]; then
  HAM="https://raw.githubusercontent.com/$REPO/$KANAL"
  PAZAR="$GECICI/pazar/.claude-plugin/marketplace.json"
  AYAR="hoca-paketi/Divit/.claude/settings.json"
  mkdir -p "$(dirname "$PAZAR")"
  git show HEAD:.claude-plugin/marketplace.json > "$PAZAR"
  git show "HEAD:$AYAR" > "$GECICI/settings.json"
  python3 - "$PAZAR" "$GECICI/settings.json" "$REPO" "$HAM" "${EKLENTILER[@]}" "${OZETLER[@]}" <<'PY'
import json, re, sys
pazar, ayar, repo, ham, *kalan = sys.argv[1:]
yari = len(kalan) // 2
d = json.load(open(pazar, encoding="utf-8"))
for ad, ozet in zip(kalan[:yari], kalan[yari:]):
    kaynak = {"source": "archive", "url": f"{ham}/dagitim/{ad}-{ozet[:12]}.zip", "sha256": ozet}
    for e in d["plugins"]:
        if e["name"] == ad:
            e["source"] = kaynak
            break
    else:
        d["plugins"].append({"name": ad, "source": kaynak})
json.dump(d, open(pazar, "w", encoding="utf-8"), ensure_ascii=False, indent=2)
open(pazar, "a").write("\n")
s = open(ayar, encoding="utf-8").read()
s, n = re.subn(rf"https://raw\.githubusercontent\.com/{re.escape(repo)}/[^/\"]+/\.claude-plugin/marketplace\.json",
               f"{ham}/.claude-plugin/marketplace.json", s)
if n != 1:
    sys.exit(f"HATA: şablonun settings.json'unda pazar yeri adresi {n} kez var (1 bekleniyordu).")
open(ayar, "w", encoding="utf-8").write(s)
PY
  claude plugin validate "$GECICI/pazar" >/dev/null || { echo "HATA: marketplace doğrulanamadı."; claude plugin validate "$GECICI/pazar"; exit 1; }

  # Geçici index: HEAD'in ağacı + değişen dosyalar. Çalışma ağacı ve dal değişmez.
  export GIT_INDEX_FILE="$GECICI/index"
  git read-tree HEAD
  for i in "${!EKLENTILER[@]}"; do
    git update-index --add --cacheinfo "100644,$(git hash-object -w "$GECICI/${EKLENTILER[$i]}.zip"),${ZIPLER[$i]}"
  done
  git update-index --cacheinfo "100644,$(git hash-object -w "$PAZAR"),.claude-plugin/marketplace.json"
  git update-index --cacheinfo "100644,$(git hash-object -w "$GECICI/settings.json"),$AYAR"
  AGAC="$(git write-tree)"
  unset GIT_INDEX_FILE

  if git ls-remote --exit-code --heads origin "$KANAL" >/dev/null 2>&1; then
    git fetch -q origin "+refs/heads/$KANAL:refs/remotes/origin/$KANAL"
    EBEVEYN="$(git rev-parse "refs/remotes/origin/$KANAL")"
  else
    EBEVEYN="$(git rev-parse HEAD)"
  fi
  KAYNAK="$(git rev-parse --short=12 HEAD) ($(git rev-parse --abbrev-ref HEAD))"
  if [ "$(git rev-parse "$EBEVEYN^{tree}")" = "$AGAC" ]; then
    echo "Kanal dalı '$KANAL' zaten güncel: $(git rev-parse --short=12 "$EBEVEYN")"
  else
    COMMIT="$(git commit-tree "$AGAC" -p "$EBEVEYN" \
      -m "chore(kanal): $KANAL ← $KAYNAK" \
      -m "Yayın kanalı (./yayinla.sh --kanal $KANAL). main'e ya da develop'a birleştirilmez.")"
    git push -q origin "$COMMIT:refs/heads/$KANAL"
    echo "Gönderildi: $KANAL → $(git rev-parse --short=12 "$COMMIT") (kaynak $KAYNAK)"
  fi
  for i in "${!EKLENTILER[@]}"; do
    echo "  ${EKLENTILER[$i]} sürümü ${OZETLER[$i]:0:12}"
  done
  # Deneme kanalında ikinci tür ayrı klasöre kurulur (aynı Mac'te iki tür
  # denenir); yeni kanalı gerçek kullanıcıya gider: varsayılan klasör.
  if [ "$KANAL" = "yeni" ]; then
    REHBER="belgeler/YENI-KURULUM.md"
    AKADEMIK_MAC="curl -fsSL $HAM/kur.sh | DIVIT_DAL=$KANAL bash"
    AKADEMIK_WIN="\$env:DIVIT_DAL='$KANAL'; irm $HAM/kur.ps1 | iex"
  else
    REHBER="belgeler/DENEME-KANALI.md"
    AKADEMIK_MAC="curl -fsSL $HAM/kur.sh | DIVIT_DAL=$KANAL DIVIT_TUR=akademisyen DIVIT_HEDEF=~/Documents/Divit-Akademik bash"
    AKADEMIK_WIN="\$env:DIVIT_DAL='$KANAL'; \$env:DIVIT_TUR='akademisyen'; \$env:DIVIT_HEDEF=Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'Divit-Akademik'; irm $HAM/kur.ps1 | iex"
  fi
  cat <<MSG

GitHub ham adresleri ~5 dakika önbellekte kalır; hemen kurarsanız eski hâl inebilir.
Mac (Terminal) — yazar, akademisyen:
  curl -fsSL $HAM/kur.sh | DIVIT_DAL=$KANAL DIVIT_TUR=yazar bash
  $AKADEMIK_MAC
Windows (PowerShell) — yazar, akademisyen:
  \$env:DIVIT_DAL='$KANAL'; \$env:DIVIT_TUR='yazar'; irm $HAM/kur.ps1 | iex
  $AKADEMIK_WIN
Bu bilgisayarda Divit başka kaynaktan kuruluysa önce: claude plugin marketplace remove divit
Rehber: $REHBER
MSG
  exit 0
fi

if [ -z "$SURUM" ]; then
  for i in "${!EKLENTILER[@]}"; do
    DURUM="yayınlanmamış değişiklik var"
    [ -f "${ZIPLER[$i]}" ] && DURUM="değişiklik yok"
    echo "Deneme: ${EKLENTILER[$i]} özet ${OZETLER[$i]:0:12} (${OZETLER[$i]}) — $DURUM"
  done
  if [ "$SIRADAKI" = "1" ]; then
    echo "Hocaya gidecek not:"
    sed -n '/^## Sıradaki/,/^## [0-9]/p' "$EKLENTI/SURUM.md" | sed '$d'
  else
    echo "UYARI: SURUM.md'de '## Sıradaki' yok. Eklenti değiştiyse hocaya not yazın."
  fi
  exit 0
fi

if [ "$DEGISEN" = "0" ]; then
  echo "Eklentilerde değişiklik yok. Yalnızca main güncellenecek."
  exit 0
fi
if [ "$SIRADAKI" != "1" ]; then
  echo "HATA: eklenti değişti ama $EKLENTI/SURUM.md'de '## Sıradaki' notu yok."
  echo "      Hocanın anlayacağı dille not yazıp develop'a gönderin."
  exit 1
fi

mkdir -p "$DAGITIM"
for i in "${!EKLENTILER[@]}"; do
  AD="${EKLENTILER[$i]}"
  [ -f "${ZIPLER[$i]}" ] || cp "$GECICI/$AD.zip" "${ZIPLER[$i]}"
  URL="https://raw.githubusercontent.com/$REPO/main/${ZIPLER[$i]}"
  python3 - "$AD" "$URL" "${OZETLER[$i]}" <<'PY'
import json, sys
ad, url, ozet = sys.argv[1:]
p = ".claude-plugin/marketplace.json"
d = json.load(open(p, encoding="utf-8"))
kaynak = {"source": "archive", "url": url, "sha256": ozet}
for e in d["plugins"]:
    if e["name"] == ad:
        e["source"] = kaynak
        break
else:
    d["plugins"].append({"name": ad, "source": kaynak})
json.dump(d, open(p, "w", encoding="utf-8"), ensure_ascii=False, indent=2)
open(p, "a").write("\n")
PY
done

claude plugin validate . >/dev/null || { echo "HATA: marketplace doğrulanamadı."; claude plugin validate .; exit 1; }

git add "${ZIPLER[@]}" .claude-plugin/marketplace.json "${EKLENTILER[@]/#/plugins/}"
git commit -q -m "chore(yayin): divit $SURUM (${OZETLER[0]:0:12} · ${OZETLER[1]:0:12})" -m "Eklenti zip'leri ve marketplace.json güncellendi."
echo "Hazır: sürüm $SURUM, ${ZIPLER[*]}"
