---
name: agent-squad
description: Use for reliable multi-step Codex work with a current-chat Human-Facing Lead, one bounded Luna Max implementation and verification worker, evidence-based technical acceptance, and existing human authorization.
---

# Agent Squad for Codex

Use this skill when a multi-step Codex task needs bounded execution, review, evidence, and a clean handoff. Keep routine discussion and review in the current chat; delegate only bounded implementation work.

## Operating Model

The current chat is the Human-Facing Lead. The Lead:

- understands the user's intent and context
- frames the goal, scope, non-goals, success criteria, and verification
- plans and coordinates the work
- performs blue review and red review
- owns technical acceptance and reporting

The Lead is not defined by a particular model. Use the actual visible current-chat model and reasoning metadata when available. A UI model switch changes subsequent Lead turns; this skill cannot lock or automatically revert it. If metadata is unavailable, record the identity as user-reported or unverified. Sol Medium/High and Astra Low are examples of possible Lead settings, not a claim that those models are equal.

Before tool-heavy work, declare the route in commentary:

```text
Lead (actual visible identity) -> Luna Max: Build -> same Luna Max: Verify -> Lead: Blue/Red Review and Technical Acceptance
```

State any omitted phases or deviations honestly. This route does not claim model equality or grant missing authorization.

## When To Delegate

The Lead handles discussion, planning, copy review, technical review, and review-only tasks directly without spawning.

When implementation, artifact production, coding, copywriting, testing, or debugging is needed:

- use exactly one `luna_worker`
- use Luna Max for the implementation and the later verification follow-up
- do not add planner or reviewer agents, parallel workers, or nested delegation
- return fixes to the same worker
- if Luna is unavailable, report the actual blocker, retain any partial work and handoff, and do not silently substitute another model or worker

## Worker Lifecycle

1. The Lead sends one complete, bounded handoff to `luna_worker`.
2. Luna reads before writing and executes only the assigned coding, copywriting, testing, or debugging work.
3. After implementation, the Lead sends a distinct verification follow-up to the same Luna worker with the acceptance checklist.
4. Any fixes return to that same worker; do not replace it with another agent.
5. The Lead reads the resulting diff or artifacts, reviews the evidence, performs targeted risk checks, and owns technical acceptance.

The same-worker verification pass is useful but is not independent testing. Do not describe it as independent review or testing.

## Handoff Contract

Every non-trivial worker handoff should state:

```text
Goal:
Background:
Allowed files or artifacts:
Non-goals:
Required changes:
Success criteria:
Verification commands or checks:
Forbidden actions:
Evidence required:
Escalation triggers:
```

The worker stays within the allowed artifacts and within coding, copywriting, testing, or debugging. It must not expand scope, delegate, or make architecture, cross-module, security, credential, permission, data-migration, deployment, compliance, regulatory, or business decisions. If the boundary is ambiguous or a forbidden decision is reached, stop and report the blocker while retaining partial work and evidence.

## Review And Acceptance

The Lead reviews the worker's actual output and evidence.

Blue review checks:

- the result satisfies the stated goal and success criteria
- changed files or artifacts remain within scope and project conventions
- verification commands actually ran and their evidence matches the report
- required records, handoffs, and skipped checks are disclosed

Red review challenges:

- assumptions, realistic failure paths, and untested boundaries
- regressions, leftovers, unsafe authority, data loss, security exposure, or irreversible behavior
- whether the work solved the stated problem rather than only passing a narrow check

The Lead may run targeted risk checks. The Lead does not duplicate the worker's full test suite, build, packaging, benchmark, or GUI pass by default. If evidence conflicts, return a bounded fix to the same worker or report the mismatch.

Technical acceptance belongs to the Lead. It does not grant production approval, publish permission, or other missing authorization. The user uses the outputs and provides operational feedback; the user is not expected to inspect code to perform the technical acceptance step.

## Authorization And Human Gates

Use existing explicit user authorization for consequential actions. Do not ask the user to re-authorize an action they already authorized, and do not halt ordinary reversible work merely because it is reversible work.

Stop and ask or report when a new gate is reached, including:

- destructive or difficult-to-reverse actions
- production deployment, publishing, external communication, or spending money
- credential, permission, privacy, security, legal, or compliance changes
- schema or data migrations with operational impact
- architecture or cross-system changes outside the agreed scope
- ambiguous business decisions or material scope, cost, or risk expansion

Do not turn technical acceptance into automatic production approval.

## Project Records

For substantial implementation or durable decisions, create or update the project's existing development log (often `DEV-LOG.md`), respecting its established name and location. Append concise history with the date, goal, decisions, changed files or artifacts, evidence, risks, and next step.

Create or update a `HANDOFF` only when work is unfinished, blocked, paused, or moving to another operator or task. Include current state, next action, files, verification, and unresolved gates. Update an existing handoff instead of creating a duplicate, and update a stale handoff when completing its pending work. Do not blindly create both a handoff and a development log when one existing source is sufficient. Never put secrets in either record.

## Optional Superpowers

Use an installed Superpowers skill when it is relevant and reduces risk or improves clarity. Superpowers is optional and must not add agents, change the one-worker route, or become a prerequisite for ordinary work.

## Evidence And Reporting

Do not claim completion without evidence or an explicit explanation of what could not be verified. Evidence may include tests, builds, lint or typecheck output, exact command summaries, file readback, diffs, runtime or browser probes, screenshots, hashes, or structured artifact validation as appropriate.

Keep the final report concise and include:

```text
Lead identity: visible model/reasoning metadata, or user-reported/unverified
Status: done | blocked | partial | needs human decision
Changed: files or artifacts
Verified: commands, checks, and observed results
Verification type: same-worker follow-up, not independent testing
Risks or skipped checks:
Next step or human follow-up:
```

State which production conditions remain unverified. Do not call work production-ready solely because local checks passed.
