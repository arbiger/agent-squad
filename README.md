# Agent Squad — Concept Record

> **Status:** Historical record / development thinking
> **Note:** The `/squad` command was explored for OpenClaw integration but was unreliable and not supported at the time. This document preserves the valuable concepts.

---

## Overview

A multi-agent orchestration concept using role-based workers through an SDLC iterative flow with human gates. Serves as reference material for agent orchestration patterns.

**This is NOT a working command.** It documents the thinking explored.

---

## Architecture

- **Main Agent** (OpenCode/Hermes/OpenClaw) acts as coordinator
- **Subagents** (Architect, Coder, Blue, Red) are role-based workers
- **State transfer** via strict JSON blocks
- **Human gates** at Plan, after Blue Review, and after Red Review

---

## SDLC Flow

```
PLAN → INITIAL → BLUE REVIEW → RED REVIEW → RELEASE
```

### Human Gates

1. After PLAN — approve before coding starts
2. After BLUE REVIEW — approve before red team
3. After RED REVIEW — final approval before release

### Loop Limits

| Stage | Max Loops |
|-------|-----------|
| INITIAL (implement/test) | 3 |
| BLUE REVIEW | 2 |
| RED REVIEW | 2 |

---

## Model Separation Principle

**Leader model** (planning/judgment): GPT-5.5, Claude Opus, etc.
- Handles planning, task decomposition, quality judgment, final review
- Never edits files directly

**Team models** (implementation/verification): MiniMax-M2.7, Qwen-32B, etc.
- Handle exploration, implementation, verification, specialist review
- Run lint/typecheck/tests, report changed files/tests/risks

> Model names are examples, not hard requirements.

---

## Role Definitions

| Role | Responsibility |
|------|----------------|
| **Architect** | Read plan, define architecture, identify edge cases, guide Coder (no code) |
| **Coder** | Implement per plan, self-test, escalate design changes |
| **Blue Reviewer** | Correctness, quality, efficiency gate — Tier-0 bounce |
| **Red Reviewer** | Adversarial attack — security, edge cases, failure modes |

---

## Project Structure

```
agent-squad/
├── SPEC.md              ← Full specification (concept status)
├── SKILL.md             ← Historical trigger documentation
├── log.md               ← Handover template
├── docs/superpowers/
│   ├── specs/2026-05-24-agent-squad-concept-design.md
│   └── plans/2026-05-24-agent-squad-concept-plan.md
└── roles/
    ├── architect.md
    ├── coder.md
    ├── blue-reviewer.md
    └── red-reviewer.md
```

---

## Development Workflow Principles

(from current opencode agent-squad skill — preserved here)

1. **Protect user changes** — never overwrite unsaved user edits
2. **Require summary** — changed files, tests run, risks flagged
3. **Run lint/typecheck/tests** when relevant before claiming done
4. **Review diffs** before next task
5. **No commit/push** unless explicitly requested
6. **Read before writing** — understand conventions first

---

## References

- [Agent-cortex](https://github.com/arbiger/agent-cortex) — memory backbone
- Superpower skills (writing-plans, ccl-red-team, subagent-driven-development)
- **Active opencode skill:** `~/.config/opencode/skills/agent-squad/` (separate, unchanged)

---

## Historical Note

The `/squad` command was originally explored for OpenClaw integration. At the time, command integration was unreliable and not supported. This record preserves the concepts for future reference — particularly the role definitions, SDLC flow, and human gate pattern.