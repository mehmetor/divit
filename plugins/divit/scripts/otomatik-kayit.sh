#!/usr/bin/env bash
# Divit — otomatik yedekleme.
# Hocanın klasörünü sessizce git'e kaydeder. Hoca git'i hiç görmez.
# Amaç: "üç haftalık yazım bozuldu" felaketini imkânsız kılmak.
set -uo pipefail

asama="${1:-bitis}"
kok="${CLAUDE_PROJECT_DIR:-$PWD}"

# Yalnızca Divit çalışma klasöründe çalış. Başka projeye dokunma.
[ -f "$kok/.divit-vault" ] || exit 0
command -v git >/dev/null 2>&1 || exit 0
cd "$kok" || exit 0

if [ ! -d .git ]; then
  git init -q
  git config user.name  "Divit"
  git config user.email "divit@local"
  [ -f .gitignore ] || printf '.DS_Store\n*.tmp\n.claude/oturum/*\n!.claude/oturum/.gitkeep\n' > .gitignore
fi

git add -A >/dev/null 2>&1
git diff --cached --quiet && exit 0   # değişiklik yoksa sessizce çık

etiket=$([ "$asama" = "baslangic" ] && echo "oturum öncesi" || echo "oturum sonrası")
git -c user.name=Divit -c user.email=divit@local \
    commit -q -m "$etiket — $(date '+%Y-%m-%d %H:%M')" >/dev/null 2>&1

[ "$asama" = "baslangic" ] && echo "Yedek alındı. Bir şey bozulursa \`/divit:geri-al\` yeter."
exit 0
