# Superpowers Map

Superpowers is an optional companion methodology for Agent Squad.

https://github.com/obra/superpowers

Agent Squad must still work when Superpowers is not installed. If a mapped Superpowers skill is unavailable, continue with Agent Squad's native contracts:

- Risk-based routing
- Handoff contract
- Red-blue review
- Human gates
- Verification rules

Do not stop or ask the human to install Superpowers only because a mapped skill is missing.

## When To Use Superpowers

Use Superpowers when available and when it reduces risk or improves clarity.

Do not invoke extra skills when the task is Light and obvious.

## Routing Map

### Intake And Clarification

Use `brainstorming` when:

- The request is ambiguous.
- The human has an idea but not a clear scope.
- Multiple directions are possible.
- The task may be solving the wrong problem.

Fallback without Superpowers:

- Ask 1-3 short clarifying questions.
- Draft a compact scope.
- Proceed if risk is low or normal.

### Planning

Use `writing-plans` when:

- The task is Standard or Heavy.
- Work has multiple steps.
- Success criteria need structure.
- The implementation should be staged.

Fallback without Superpowers:

- Use the Agent Squad handoff contract.
- Include goal, scope, success criteria, verification, and escalation triggers.

### Debugging

Use `systematic-debugging` when:

- The failure is not immediately obvious.
- Prior attempts failed.
- Tests or logs need investigation.
- The issue may have multiple causes.

Fallback without Superpowers:

- Reproduce the issue.
- Inspect the smallest relevant surface.
- Form one hypothesis at a time.
- Change one variable at a time.
- Verify before declaring completion.

### Test-Driven Development

Use `test-driven-development` when practical for:

- Logic changes
- API behavior
- Parsers
- Data transformations
- Bug fixes with reproducible failures

Do not force TDD for:

- Typo fixes
- Small docs changes
- Mechanical config edits
- Work where no test harness exists and creating one would exceed scope

Fallback without Superpowers:

- Define expected behavior before editing.
- Add or update tests when reasonable.
- If no test is practical, state the manual verification used.

### Review

Use `requesting-code-review` when:

- Preparing work for PM-Reviewer.
- The implementation has meaningful risk.
- The review should be structured.

Use `receiving-code-review` when:

- PM-Reviewer requested changes.
- Worker needs to address review without scope creep.

Fallback without Superpowers:

- Use the PM-Reviewer output contract:

```text
Decision:
Issues:
Required fixes:
Optional improvements:
Risk:
Evidence quality:
```

### Completion Verification

Use `verification-before-completion` before final delivery when:

- Code, docs, config, automation, or operational behavior changed.
- The output will be relied on by the company.
- A prior run failed because "done" was declared too early.

Fallback without Superpowers:

- Run the relevant checks.
- Summarize exact verification.
- State skipped checks and why.

### Worktree Isolation

Use `using-git-worktrees` when:

- Multiple experiments may happen in parallel.
- A risky change should be isolated.
- The runtime supports safe worktree workflows.

Fallback without Superpowers:

- Work in the current tree only if safe.
- Check git status before editing.
- Do not overwrite unrelated user changes.

## Default Mapping By Agent Squad Path

Light:

- Usually no Superpowers needed.
- Optional: verification-before-completion if a small change still matters.

Standard:

- writing-plans
- test-driven-development when practical
- requesting-code-review
- verification-before-completion

Heavy:

- brainstorming
- writing-plans
- systematic-debugging if failure-driven
- test-driven-development when practical
- requesting-code-review
- receiving-code-review
- verification-before-completion
- using-git-worktrees when supported

## Rule

Superpowers improves the method. Agent Squad owns the workflow.
