# SKILL.md — Agent Squad Concept

> **Status:** Historical record / development thinking
> **Note:** This is NOT a working skill. The `/squad` command was explored for OpenClaw but was unreliable and not supported at the time.

---

## Overview

This document records the multi-agent squad concept using role-based workers through an SDLC iterative flow with human gates.

**This is reference material only.** The active opencode agent-squad skill remains at `~/.config/opencode/skills/agent-squad/` and is unchanged.

---

## Core Concepts

### SDLC Flow

```
PLAN → INITIAL → BLUE REVIEW → RED REVIEW → RELEASE
```

### Roles

| Role | Responsibility |
|------|----------------|
| **Architect** | Read plan, define architecture, identify edge cases (no code) |
| **Coder** | Implement per plan, self-test, escalate design changes |
| **Blue Reviewer** | Correctness, quality, efficiency gate |
| **Red Reviewer** | Adversarial attack — security, edge cases |

### Human Gates

| Gate | When | Action |
|------|------|--------|
| Plan Go-Sign | After PLAN | Approve before coding |
| Blue Go-Sign | After BLUE REVIEW | Approve before red team |
| Red Go-Sign | After RED REVIEW | Final approval |

### Loop Limits

| Stage | Max Loops |
|-------|-----------|
| INITIAL | 3 |
| BLUE REVIEW | 2 |
| RED REVIEW | 2 |

---

## Model Separation Principle

**Leader model** (examples: GPT-5.5, Claude Opus):
- Planning, decomposition, judgment, final review
- Never edits files directly

**Team models** (examples: MiniMax-M2.7, Qwen-32B, Gemini Flash):
- Exploration, implementation, verification, specialist review
- Run lint/typecheck/tests, report changed files/tests/risks

> Model names are examples, not hard requirements.

---

## Development Workflow Principles

1. **Protect user changes** — never overwrite unsaved edits
2. **Require summary** — changed files, tests run, risks flagged
3. **Run lint/typecheck/tests** when relevant
4. **Review diffs** before next task
5. **No commit/push** unless explicitly requested
6. **Read before writing** — understand conventions first

---

## Role Prompts (SOUL-based)

Role prompts are SOUL-based and embedded at spawn time. Each role file contains:
- Core principles (what the role does)
- Constraints (what the role MUST NOT do)
- Output format (JSON state block + markdown report)

Role files:
- `roles/architect.md` — architecture guidance, no code
- `roles/coder.md` — implementation, self-test
- `roles/blue-reviewer.md` — Tier-0 bounce, reject flawed work
- `roles/red-reviewer.md` — adversarial attack, security focus

---

## Project Memory Integration (Concept)

```
<project>/
├── log.md              ← squad handover
├── memory/            ← agent-cortex vault (optional)
├── plans/             ← plan outputs
├── specs/            ← design specs
└── reviews/          ← blue + red outputs
```

If `memory/` exists, squad updates it (agent-cortex integration).
If not, squad uses `log.md` only.

---

## Historical Note

The `/squad <topic>` trigger was originally explored for OpenClaw integration. At the time, command integration was unreliable and not supported. The patterns (SDLC flow, roles, human gates, loop limits) remain valid for future reference.

---

## Reference

- **Active opencode skill:** `~/.config/opencode/skills/agent-squad/` (unchanged)
- **This project:** `~/Documents/Georges/01 🎯 Projects/agent-squad/`
  - `SPEC.md` — Full specification (concept status)
  - `log.md` — Handover template
  - `roles/` — SOUL-based role prompts
  - `docs/superpowers/specs/2026-05-24-agent-squad-concept-design.md`