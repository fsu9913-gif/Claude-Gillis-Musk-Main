# Bryan's Workflow & Operation Key Uses

A complete reference repository documenting Bryan's day-to-day workflow,
operational procedures, and key command / tool usage.

---

## Table of Contents

1. [Overview](#overview)
2. [Quick Reference](#quick-reference)
3. [Workflow Documentation](#workflow-documentation)
4. [Key Operations](#key-operations)
5. [Scripts](#scripts)
6. [Templates](#templates)
7. [Contributing](#contributing)

---

## Overview

This repository serves as the single source of truth for Bryan's operational
knowledge base.  It captures:

- **Daily & weekly workflows** — step-by-step procedures for recurring tasks.
- **Key operation uses** — canonical commands, tools, and patterns used in each
  phase of work.
- **Helper scripts** — automations that speed up repetitive operations.
- **Templates** — reusable starting points for common deliverables.

---

## Quick Reference

| Task | Script / Command | Doc |
|------|-----------------|-----|
| Start daily session | `scripts/daily-start.sh` | [Workflow](docs/workflow.md) |
| End-of-day wrap-up | `scripts/daily-end.sh` | [Workflow](docs/workflow.md) |
| Weekly review | `scripts/weekly-review.sh` | [Workflow](docs/workflow.md) |
| Key shortcuts | — | [Key Operations](docs/key-operations.md) |
| Cheat sheet | — | [Quick Reference](docs/quick-reference.md) |

---

## Workflow Documentation

See **[docs/workflow.md](docs/workflow.md)** for the full, annotated workflow
covering:

- Morning startup routine
- Project task management cycle
- Communication cadences
- End-of-day wrap-up
- Weekly and monthly review loops

---

## Key Operations

See **[docs/key-operations.md](docs/key-operations.md)** for a detailed
reference of every key operation Bryan uses, organized by category:

- File & directory management
- Version control (Git) operations
- Scripting & automation
- Communication & scheduling tools
- Monitoring & reporting

---

## Scripts

| Script | Purpose |
|--------|---------|
| [`scripts/daily-start.sh`](scripts/daily-start.sh) | Runs morning startup checks |
| [`scripts/daily-end.sh`](scripts/daily-end.sh) | Runs end-of-day wrap-up |
| [`scripts/weekly-review.sh`](scripts/weekly-review.sh) | Generates weekly status summary |
| [`scripts/new-project.sh`](scripts/new-project.sh) | Scaffolds a new project directory |

---

## Templates

| Template | Purpose |
|----------|---------|
| [`templates/daily-log.md`](templates/daily-log.md) | Daily activity log |
| [`templates/weekly-summary.md`](templates/weekly-summary.md) | Weekly status report |
| [`templates/project-brief.md`](templates/project-brief.md) | New project brief |
| [`templates/meeting-notes.md`](templates/meeting-notes.md) | Meeting notes |

---

## Contributing

1. Fork this repository.
2. Create a feature branch: `git checkout -b feature/your-update`.
3. Commit your changes with a descriptive message.
4. Open a pull request against `main`.

All contributions should follow the existing document structure and naming
conventions described in [docs/workflow.md](docs/workflow.md).
