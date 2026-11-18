---
name: agent-squad-terra
description: "Coordinate bounded implementation with one GPT-6.1 Terra Light worker and current-chat Lead acceptance."
---

# Agent Squad Terra

Use when explicitly invoked for bounded implementation. The current chat stays Lead and owns planning, scope, and acceptance. Handle discussion and review-only work directly.

Terra Light means GPT-6.1 Terra at `low` reasoning in this workflow.

1. Define observable acceptance checks. Give one worker a bounded handoff with the goal, allowed files, non-goals, checks, expected evidence, and escalation triggers. Use the registered `terra_worker` if available. Otherwise, if the current runtime exposes the model and effort, spawn a generic `worker` with explicit `model: "gpt-6.1-terra"` and `reasoning_effort: "low"`, using a bounded handoff without a full-history fork. Include the worker instructions from `agents/terra-worker.toml`. Report the observed model, effort, and whether the worker actually ran.
2. Have the same worker implement and then verify in a distinct follow-up. Return fixes to that worker. No additional or nested delegation. If Terra Light cannot launch, report the blocker and keep the handoff without substituting another model.
3. Inspect the diff and evidence against the checklist and check a plausible failure mode. Same-worker verification is not independent testing. Report skipped checks and residual risks.

Use existing authorization for consequential actions. Update the project DEV-LOG for substantial work; use HANDOFF for unfinished or transferred work.

For an explicit comparison with Luna Max, use [the comparison guide](references/compare.md).

## Resume When Delegation Is Unavailable

If neither route is available, report the exact blocker and preserve the handoff. Do not infer model access from the agent TOML. A spawn acknowledgement only confirms the request was accepted. If execution reports a capacity error, retain the handoff and report it as a capacity blocker.

If the user selects Terra Light as the main chat model and asks to resume, use the existing HANDOFF and DEV-LOG, inspect partial work, and implement and verify directly within the approved scope. Use visible model and effort metadata when available; otherwise label the selection as user-reported. Report this as direct execution and self-verification. Keep it separate from subagent comparison results.
