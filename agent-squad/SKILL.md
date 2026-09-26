---
name: agent-squad
description: "Coordinate bounded project work with one Luna Max worker and Lead-owned acceptance."
---

# Agent Squad for Codex

Use this skill when a multi-step Codex task needs bounded execution, review, evidence, and a clean handoff. Keep routine discussion and review in the current chat; delegate only bounded implementation work.

## Operating Model

The current chat is the Human-Facing Lead. The Lead:

- understands the user's intent and context
- frames the goal, scope, non-goals, success criteria, and verification
- plans and coordinates the work with an observable acceptance checklist
- owns technical acceptance and reporting

The Lead can use any model selected by the user or runtime. Do not lock or automatically change that selection. Record actual model and reasoning metadata when available; otherwise mark it unverified.

Before delegation, write a short checklist of observable outcomes and checks, tailored to the task, and include it in the handoff:

```text
Acceptance checklist:
- [ ] Requested behavior or artifact is present: <observable result>
- [ ] Scope and non-goals hold: <expected boundary>
- [ ] Verification evidence is available: <specific check or readback>
```

Before tool-heavy work, declare the route in commentary:

```text
Current-chat Lead (user-selected model) -> one Luna Max worker: Build -> same worker: Verify -> Lead: Integrated Technical Acceptance
```

State any omitted phases or deviations honestly. This route does not claim model equality or grant missing authorization.

## When To Delegate

The Lead handles trivial tasks, discussion, planning, copy review, technical review, and review-only tasks directly without spawning.

When implementation, artifact production, coding, copywriting, testing, or debugging merits delegation:

- use exactly one `luna_worker`
- use Luna Max for the implementation and the later verification follow-up
- do not add a planner, second implementation worker, parallel workers, or nested delegation
- return fixes to the same worker
- if Luna is unavailable, report the actual blocker, retain any partial work and handoff, and do not silently substitute another model or worker
- for higher-risk work, add a separate review or human gate only when warranted; the implementation worker remains the same single Luna worker

## Worker Lifecycle

1. The Lead sends one complete, bounded handoff to `luna_worker`.
2. Luna reads before writing and executes only the assigned coding, copywriting, testing, or debugging work.
3. After implementation, the Lead sends a distinct verification follow-up to the same Luna worker with the acceptance checklist.
4. Any fixes return to that same worker; do not replace it with another agent.
5. The Lead reads the resulting diff or artifacts, checks the acceptance checklist and evidence, and owns one integrated technical acceptance.

The same-worker verification pass is useful but is not independent testing. Do not describe it as independent review or testing.

## Handoff Contract

Every non-trivial worker handoff should state:

```text
Goal:
Background:
Allowed files or artifacts:
Non-goals:
Required changes:
Acceptance checklist:
Verification commands or checks:
Forbidden actions:
Evidence required:
Escalation triggers:
```

The worker stays within the allowed artifacts and within coding, copywriting, testing, or debugging. It must not expand scope, delegate, or make architecture, cross-module, security, credential, permission, data-migration, deployment, compliance, regulatory, or business decisions. If the boundary is ambiguous or a forbidden decision is reached, stop and report the blocker while retaining partial work and evidence.

## Integrated Technical Acceptance

After the worker returns, the Lead performs one acceptance pass against the checklist and actual output:

- confirm the requested result, scope, conventions, and verification evidence
- briefly challenge a plausible failure mode or untested boundary; run a targeted check or state what remains unverified
- disclose residual risks, skipped checks, and any required records or handoff

This is one integrated acceptance, not mandatory separate blue and red phases. The Lead may run targeted risk checks, but does not duplicate the worker's full test suite, build, packaging, benchmark, or GUI pass by default. If evidence conflicts, return a bounded fix to the same worker or report the mismatch.

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
Acceptance: checklist results and concise failure-mode challenge
Changed: files or artifacts
Verified: commands, checks, and observed results
Verification type: same-worker follow-up, not independent testing
Risks or skipped checks:
Next step or human follow-up:
```

State which production conditions remain unverified. Do not call work production-ready solely because local checks passed.
