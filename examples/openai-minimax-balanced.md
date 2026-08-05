# Example: OpenAI + MiniMax Balanced Mapping

This is an example, not a requirement.

Use when you want strong review/planning while keeping routine coordination and coding cost lower.

```text
Team-Lead / Discussion: MiniMax-M3 or GPT-5.4-mini
Planner: GPT-5.5
Worker/Coder: MiniMax-M2.7, MiniMax-M3, or GPT-5.3-Codex
Reviewer: GPT-5.5
FPR-Reviewer: GPT-5.5
Executor: GPT-5.3-Codex
```

Routing:

```text
Light:
MiniMax/GPT-5.4-mini Team-Lead -> MiniMax Worker -> self-check

Standard:
Team-Lead -> GPT-5.5 Planner -> MiniMax or GPT-5.3-Codex Worker -> GPT-5.5 Reviewer

Heavy:
Team-Lead -> GPT-5.5 Planner -> GPT-5.5 pre-review
          -> GPT-5.3-Codex Executor -> GPT-5.5 post-review
          -> GPT-5.5 FPR-Reviewer if needed
```

Use GPT-5.5 for Team-Lead discussion when scope is ambiguous, strategic, or expensive to get wrong.
