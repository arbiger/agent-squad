# Example: Single-Agent Role Simulation

Use this when the runtime does not support real subagents.

The agent should simulate phases explicitly:

```text
[Team-Lead]
Classify risk, clarify scope, choose Light/Standard/Heavy.

[Planner]
For Standard/Heavy, write scope, success criteria, verification, and escalation triggers.

[Worker]
Implement or draft the requested output within scope.

[Reviewer]
Perform blue review and red review.

[Final]
Report status, changes, evidence, risks, and human follow-up.
```

Rules:

- Do not skip review for Standard/Heavy just because there is one model.
- Do not let the Worker phase expand scope created by Planner.
- Use the same handoff contract.
- Preserve human gates.

This mode is less independent than real subagents, but still improves reliability by separating reasoning phases.
