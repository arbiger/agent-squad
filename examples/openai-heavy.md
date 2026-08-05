# Example: OpenAI-Heavy Reliability Mapping

This is an example, not a requirement.

Use when reliability and fast convergence matter more than lowest model cost.

```text
Team-Lead / Discussion: GPT-5.5
Planner: GPT-5.5
Worker/Coder: GPT-5.3-Codex
Reviewer: GPT-5.5
FPR-Reviewer: GPT-5.5
Executor: GPT-5.3-Codex
```

Routing:

```text
Light:
GPT-5.5 Team-Lead -> GPT-5.3-Codex Worker -> self-check

Standard:
GPT-5.5 Team-Lead -> GPT-5.5 Planner -> GPT-5.3-Codex Worker -> GPT-5.5 Reviewer

Heavy:
GPT-5.5 Team-Lead -> GPT-5.5 Planner -> GPT-5.5 pre-review
                 -> GPT-5.3-Codex Executor -> GPT-5.5 post-review
                 -> GPT-5.5 FPR-Reviewer if needed
```

Prompt guard for Team-Lead:

```text
Use high reasoning, but stay lean. Ask only necessary questions. Converge scope quickly. Do not over-explore routine tasks.
```
