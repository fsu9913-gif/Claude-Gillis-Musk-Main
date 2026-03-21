#!/usr/bin/env bash
# daily-start.sh — Bryan's morning startup checks
# Usage: bash scripts/daily-start.sh

set -euo pipefail

CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
RESET='\033[0m'

section() { echo -e "\n${CYAN}══ $1 ══${RESET}"; }
ok()      { echo -e "  ${GREEN}✔${RESET}  $1"; }
warn()    { echo -e "  ${YELLOW}⚠${RESET}  $1"; }
err()     { echo -e "  ${RED}✖${RESET}  $1"; }

echo -e "${CYAN}"
printf '╔══════════════════════════════════════════╗\n'
printf "║  Bryan's Daily Startup — %-16s  ║\n" "$(date '+%a %b %d')"
printf '╚══════════════════════════════════════════╝'"${RESET}"$'\n'

# ── 1. Disk space ──────────────────────────────────────────────────────────────
section "Disk Space"
USAGE=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')
df -h / | awk 'NR<=2 {print "  "$0}'
if [ "$USAGE" -lt 80 ]; then
  ok "Disk usage at ${USAGE}% — OK"
elif [ "$USAGE" -lt 90 ]; then
  warn "Disk usage at ${USAGE}% — consider cleanup"
else
  err "Disk usage at ${USAGE}% — ACTION REQUIRED"
fi

# ── 2. Git status across known repos ──────────────────────────────────────────
section "Git Repository Status"
REPOS=(
  "."
  # Add more repo paths here, e.g.:
  # "$HOME/projects/my-project"
)
for REPO in "${REPOS[@]}"; do
  if [ -d "$REPO/.git" ]; then
    BRANCH=$(git -C "$REPO" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")
    DIRTY=$(git -C "$REPO" status --porcelain 2>/dev/null | wc -l | tr -d ' ')
    AHEAD=$(git -C "$REPO" rev-list --count "@{u}..HEAD" 2>/dev/null || echo "0")
    BEHIND=$(git -C "$REPO" rev-list --count "HEAD..@{u}" 2>/dev/null || echo "0")

    MSG="$(basename "$(realpath "$REPO")") [${BRANCH}]"
    [ "$DIRTY" -gt 0 ] && MSG+=" — ${DIRTY} uncommitted change(s)"
    [ "$AHEAD"  -gt 0 ] && MSG+=" — ${AHEAD} commit(s) ahead of remote"
    [ "$BEHIND" -gt 0 ] && warn "${MSG} — ${BEHIND} commit(s) behind remote" && continue
    ok "$MSG"
  fi
done

# ── 3. Pending reminders from yesterday's log ─────────────────────────────────
section "Yesterday's Carry-Overs"
YESTERDAY=$(date -d "yesterday" '+%Y-%m-%d' 2>/dev/null \
            || date -v-1d '+%Y-%m-%d' 2>/dev/null \
            || echo "")
LOG_FILE="logs/daily/${YESTERDAY}.md"
if [ -f "$LOG_FILE" ]; then
  CARRY=$(grep -E '^\s*-\s*\[ \]' "$LOG_FILE" || true)
  if [ -n "$CARRY" ]; then
    warn "Incomplete items from ${YESTERDAY}:"
    echo "$CARRY" | sed 's/^/    /'
  else
    ok "No carry-overs from yesterday"
  fi
else
  ok "No log found for ${YESTERDAY} (first run or log missing)"
fi

# ── 4. Today's calendar preview ───────────────────────────────────────────────
section "Today"
echo "  Date : $(date '+%A, %B %d %Y')"
echo "  Time : $(date '+%H:%M %Z')"
echo ""
echo "  📋  Open today's task manager and set your top 3 priorities."
echo "  📅  Check your calendar for meetings."
echo "  📬  Triage your inbox."

echo -e "\n${GREEN}✔  Startup complete — have a productive day!${RESET}\n"
