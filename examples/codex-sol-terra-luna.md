# Codex Sol/Terra/Luna Example

This is a balanced Codex example, not a model requirement.

## Role Mapping

```text
Team-Lead / main session: current user-selected model
Planner: GPT-5.6 Sol, high reasoning, read-only
Worker / Coder: GPT-5.6 Terra, medium reasoning
Reviewer / Red-Team: GPT-5.6 Sol, high reasoning, read-only
Executor: GPT-5.6 Luna, low reasoning
Human gate: the user
```

Sol handles ambiguous planning and review. Terra handles normal implementation.
Luna handles narrow, repeatable, high-volume work with a clear definition of
done. A separate Luna evidence pass remains worker verification, not independent
testing, unless it uses a fresh isolated context.

## Lean Routing

### Light

Use one Terra Worker, or one Luna Executor for purely mechanical work. Require
a self-check, but do not create a full squad.

### Standard

```text
Team-Lead -> Sol Planner -> Terra Worker -> Sol Reviewer -> Team-Lead acceptance
```

The Team-Lead may omit the separate Planner when scope and verification are
already explicit.

### Heavy

```text
Team-Lead -> Sol Planner -> Sol pre-review
          -> Terra Worker -> Luna evidence task if useful
          -> Sol post-review
          -> human gate when triggered
```

Do not use Heavy by default. Multi-agent work usually uses more raw tokens than
a comparable single-agent run, so delegation should earn its cost through
independence, cleaner context, parallelism, or reduced rework.

## Codex Files

Personal custom agents live in `~/.codex/agents/`:

```text
planner.toml
worker.toml
reviewer.toml
executor.toml
```

Each file defines `name`, `description`, `developer_instructions`, `model`, and
`model_reasoning_effort`. Planner and Reviewer should be read-only.

Keep delegation shallow and bounded in `~/.codex/config.toml`:

```toml
[agents]
max_threads = 3
max_depth = 1
```

The main session remains the human-facing Team-Lead. Model selection in the
composer still controls that main session; the custom agents control spawned
role models.
