# Coding Rules

## Coding Baseline — 12 Rules

All roles in the `agent-squad` workflow follow the Andrej Karpathy-inspired baseline:

1. **Think Before Coding** — state assumptions, ask rather than guess, stop when confused
2. **Simplicity First** — minimum code, no speculative features, no single-use abstractions
3. **Surgical Changes** — touch only what you must, don't refactor what isn't broken
4. **Goal-Driven Execution** — define success criteria, iterate until verified
5. **Model for Judgment** — use for classification, drafting, summarization; NOT routing or deterministic transforms
6. **Token Budgets** — per-task 4k tokens, per-session 30k tokens, surface breaches
7. **Surface Conflicts** — pick one pattern, explain why, flag the other; don't average them
8. **Read Before Write** — read exports, callers, shared utilities first
9. **Tests Verify Intent** — encode WHY, not just WHAT
10. **Checkpoint After Steps** — summarize done/verified/left after each significant step
11. **Match Conventions** — conformance > taste; surface disagreements don't fork silently
12. **Fail Loud** — "completed" is wrong if anything skipped, surface uncertainty, don't hide it

---

## Origin

The 12 rules are an external baseline, not embedded in `agent-squad` itself. They apply to every role (Team-Lead, Planner, Worker/Coder, PM-Reviewer, fpr-reviewer, Codex-Executor) as a default operating code.

Source: https://gist.github.com/Planxnx/64b173bacf2c8c43435c4333d0b9bd94

Companion skill set: https://github.com/obra/superpowers

## Application

These rules are not a checklist. They are heuristics the agent applies continuously. When in doubt, prefer the rule that surfaces the issue (Fail Loud, Surface Conflicts) over the rule that papers over it (Simplicity First, Match Conventions).
