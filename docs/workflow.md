# Bryan's Workflow

This document describes Bryan's complete operational workflow — from morning
startup through end-of-day wrap-up, weekly reviews, and project management
cycles.

---

## 1. Daily Startup Routine

**Goal:** Orient quickly and set priorities for the day.

### Steps

1. **Open task manager / to-do list**
   - Review any items carried over from the previous day.
   - Mark any newly completed items.

2. **Check communications**
   - Scan email inbox — action, delegate, or archive each item.
   - Review chat/messaging apps (Slack, Teams, etc.).
   - Flag items that need a response within the day.

3. **Review calendar**
   - Confirm all meetings for the day.
   - Block focus time around meetings.

4. **Set the day's top 3 priorities**
   - Write them in the [daily log](../templates/daily-log.md).
   - Post them somewhere visible (sticky note, second monitor, etc.).

5. **Run daily-start script**
   ```bash
   bash scripts/daily-start.sh
   ```
   The script checks for pending git branches, outstanding PRs, and system
   health (disk space, backups).

---

## 2. Project Task Management Cycle

**Cadence:** Continuous throughout the day.

### Steps

1. **Pick the next task** from the prioritized backlog.
2. **Create or reuse a feature branch** (for code tasks):
   ```bash
   git checkout -b feature/<ticket-id>-short-description
   ```
3. **Work the task** using the relevant key operations (see
   [key-operations.md](key-operations.md)).
4. **Commit frequently** with clear messages:
   ```bash
   git add -p          # stage hunks interactively
   git commit -m "type(scope): short imperative description"
   ```
5. **Open a pull request** when the task is complete and tests pass.
6. **Update the task tracker** — move the card to "In Review" or "Done".

### Commit Message Convention

```
<type>(<scope>): <short summary>

[optional body]

[optional footer — issue refs, breaking changes]
```

| Type | When to use |
|------|------------|
| `feat` | New feature |
| `fix` | Bug fix |
| `docs` | Documentation only |
| `chore` | Build / tooling / dependency updates |
| `refactor` | Code change that neither fixes a bug nor adds a feature |
| `test` | Adding or correcting tests |

---

## 3. Communication Cadences

| Channel | Frequency | Action |
|---------|-----------|--------|
| Email | 3× / day (morning, noon, EOD) | Triage inbox to zero |
| Slack / Teams | Continuous (during focus hours: check every 30 min) | Reply or snooze |
| Standup | Daily (async or live) | Post yesterday / today / blockers |
| 1-on-1s | Weekly | Prepare agenda 1 day in advance |
| Team sync | Weekly | Review sprint board; update tickets |

---

## 4. End-of-Day Wrap-Up

**Goal:** Close the day cleanly and set up tomorrow for success.

### Steps

1. **Complete or defer open tasks**
   - Any task not finished → move to tomorrow's list with a note on status.

2. **Commit & push all work-in-progress**
   ```bash
   git add .
   git commit -m "wip: end-of-day checkpoint"
   git push
   ```

3. **Update the daily log**
   - Fill in accomplishments, blockers, and notes using
     [templates/daily-log.md](../templates/daily-log.md).

4. **Clear inbox / notifications**
   - Respond to anything that takes < 2 minutes.
   - Defer everything else with a clear due date.

5. **Run daily-end script**
   ```bash
   bash scripts/daily-end.sh
   ```
   The script commits the daily log, checks backup status, and prints
   tomorrow's calendar preview.

6. **Shut down cleanly**
   - Close all browser tabs not needed tomorrow.
   - Close all editor windows.
   - Lock workstation.

---

## 5. Weekly Review Loop

**Cadence:** Every Friday (or last workday of the week).

### Steps

1. **Review all open projects** — update status for each.
2. **Process the task backlog** — groom, estimate, and prioritize next week.
3. **Generate weekly summary**
   ```bash
   bash scripts/weekly-review.sh
   ```
4. **Fill in the weekly summary template**
   ([templates/weekly-summary.md](../templates/weekly-summary.md)).
5. **Send the summary** to relevant stakeholders.
6. **Plan next week** — set Monday's top 3 priorities.

---

## 6. Monthly Review Loop

**Cadence:** Last working day of each month.

### Steps

1. **Audit all active projects** — are they on track, at risk, or blocked?
2. **Review key metrics** — velocity, defect rate, communication health.
3. **Archive completed projects** per the archival procedure.
4. **Review account security posture**:
   - Verify Google SSO access and audit logs for Cloudflare, GitHub, and Claude
     using [google-sso-access-runbook.md](google-sso-access-runbook.md).
5. **Update documentation** — ensure this repo reflects current practice.
6. **1-on-1 with manager / key stakeholder** to align on priorities for the
   coming month.

---

## 7. New Project Kickoff

1. **Create project scaffold**:
   ```bash
   bash scripts/new-project.sh "<Project Name>"
   ```
2. **Fill in the project brief**: [templates/project-brief.md](../templates/project-brief.md).
3. **Set up repository** (if code project):
   - Initialize git, add `.gitignore`, push to remote.
   - Configure branch protections and CI.
4. **Brief stakeholders** — share the project brief and agree on scope.
5. **Add project to task tracker** and create initial backlog.
