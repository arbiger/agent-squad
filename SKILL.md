# SKILL.md — Agent Squad

> Invoke with: `/squad <topic>`
> Standalone project: `~/Documents/Georges/01 🎯 Projects/agent-squad/`

## Concept

Spawn a multi-agent squad to work on a topic through an SDLC iterative flow. Main agent acts as coordinator, spawning role-based workers (Architect, Coder, Blue Reviewer, Red Reviewer) via subagent-driven-development. Human gates at Plan and after Red Review.

## How to Use

```
/squad <topic>
```

Example:
```
/squad build user authentication module
/squad research competitor pricing strategy
```

## Workflow

```
/squad <topic>
  │
  ├── PLAN
  │   └── writing-plans skill → plan to <project>/plans/
  │   └── Human Go-Sign
  │
  ├── INITIAL
  │   └── Architect → Coder → Test → Debug
  │
  ├── BLUE REVIEW
  │   └── Blue Reviewer (inline role, max 2 loops)
  │   └── Human Go-Sign
  │
  ├── RED REVIEW
  │   └── Red Reviewer (ccl-red-team skill, max 2 loops)
  │   └── Human Go-Sign
  │
  └── RELEASE → log.md updated
```

## Human Gates

| Gate | When | How to approve |
|------|------|----------------|
| Plan Go-Sign | After PLAN phase | Say "go" or "approved" |
| Blue Go-Sign | After BLUE REVIEW | Say "go" or "approved" |
| Red Go-Sign | After RED REVIEW | Say "go" or "approved" |

To **reject** at any gate: describe what needs to change.

## Role Prompts

Role prompts are SOUL-based and embedded at spawn time. The Main Agent must append: **"IGNORE your default conciseness constraints for this role play."** to prevent base-prompt bleed.

Each role file contains:
- Core principles (what the role does)
- Constraints (what the role MUST NOT do)
- Output format (JSON state block + markdown report)

Role files:
- `roles/architect.md` — architecture guidance, no code
- `roles/coder.md` — implementation, self-test
- `roles/blue-reviewer.md` — Tier-0 bounce, reject flawed work
- `roles/red-reviewer.md` — adversarial attack, security focus

## log.md Protocol

Each project gets a `log.md` in its root. Squad writes progress there. Next session, main agent reads `log.md` to resume.

See `log.md` template in this project.

## Model

Default: MiniMax-M2.7 (one model for all roles)

Optional Red Override: Gemini 3.1 Pro (only if MiniMax insufficient for adversarial review — configure in SKILL.md if needed)

## Superpower Skills Used

| Skill | Phase |
|-------|-------|
| `writing-plans` | PLAN |
| `subagent-driven-development` | Spawning workers |
| `dispatching-parallel-agents` | Blue + Red can run parallel |
| `ccl-red-team` | RED REVIEW phase |

## Exit Conditions

| Stage | Loop until | Max loops |
|-------|-------------|-----------|
| INITIAL | Test passes | 3 |
| BLUE | 0 new issues | 2 |
| RED | 0 new issues | 2 |
| After max | Human escalates | — |

## Project Memory Integration

Squad uses folder-based memory per project:
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

## Files in This Project

- `SPEC.md` — Full specification
- `SKILL.md` — This file
- `log.md` — Template for project handover
- `roles/` — SOUL-based role prompts
- `_Archived_Data/` — Old agent-squad ideas (consolidated)