# agent-squad-concept — Design & Specification

> **Status:** Historical Record / Development Thinking
> **Note:** The `/squad` command was explored for OpenClaw integration but proved unreliable and was not supported at the time. This document preserves the valuable concepts for future reference.

---

## 1. Concept

A development-thinking record capturing the multi-agent squad approach using role-based workers (Architect, Coder, Blue Reviewer, Red Reviewer) with a structured SDLC flow and human gates. Serves as reference material for agent orchestration patterns.

**This is NOT a working command.** It documents the thinking and principles explored.

---

## 2. Core Concepts Preserved

### 2.1 SDLC Flow

```
PLAN → INITIAL → BLUE REVIEW → RED REVIEW → RELEASE
```

### 2.2 Role Definitions

| Role | Responsibility |
|------|----------------|
| **Architect** | Reads plan, defines architecture, identifies edge cases, guides Coder (no code) |
| **Coder** | Implements according to plan, self-tests, escalates design changes |
| **Blue Reviewer** | Correctness, quality, efficiency gate — Tier-0 bounce |
| **Red Reviewer** | Adversarial attack — security, edge cases, failure modes |

### 2.3 Human Gates

1. After PLAN — approve before coding
2. After BLUE REVIEW — approve before red team
3. After RED REVIEW — final approval before release

### 2.4 Loop Limits

| Stage | Max Loops |
|-------|-----------|
| INITIAL (implement/test) | 3 |
| BLUE REVIEW | 2 |
| RED REVIEW | 2 |

### 2.5 Worker Output Protocol

Workers return strict JSON for state transfer:

```json
{
  "agent": "blue-reviewer",
  "status": "PASS",
  "findings_count": 0,
  "action": "proceed",
  "context_summary": "Clean code, no issues."
}
```

---

## 3. Model Separation Principle

### Leader Model (Planning/Judgment)
- Handles planning, task decomposition, quality judgment, final review
- Examples: GPT-5.5, Claude Opus, larger frontier models
- **Never edits files directly**

### Team Models (Implementation/Verification)
- Handle exploration, implementation, verification, specialist review
- Examples: MiniMax-M2.7, Qwen-32B, Gemini Flash
- Run lint/typecheck/tests
- Report changed files, tests, risks

> Model names are examples, not hard requirements. The principle is separation of judgment from execution.

---

## 4. Development Workflow Principles

Borrowed from current opencode agent-squad skill:

1. **Protect user changes** — never overwrite unsaved user edits
2. **Require summary** — changed files, tests run, risks flagged
3. **Run lint/typecheck/tests** when relevant before claiming done
4. **Review diffs** before next task
5. **No commit/push** unless explicitly requested
6. **Read before writing** — understand conventions first
7. **Delegate implementation** — team models write/edit; leader reviews

---

## 5. Separation from opencode Skill

The active opencode skill at `~/.config/opencode/skills/agent-squad/` remains **unchanged and separate** from this concept record. This document is historical/reference only.

---

## 6. Project Structure

```
agent-squad/
├── docs/superpowers/
│   ├── specs/2026-05-24-agent-squad-concept-design.md  ← This file
│   └── plans/2026-05-24-agent-squad-concept-plan.md   ← Implementation plan
├── README.md            ← Reframed as historical record
├── SPEC.md              ← Updated to reflect concept status
├── SKILL.md             ← Updated to remove /squad claims
├── log.md               ← Handover template (preserved)
└── roles/               ← Role definitions (preserved)
    ├── architect.md
    ├── coder.md
    ├── blue-reviewer.md
    └── red-reviewer.md
```