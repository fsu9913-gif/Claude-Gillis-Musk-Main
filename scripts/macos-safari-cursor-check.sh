#!/usr/bin/env bash
# macos-safari-cursor-check.sh
# Diagnose Safari launch failures and browser/app hijacking indicators on macOS.
#
# Usage:
#   bash scripts/macos-safari-cursor-check.sh
#   bash scripts/macos-safari-cursor-check.sh --run-open-test
#   bash scripts/macos-safari-cursor-check.sh --reset-launch-services

set -euo pipefail

RUN_OPEN_TEST=0
RESET_LS=0

for arg in "$@"; do
  case "$arg" in
    --run-open-test) RUN_OPEN_TEST=1 ;;
    --reset-launch-services) RESET_LS=1 ;;
    -h|--help)
      echo "Usage: bash scripts/macos-safari-cursor-check.sh [--run-open-test] [--reset-launch-services]"
      exit 0
      ;;
    *)
      echo "Unknown argument: $arg"
      exit 1
      ;;
  esac
done

if [ "$(uname -s)" != "Darwin" ]; then
  echo "This script must be run on macOS."
  exit 1
fi

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RESET='\033[0m'

section() { echo -e "\n${CYAN}== $1 ==${RESET}"; }
ok()      { echo -e "  ${GREEN}[OK]${RESET} $1"; }
warn()    { echo -e "  ${YELLOW}[WARN]${RESET} $1"; }
err()     { echo -e "  ${RED}[ERR]${RESET} $1"; }

REPORT_DIR="${HOME}/Desktop"
REPORT_FILE="${REPORT_DIR}/safari_cursor_diagnostic_$(date '+%Y%m%d_%H%M%S').txt"
mkdir -p "$REPORT_DIR"
exec > >(tee "$REPORT_FILE") 2>&1

echo "Safari/Cursor diagnostic report"
echo "Generated: $(date -u '+%Y-%m-%d %H:%M:%S UTC')"
echo "Host: $(hostname)"

section "Binary and path shadow checks"
echo "PATH=$PATH"
type -a open || true
type -a osascript || true
type -a python3 || true

section "Safari bundle checks"
if [ -d "/Applications/Safari.app" ]; then
  ok "Found /Applications/Safari.app"
else
  err "Missing /Applications/Safari.app (unexpected on macOS)"
fi

echo "All Safari.app bundles found:"
mdfind "kMDItemFSName == 'Safari.app'" || true

echo "Safari code signature verify:"
codesign --verify --deep --strict --verbose=2 "/Applications/Safari.app" || warn "codesign verify returned non-zero"

echo "Safari Gatekeeper assessment:"
spctl --assess --type execute --verbose=4 "/Applications/Safari.app" || warn "spctl assess returned non-zero"

section "Cursor bundle checks (if installed)"
echo "Cursor.app bundles found:"
mdfind "kMDItemFSName == 'Cursor.app'" || true

section "Default browser handler checks"
LS_PLIST="${HOME}/Library/Preferences/com.apple.LaunchServices/com.apple.launchservices.secure.plist"
if [ -f "$LS_PLIST" ]; then
  ok "Found LaunchServices plist: $LS_PLIST"
  # Show handler snippets for http/https without dumping unrelated private data.
  defaults read com.apple.LaunchServices/com.apple.launchservices.secure LSHandlers 2>/dev/null \
    | awk '/LSHandlerURLScheme = http|LSHandlerURLScheme = https|LSHandlerRoleAll|LSHandlerRoleViewer/' || true
else
  warn "LaunchServices plist not found at expected location"
fi

section "Suspicious persistence check (LaunchAgents/Daemons)"
SCAN_DIRS=(
  "${HOME}/Library/LaunchAgents"
  "/Library/LaunchAgents"
  "/Library/LaunchDaemons"
)

for d in "${SCAN_DIRS[@]}"; do
  if [ -d "$d" ]; then
    echo "Scanning: $d"
    # Use basic grep for portability on stock macOS.
    grep -R -nEi "safari|cursor|browser|open[[:space:]]+-a|osascript|http[s]?://" "$d" 2>/dev/null || echo "  no keyword hits"
  else
    echo "Missing: $d"
  fi
done

section "Ad-hoc process check"
ps aux | grep -Ei "safari|cursor|osascript|launchservices" | grep -v grep || true

if [ "$RUN_OPEN_TEST" -eq 1 ]; then
  section "Live open test"
  echo "Attempting: open -a Safari https://example.com"
  if open -a Safari "https://example.com"; then
    ok "open command succeeded"
  else
    err "open command failed"
  fi
fi

if [ "$RESET_LS" -eq 1 ]; then
  section "Reset LaunchServices (requested)"
  LSREGISTER="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister"
  if [ -x "$LSREGISTER" ]; then
    echo "Running lsregister reset..."
    "$LSREGISTER" -kill -seed -r -domain local -domain system -domain user
    ok "LaunchServices database reset complete"
    warn "You may need to log out/in, then retry opening Safari."
  else
    err "lsregister tool not found at expected path"
  fi
fi

section "Next actions"
echo "1) If duplicate Safari.app bundles exist outside /Applications, inspect and remove impostors."
echo "2) If LaunchAgents contain suspicious entries, unload and remove them."
echo "3) Re-run with --reset-launch-services if browser handlers look corrupted."
echo "4) Run an anti-malware scan (XProtect update + Malwarebytes) if compromise is suspected."

echo
ok "Diagnostic completed"
echo "Report written to: $REPORT_FILE"
