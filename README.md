# Agent Squad

A standalone multi-agent orchestration layer using folder-based project memory and superpower skills. Main agent dispatches role-based workers (Architect, Coder, Blue Reviewer, Red Reviewer) through an SDLC iterative flow with human gates.

## Quick Start

```
/squad <topic>
```

## Architecture

- **Main Agent** (OpenCode/Hermes/OpenClaw) acts as coordinator
- **Subagents** (Architect, Coder, Blue, Red) are one-shot sessions
- **State transfer** via strict JSON blocks (no LLM-drift parsing)
- **Human gates** at Plan and after Red Review

## SDLC Flow

```
PLAN → Go-Sign → INITIAL → BLUE → Go-Sign → RED → Go-Sign → RELEASE
```

## Model

Default: MiniMax-M2.7 (one model for all roles)

## Project Structure

```
agent-squad/
├── SPEC.md              ← Full specification
├── SKILL.md            ← /squad trigger
├── log.md              ← Project handover template
├── roles/              ← SOUL-based role prompts
│   ├── architect.md
│   ├── coder.md
│   ├── blue-reviewer.md
│   └── red-reviewer.md
└── _Archived_Data/     ← Old ideas (consolidated)
```

## References

- Agent-cortex (memory backbone)
- Superpower skills (writing-plans, ccl-red-team, subagent-driven-development)