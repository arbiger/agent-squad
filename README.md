# Agent Squad

Agent Squad is a lean SDLC operating model for agent teams. It defines roles, routing depth, handoff contracts, review gates, evidence standards, and human escalation rules for reliable project work.

It is not a model prescription. You can run it with OpenAI, MiniMax, Claude, Gemini, local models, or any runtime that supports subagents, role prompts, tool delegation, or role simulation.

## What It Solves

One-shot agents often fail in predictable ways:

- unclear scope
- hidden assumptions
- implementation drift
- weak verification
- premature "done"
- no durable record of important decisions

Agent Squad reduces those failures by separating planning, execution, and review.

Before command-heavy work, declare the route and keep the worker responsible for routine implementation and full verification when available. A lead may run targeted checks, but should explain any duplicated full-suite work. A same-worker verification follow-up is useful evidence, but is not independent testing; reserve that label for a fresh isolated tester.

## Core Idea

```text
Light:
Human -> Team-Lead -> Worker -> Self-check -> Final

Standard:
Human -> Team-Lead -> Planner -> Worker -> Reviewer -> Final

Heavy:
Human -> Team-Lead -> Planner -> Pre-review
      -> Worker/Executor -> Post-review
      -> First-principles review if needed -> Human gate -> Final
```

Use the lightest path that is safe for the task.

## Roles

- **Team-Lead**: clarifies intent, chooses workflow depth, protects scope, coordinates handoffs.
- **Planner**: decomposes work, defines success criteria, names risks and verification.
- **Worker/Coder**: implements within scope and reports evidence.
- **Reviewer**: performs blue review and red review before important work is accepted.
- **FPR-Reviewer**: challenges the approach from first principles for high-impact work.
- **Executor**: handles repo-heavy technical execution, debugging, tests, migrations, and command workflows.

## Model Selection

Choose models by capability, budget, latency, and runtime support.

Record the actual phase-to-agent/model route from runtime evidence. Configuration or a manual UI selection alone is not proof that a phase used that model.

Suggested capability tiers:

- **Team-Lead**: fast judgment model, or high-reasoning model when discussion quality matters.
- **Planner**: strong reasoning/planning model.
- **Worker/Coder**: repo-aware coding/execution model.
- **Reviewer**: strong reasoning/review model.
- **FPR-Reviewer**: strong adversarial reasoning model.
- **Executor**: coding-specialized model with tool and terminal strength.

See `examples/` for OpenAI-heavy, OpenAI + MiniMax, and single-agent simulation mappings.

## First-Time Setup

On first use, Agent Squad should ask the user:

1. Which runtime are you using?
2. Do you have real subagent support?
3. What is your priority: reliability-first, balanced, cost-sensitive, or local-first?
4. Which model providers are available?
5. Should dev logs be written, and where?
6. Are Superpowers or similar process skills available?

Then generate or suggest a team mapping. If the runtime cannot create config automatically, provide manual role prompts.

See `SETUP.md`.

## Files

- `SKILL.md`: runtime-neutral Agent Squad workflow.
- `AGENT.md`: Team-Lead operating prompt.
- `SETUP.md`: first-run setup flow and preference questions.
- `Coding-Rules.md`: always-on quality baseline.
- `Superpowers-Map.md`: optional companion process skill map.
- `examples/`: concrete model/runtime mapping examples.

## Superpowers

Superpowers is optional. If installed, use it as a companion methodology for brainstorming, planning, debugging, TDD, review, and verification. If it is not installed, Agent Squad still works using its native handoff and review contracts.

## License

MIT
