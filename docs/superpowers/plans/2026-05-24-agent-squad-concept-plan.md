# agent-squad-concept — Implementation Plan

> Concise, actionable steps to reframe this project as a concept/development-thinking record.

---

## Tasks

- [ ] **1. Create design spec** — `docs/superpowers/specs/2026-05-24-agent-squad-concept-design.md`
  - Record approved direction and principles
  - Mark `/squad` command as historical only

- [ ] **2. Create this plan** — `docs/superpowers/plans/2026-05-24-agent-squad-concept-plan.md`

- [ ] **3. Update README.md**
  - Retitle to reflect concept/historical record status
  - Remove `/squad` quick start
  - Add note: originally explored for OpenClaw; command integration was unreliable/not supported
  - Preserve: SDLC flow, roles, human gates

- [ ] **4. Update SPEC.md**
  - Add status note: "This is a concept/design record, not a working implementation"
  - Update Section 7 (Trigger Mechanism) to note `/squad` is historical
  - Remove any claims of working `/squad` command

- [ ] **5. Update SKILL.md**
  - Rename context from "invoke with /squad" to "concept documentation"
  - Add historical note about `/squad` exploration
  - Preserve all role definitions and workflow principles

- [ ] **6. Verify**
  - Run `git status` to confirm changes
  - Search for `/squad` and `agent-squad` to ensure remaining mentions are intentional

---

## Verification Commands

```bash
git status
grep -r '/squad' --include='*.md' .
grep -r 'agent-squad' --include='*.md' .
```

---

## Risks

- `~/.config/opencode/skills/agent-squad/` must remain untouched
- Role files and log.md template are preserved as useful reference material
- No actual code changes — documentation only