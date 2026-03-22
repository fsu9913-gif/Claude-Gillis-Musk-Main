# Google SSO Access Runbook (Cloudflare, GitHub, Claude)

This runbook defines the secure setup required so Google accounts can be used
to access Cloudflare, GitHub, and Claude.

## Scope

- Primary accounts:
  - `bgillis99` (convert to full email identity if this is only a username)
  - `admin@mobilecarsmoketest.com`
- Target services:
  - Cloudflare
  - GitHub
  - Claude

## 1) Google-side requirements (must be done first)

1. Use full Google identities, not nicknames.
   - Confirm both users can sign in at <https://accounts.google.com>.
   - If `bgillis99` is only a local username, map it to a real Google account
     (for example, `bgillis99@gmail.com` or a Workspace user).

2. Harden both Google accounts.
   - Enforce 2-Step Verification.
   - Register at least two factors:
     - one phishing-resistant factor (passkey or hardware security key), and
     - one backup factor.
   - Confirm recovery email and recovery phone are set.

3. If using Google Workspace for `mobilecarsmoketest.com`, enforce org policy.
   - Security -> Authentication -> require 2SV.
   - Turn on context-aware/session controls if available.
   - Restrict risky third-party OAuth apps.
   - Allow required app integrations for Cloudflare, GitHub Enterprise SSO, and
     Anthropic/Claude if your org policy blocks them.

4. Verify domain identity hygiene.
   - Ensure `mobilecarsmoketest.com` is verified in Google Admin.
   - Verify SPF/DKIM/DMARC records to reduce account recovery/email risk.

## 2) Service setup

### A. Cloudflare

There are two common patterns:

1. Personal dashboard login:
   - User signs in to Cloudflare and links Google where available in account
     login methods.

2. Team/Zero Trust SSO (recommended):
   - Cloudflare Zero Trust -> Settings -> Authentication.
   - Add Google Workspace as IdP.
   - Restrict allowed email domains/users to approved accounts only.
   - Enforce short session durations and device posture checks as needed.

### B. GitHub

Important: Standard personal GitHub accounts are not universally managed by
"Sign in with Google" for existing users. For secure org-wide Google-based
access control, use GitHub Enterprise Cloud SAML SSO with Google Workspace as
the identity provider.

Recommended secure model:

1. Keep strong GitHub account security for both users.
   - Enable GitHub 2FA/passkeys.
   - Use unique recovery codes stored securely.

2. If this is an organization, configure SSO:
   - GitHub Organization -> Security -> Authentication security.
   - Enable SAML SSO (Enterprise/Org feature set required).
   - Configure Google Workspace as IdP.
   - Enforce SSO for org resources.

### C. Claude

1. Use "Continue with Google" on Claude sign-in.
2. Ensure the exact approved Google account is selected.
3. If the Google button is blocked or missing:
   - check Workspace third-party app restrictions,
   - allow Anthropic/Claude OAuth app access in Admin console,
   - retry in an incognito window to rule out stale cookies/session mixups.

## 3) Verification checklist

For each user (`bgillis99` mapped account and `admin@mobilecarsmoketest.com`):

- [ ] Google login works directly at accounts.google.com.
- [ ] 2SV enabled with at least two factors.
- [ ] Cloudflare access succeeds via approved Google identity.
- [ ] GitHub account has 2FA/passkey enabled.
- [ ] If org SSO is configured, GitHub org access enforces Google SSO.
- [ ] Claude login works via "Continue with Google".
- [ ] No unapproved personal Google account can access protected org resources.

## 4) Recovery and lockout controls

- Store backup codes for Google and GitHub in a secure vault.
- Keep at least two super-admins for Google Workspace and Cloudflare.
- Add a break-glass account with strong random password + hardware key,
  monitored and used only for emergencies.
- Review login/audit events monthly across Google, Cloudflare, GitHub, Claude.

## 5) Common failures and fixes

- "Google login option not shown":
  - service does not support Google auth for that account tier/path, or
  - org policy is blocking third-party OAuth app consent.
- "Account exists but cannot access team resources":
  - user is signed in with the wrong Google profile in the browser.
- "SSO loop":
  - clear cookies for the service domain and retry with one browser profile.
- "Access was working and suddenly stopped":
  - check Google Admin app access policies and service audit logs first.
