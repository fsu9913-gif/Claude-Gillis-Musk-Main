#!/usr/bin/env bash
# daily-end.sh — Bryan's end-of-day wrap-up
# Usage: bash scripts/daily-end.sh

set -euo pipefail

CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RESET='\033[0m'

section() { echo -e "\n${CYAN}══ $1 ══${RESET}"; }
ok()      { echo -e "  ${GREEN}✔${RESET}  $1"; }
warn()    { echo -e "  ${YELLOW}⚠${RESET}  $1"; }

TODAY=$(date '+%Y-%m-%d')

echo -e "${CYAN}"
printf '╔══════════════════════════════════════════╗\n'
printf "║  Bryan's End-of-Day — %-19s  ║\n" "$(date '+%a %b %d')"
printf '╚══════════════════════════════════════════╝'"${RESET}"$'\n'

# ── 1. Commit any WIP ─────────────────────────────────────────────────────────
section "Git WIP Check"
if [ -d ".git" ]; then
  DIRTY=$(git status --porcelain | wc -l | tr -d ' ')
  if [ "$DIRTY" -gt 0 ]; then
    warn "${DIRTY} uncommitted change(s) found. Committing as WIP..."
    git add .
    git commit -m "wip: end-of-day checkpoint ${TODAY}"
    git push 2>/dev/null || warn "Push failed — check remote connection"
    ok "WIP committed and pushed"
  else
    ok "Working tree clean — nothing to commit"
    # Still push in case commits exist that aren't pushed
    git push 2>/dev/null || true
  fi
fi

# ── 2. Create today's daily log if it doesn't exist ──────────────────────────
section "Daily Log"
LOG_DIR="logs/daily"
LOG_FILE="${LOG_DIR}/${TODAY}.md"
mkdir -p "$LOG_DIR"

if [ ! -f "$LOG_FILE" ]; then
  cp templates/daily-log.md "$LOG_FILE" 2>/dev/null || cat > "$LOG_FILE" <<LOGEOF
# Daily Log — ${TODAY}

## Top 3 Priorities
- [ ] 
- [ ] 
- [ ] 

## Accomplishments
- 

## Blockers / Notes
- 

## Tomorrow's Carry-Overs
- [ ] 
LOGEOF
  ok "Created ${LOG_FILE}"
else
  ok "Log already exists: ${LOG_FILE}"
fi

echo "  📝  Open ${LOG_FILE} and fill in today's accomplishments."

# ── 3. Commit the daily log ───────────────────────────────────────────────────
section "Committing Daily Log"
if [ -d ".git" ]; then
  git add "$LOG_FILE" 2>/dev/null || true
  if ! git diff --cached --quiet 2>/dev/null; then
    git commit -m "docs(log): daily log ${TODAY}"
    git push 2>/dev/null || warn "Push failed — check remote connection"
    ok "Daily log committed"
  else
    ok "Daily log already committed"
  fi
fi

# ── 4. Tomorrow preview ───────────────────────────────────────────────────────
section "Tomorrow"
TOMORROW=$(date -d "tomorrow" '+%A, %B %d %Y' 2>/dev/null \
           || date -v+1d '+%A, %B %d %Y' 2>/dev/null \
           || echo "tomorrow")
echo "  📅  Next workday: ${TOMORROW}"
echo "  📋  Set your top 3 priorities for tomorrow before you close up."
echo "  🔒  Lock your workstation and close unused applications."

echo -e "\n${GREEN}✔  End-of-day wrap-up complete — great work today!${RESET}\n"
