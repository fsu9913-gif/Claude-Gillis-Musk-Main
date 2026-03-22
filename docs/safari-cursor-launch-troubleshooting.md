# Safari Not Opening When Launching Cursor (macOS)

Use this guide if Safari will not open when Cursor (or a Cursor link/action)
tries to launch a browser.

## Quick diagnosis

Run this from the repository root on your Mac:

```bash
bash scripts/macos-safari-cursor-check.sh --run-open-test
```

This checks:

- command path shadowing (`open`, `osascript`, etc.),
- duplicate `Safari.app` or `Cursor.app` bundles,
- Safari code signature and Gatekeeper assessment,
- suspicious LaunchAgents/LaunchDaemons entries,
- LaunchServices default browser handler snippets.

The script writes a report to your Desktop (file name starts with
`safari_cursor_diagnostic_`).

## Common root causes and fixes

1. Duplicate or fake app bundle
   - Symptom: multiple `Safari.app` results from Spotlight, especially outside
     `/Applications`.
   - Fix: keep the official `/Applications/Safari.app`; remove impostor copies.

2. Corrupted LaunchServices mapping
   - Symptom: `open -a Safari` fails, or URL clicks do nothing/wrong app opens.
   - Fix:
     ```bash
     bash scripts/macos-safari-cursor-check.sh --reset-launch-services
     ```
     Then log out/in and test again.

3. Suspicious persistence entry (hijack behavior)
   - Symptom: browser opens wrong app/site; relaunch behavior keeps changing.
   - Fix: inspect LaunchAgents/Daemons reported by the script and remove
     suspicious entries.

4. Browser default mismatch
   - Symptom: Cursor opens a different browser unexpectedly.
   - Fix: macOS System Settings -> Desktop & Dock -> Default web browser ->
     Safari.

## Manual verification commands

Run these on macOS:

```bash
open -a Safari "https://example.com"
open -b com.apple.Safari "https://example.com"
```

Both should open Safari.

## If the issue still persists

1. Reboot macOS.
2. Update macOS and Safari.
3. Run malware scan tooling (XProtect definitions + reputable scanner).
4. Share the generated diagnostic report so the specific failing layer can be
   identified (signature, handler mapping, or persistence entry).
