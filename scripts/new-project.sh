#!/usr/bin/env bash
# new-project.sh — Scaffold a new project directory for Bryan
# Usage: bash scripts/new-project.sh "My Project Name"

set -euo pipefail

CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
RESET='\033[0m'

ok()   { echo -e "  ${GREEN}✔${RESET}  $1"; }
warn() { echo -e "  ${YELLOW}⚠${RESET}  $1"; }
err()  { echo -e "  ${RED}✖${RESET}  $1"; }

# ── Argument check ────────────────────────────────────────────────────────────
if [ $# -lt 1 ] || [ -z "$1" ]; then
  err "Usage: bash scripts/new-project.sh \"Project Name\""
  exit 1
fi

PROJECT_NAME="$1"
# Slugify: lowercase, spaces → hyphens, strip non-alphanumeric except hyphens
SLUG=$(echo "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' \
       | sed 's/[^a-z0-9-]//g' | sed 's/--*/-/g')
TODAY=$(date '+%Y-%m-%d')
PROJECTS_DIR="projects"
PROJECT_DIR="${PROJECTS_DIR}/${SLUG}"

echo -e "${CYAN}"
printf '╔══════════════════════════════════════════╗\n'
printf "║  New Project: %-27s  ║\n" "${PROJECT_NAME}"
printf "║  Slug: %-34s  ║\n" "${SLUG}"
printf '╚══════════════════════════════════════════╝'"${RESET}"$'\n'

# ── Guard: don't overwrite existing project ───────────────────────────────────
if [ -d "$PROJECT_DIR" ]; then
  err "Directory '${PROJECT_DIR}' already exists. Aborting."
  exit 1
fi

# ── Create directory structure ────────────────────────────────────────────────
mkdir -p "${PROJECT_DIR}"/{docs,assets,src}
ok "Created directory structure under ${PROJECT_DIR}/"

# ── Project brief ─────────────────────────────────────────────────────────────
BRIEF_SRC="templates/project-brief.md"
BRIEF_DEST="${PROJECT_DIR}/docs/project-brief.md"
if [ -f "$BRIEF_SRC" ]; then
  sed "s/{{PROJECT_NAME}}/${PROJECT_NAME}/g; s/{{DATE}}/${TODAY}/g" \
      "$BRIEF_SRC" > "$BRIEF_DEST"
else
  cat > "$BRIEF_DEST" <<BRIEF
# Project Brief — ${PROJECT_NAME}

**Date:** ${TODAY}
**Status:** Draft

## Overview
_Describe the project goal in 2–3 sentences._

## Objectives
1. 
2. 
3. 

## Scope
- **In scope:**
- **Out of scope:**

## Stakeholders
| Name | Role |
|------|------|
|      |      |

## Timeline
| Milestone | Target Date |
|-----------|-------------|
|           |             |

## Success Criteria
- 

## Notes
- 
BRIEF
fi
ok "Created project brief at ${BRIEF_DEST}"

# ── README ─────────────────────────────────────────────────────────────────────
cat > "${PROJECT_DIR}/README.md" <<README
# ${PROJECT_NAME}

> Created: ${TODAY}

## Overview

_Add a short description of this project._

## Getting Started

_Add setup/installation instructions here._

## Usage

_Add usage examples here._

## Contributing

Follow the [contribution guidelines](../../README.md#contributing).
README
ok "Created ${PROJECT_DIR}/README.md"

# ── Git init (optional) ───────────────────────────────────────────────────────
if command -v git &>/dev/null && [ ! -d "${PROJECT_DIR}/.git" ]; then
  cat > "${PROJECT_DIR}/.gitignore" <<GITIGNORE
# OS
.DS_Store
Thumbs.db

# Editor
.vscode/
*.swp
*.swo

# Dependencies
node_modules/
venv/
__pycache__/
*.pyc

# Build
dist/
build/
*.egg-info/
GITIGNORE

  git -C "$PROJECT_DIR" init -q \
    && git -C "$PROJECT_DIR" add . \
    && git -C "$PROJECT_DIR" commit -q -m "chore: initial project scaffold for ${PROJECT_NAME}" \
    && ok "Initialized git repository in ${PROJECT_DIR}/" \
    || warn "Could not create initial commit (git identity may not be configured). Project files are ready."
fi

echo -e "\n${GREEN}✔  Project '${PROJECT_NAME}' created at ${PROJECT_DIR}/${RESET}"
echo ""
echo "  Next steps:"
echo "    1. cd ${PROJECT_DIR}"
echo "    2. Fill in docs/project-brief.md"
echo "    3. Brief stakeholders"
echo "    4. Add to your task tracker"
echo ""
