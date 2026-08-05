# Agent Squad Setup

Agent Squad should ask for preferences before generating or recommending a team mapping.

## Setup Questions

Ask:

```text
1. Which runtime are you using?
   Examples: opencode, Codex, Claude, OpenClaw, Hermes, Antigravity, custom.

2. Does the runtime support real subagents?
   yes / no / not sure

3. What is your priority?
   reliability-first / balanced / cost-sensitive / local-first

4. Which model providers or model classes are available?
   Examples: OpenAI, MiniMax, Claude, Gemini, local models, unknown.

5. Do you want Team-Lead discussion to use a high-reasoning model?
   yes / no / only for Standard and Heavy

6. Where should durable dev logs go?
   none / project dev-log / memory system / ask each project

7. Are companion process skills available?
   Examples: Superpowers, custom skills, none.
```

## Mapping Rules

Do not require a specific provider. Map roles by capability.

Reliability-first:

```text
Team-Lead: high-reasoning discussion model
Planner: high-reasoning model
Worker/Coder: coding-specialized model
Reviewer: high-reasoning model
FPR-Reviewer: high-reasoning model
Executor: coding/tool-specialized model
```

Balanced:

```text
Team-Lead: fast judgment model
Planner: high-reasoning model for Standard/Heavy
Worker/Coder: mid/high coding model
Reviewer: high-reasoning model
FPR-Reviewer: optional high-reasoning model
Executor: coding/tool-specialized model
```

Cost-sensitive:

```text
Team-Lead: small/medium judgment model
Planner: high-reasoning only when needed
Worker/Coder: affordable coding model
Reviewer: high-reasoning only for Standard/Heavy
FPR-Reviewer: rare
Executor: coding/tool model only when command-heavy
```

Local-first:

```text
Team-Lead: best available local reasoning model
Planner: best available local reasoning model, or remote fallback
Worker/Coder: local coding model if reliable
Reviewer: strongest available reasoning model
FPR-Reviewer: optional remote/high reasoning fallback
Executor: runtime-specific coding executor
```

## Runtime Behavior

If real subagents exist:

- create or suggest role prompts
- map each role to a model
- verify required roles before dispatch

If real subagents do not exist:

- simulate roles sequentially
- label each role phase
- still use the handoff and review contracts

If the user does not know:

- use Balanced
- simulate roles until runtime support is confirmed
- ask before generating runtime-specific config

## What To Generate

Depending on runtime, generate one or more:

- role prompt files
- config snippets
- manual setup notes
- model mapping table
- dev-log policy
- examples for Light, Standard, and Heavy tasks

## Codex

For Codex custom-agent setup and a balanced Sol/Terra/Luna mapping, see
`examples/codex-sol-terra-luna.md`.

Keep the human gate human. A Reviewer may recommend approval or escalation,
but it must not approve consequential actions on the user's behalf.
