# Agent Squad — Project Specification

> **Author:** George
> **Date:** 2026-05-02
> **Status:** CONCEPT RECORD (not a working implementation)
>
> **Historical note:** The `/squad` command was explored for OpenClaw integration but was unreliable and not supported at the time. This document preserves the concepts for future reference.

---

## 1. Concept & Vision

A concept/design record for multi-agent squad orchestration using role-based workers (architect, coder, blue-reviewer, red-reviewer) through a flexible SDLC iterative flow with human gates.

**This is NOT a working command.** It documents the thinking explored during OpenClaw integration attempts.

**The goal:** Document the patterns — including SDLC flow (PLAN → INITIAL → BLUE → RED → RELEASE), role definitions, human gates, and loop limits — for future reference or implementation.

**Architecture:** Standalone project (`agent-squad/`) for reference. Folder-based memory per project.

---

## 2. Folder Structure

```
~/Documents/Georges/01 🎯 Projects/agent-squad/
├── SPEC.md                      ← This file
├── SKILL.md                     ← /squad skill trigger
├── log.md                       ← Template for project handover
├── roles/
│   ├── architect.md             ← SOUL-based role prompt
│   ├── coder.md                 ← SOUL-based role prompt
│   ├── blue-reviewer.md         ← SOUL-based role prompt
│   └── red-reviewer.md          ← SOUL-based role prompt
└── docs/
    └── decisions/               ← Extracted rules from reviews
```

**Per-Project Integration** (when squad runs on a project):

```
~/projects/<project-name>/
├── log.md                       ← Squad handover log (written here)
├── memory/                      ← Agent-cortex vault (local per project)
├── plans/                       ← Plan outputs
├── specs/                       ← Design specs
├── reviews/                     ← Blue + Red review outputs
└── [code files]
```

---

## 3. SDLC Flow

```
/squad <topic>
  │
  ├── PLAN
  │   └── writing-plans skill → plan written to <project>/plans/
  │   └── Human Go-Sign ← Human reviews and approves plan
  │
  ├── INITIAL
  │   └── Architect reads context → Main agent spawns Coder to implement
  │   └── Test → Debug → until test passes
  │
  ├── BLUE REVIEW
  │   └── Main agent spawns Blue Reviewer (code-reviewer role)
  │   └── If FAIL → Main agent respawns Coder with findings → Re-Blue (max 2 loops)
  │   └── Human Go-Sign ← Human approves blue results
  │
  ├── RED REVIEW
  │   └── Main agent spawns Red Reviewer (ccl-red-team skill)
  │   └── If FAIL → Main agent respawns Coder with findings → Re-Red (max 2 loops)
  │   └── Human Go-Sign ← Human final approval
  │
  └── RELEASE
      └── log.md updated with completed work
      └── memory/ folder updated (agent-cortex integration)
```

### Exit Conditions

| Stage | Loop until... | Max loops |
|-------|---------------|-----------|
| BLUE | Review passes with 0 new issues | 2 |
| RED | Review passes with 0 new issues | 2 |
| After max loops | Human escalates | — |

### Human Gates

1. **After PLAN** — approve before coding starts
2. **After BLUE REVIEW** — approve blue results before red team
3. **After RED REVIEW** — final approval before release

---

## 4. Role Definitions

### 4.1 Architect

**Trigger:** Start of INITIAL phase

**SOUL-based prompt (embed at spawn):**
```
You are the Architect. Read the plan in <project>/plans/ and project CLAUDE.md.
Define the architecture, identify edge cases, and provide guidance to the Coder.
Do NOT write code yourself. Output: architecture notes to <project>/plans/arch-notes.md
```

### 4.2 Coder

**Trigger:** After Architect guidance

**SOUL-based prompt (embed at spawn):**
```
You are the Coder. Read CLAUDE.md and arch-notes.md before writing code.
Write clean, SOLID code. Run linter/test after each change.
Self-test before reporting completion. Escalate design changes to Squad Manager.
```

### 4.3 Blue Reviewer

**Trigger:** After Coder completes

**SOUL-based prompt (embed at spawn):**
```
You are the Blue Reviewer. Review the code for correctness, quality, efficiency.
Return state strictly as JSON in your final output.
If FAIL, Main Agent will respawn Coder with your findings.
Log pass/fail to <project>/reviews/blue-review.md
```

### 4.4 Red Reviewer

**Trigger:** After Blue Review passes

**SOUL-based prompt (embed at spawn):**
```
You are the Red Reviewer. Attack the code from adversarial perspective.
Find: security issues, edge cases, failure modes, performance problems.
Return state strictly as JSON in your final output.
If FAIL, Main Agent will respawn Coder with your findings.
Log findings to <project>/reviews/red-review.md
```

---

## 5. Superpower Skill Integration

| Skill | When used | Mode |
|-------|-----------|------|
| `writing-plans` | PLAN phase | Main agent invokes, writes to <project>/plans/ |
| `executing-plans` | Throughout | Main agent uses for relay protocol |
| `subagent-driven-development` | Spawning workers | Main agent spawns architect/coder/blue/red as subagents |
| `dispatching-parallel-agents` | Blue + Red parallel | Can dispatch blue and red concurrently |
| `ccl-red-team` | RED REVIEW | Full adversarial review prompts |

**Model Configuration:**
- Default: MiniMax-M2.7 (one model for all)
- Optional override: Gemini 3.1 Pro for Red Review (only if evidence shows MiniMax insufficient)

---

## 6. Handover Protocol (JSON + log.md)

To prevent LLM parsing drift, state transfer between workers and Main Agent is handled via strict JSON. `log.md` is maintained for human readability.

### Worker Output JSON Standard
Every worker MUST end their execution with a strict JSON block for the Main Agent to parse:

```json
{
  "agent": "blue-reviewer",
  "status": "PASS", 
  "findings_count": 0,
  "action": "proceed",
  "context_summary": "Code follows architecture, no efficiency issues found."
}
```
*If FAIL, `action` becomes `"respawn_coder"` and `context_summary` contains pruned findings to avoid token exhaustion in the next loop.*

### log.md Structure (For Humans)

```markdown
# Project: <name>

## Squad Session
- **Date:** YYYY-MM-DD
- **Topic:** <task>
- **Status:** IN_PROGRESS | REVIEW | DONE

## Plan
- [ ] link to <project>/plans/

## Progress
### INITIAL
- [ ] Task description
- [ ] Test results
- [ ] Debug notes

### BLUE REVIEW
- [ ] Reviewer: <agent>
- [ ] Findings: <count>
- [ ] Status: PASS | FAIL | FIX_IN_PROGRESS

### RED REVIEW
- [ ] Reviewer: <agent>
- [ ] Findings: <count>
- [ ] Status: PASS | FAIL | FIX_IN_PROGRESS

## Decisions
(extracted rules from reviews)

## Handover
- Last agent: <name>
- Next action: <description>
```

### Handover Rules

1. Each worker writes progress to `log.md` before terminating
2. Next worker reads `log.md` to pick up where left off
3. Final RELEASE marks status = DONE
4. Human gates are recorded in `log.md` with timestamp

---

## 7. Trigger Mechanism (Historical)

**This section describes the original `/squad` trigger concept — it is not currently functional.**

The `/squad` command was explored for OpenClaw integration:
```
/squad <topic>
```

**Example:**
```
/squad build user authentication module for project X
```

**Why it didn't work:** Command integration was unreliable and not supported at the time.

**What was intended:**
1. Parse topic and identify target project folder
2. Read project context (CLAUDE.md, existing log.md if any)
3. Spawn Architect subagent for PLAN phase
4. Continue through SDLC flow
5. Human gates require explicit approval

The concepts (SDLC flow, roles, human gates, loop limits) remain valid for future implementation attempts.

---

## 8. Rollout (Concept Phase — On Hold)

**Status:** This project is now a concept/design record. The `/squad` command was not implemented due to OpenClaw integration limitations at the time.

The concepts documented here remain valid for future reference.

---

## 9. Reference

- Agent Soul Framework: `drafts/agent-soul-framework/`
- Squad Framework (OpenClaw, archived): historical reference only
- Long-running Agent concept: `2026-03-22-Long-running Agent 的真正意思：交接零成本.md`
- Agent-cortex (memory backbone): `/Users/george/Documents/Georges/01 🎯 Projects/agent-cortex/`