---
name: agent-squad
description: "Use when opencode operates without Hermes/OpenClaw, or when the user says `agent-squad` / `mode-b` / `opencode-only` / `team-lead coding workflow`, or when a multi-step task benefits from separating planning, implementation, and review across named roles. Triggers on complex multi-step work, on token-efficient routing that keeps GPT-5.5 selective, or on tasks where one-shot execution has caused drift or hidden assumptions."
---

# Agent Squad: Five-Role Architecture

## Purpose

When the user activates agent-squad (via trigger terms), opencode operates as a standalone team system without Hermes/OpenClaw orchestration.

**Five custom agents + 3 opencode built-ins**: Team-Lead (MiniMax-M3) → Planner (GPT-5.5) → **PM-Reviewer pre-impl** (GPT-5.5, red-team the plan) → Coder (MiniMax-M2.7) → **PM-Reviewer post-impl** (GPT-5.5, blue+red) → [fpr-reviewer] (optional, substantial work) + Codex-Executor (GPT-5.3-Codex, special tasks). PM-Reviewer is invoked twice; fpr-reviewer is the optional second-stage auditor.

---

## Loop Engineering Anchoring

> **#george — decision/rationale**: Chose to anchor agent-squad in the loop engineering frame (Addy Osmani, 2026) because the existing 5-role architecture is already element #6 (sub-agents). Anchoring makes the implicit explicit: this skill is a piece of a 6-element loop, not a standalone framework. Loop eng #1 (automation) and #5 (connectors) are explicitly *deferred* here because the shell scaffold + opencode MCP layer already cover them at the platform level — the skill shouldn't duplicate platform concerns. The "+1 verification gate" is the entire reason PM-Reviewer × 2 + 12 rules + 3-challenge limit exist; this section makes that lineage visible to anyone reading the skill.

AI Loop Engineering (Addy Osmani, 2026) defines 6 elements + 1 verification gate. agent-squad is the productionized sub-agent pattern (element #6). This skill also integrates the other 5 elements to varying degrees: #2 worktree via superpowers, #3 memory via AC preflight (Step 0), #4 skills (the skill itself), #5 connectors via MCP. The +1 verification gate is operationalized as PM-Reviewer × 2 + 12 rules + 3-challenge limit + the 7 HIL triggers defined here.

| Loop Eng # | Element | agent-squad integration |
|---|---|---|
| 1 | Automation | Deferred (shell scaffold handles) |
| 2 | Worktree isolation | Explicit via superpowers `using-git-worktrees` |
| 3 | Memory | AC preflight — Step 0 (new) |
| 4 | Skills / KB | The skill itself |
| 5 | Connectors | MCP in opencode.json — made explicit via Tool Capability Registry |
| 6 | Sub-agents | 5-role architecture (unchanged) |
| +1 | Human verification | PM-Reviewer × 2 + 12 rules + 3-challenge limit + 7 HIL triggers |

---

## Core Flow

```
Human ↔ Team-Lead (MiniMax-M3)
            │ clarifies needs, reports status
            ↓
         Planner (GPT-5.5)
            │ creates plan, defines success criteria
            ↓
         PM-Reviewer (GPT-5.5) ← PRE-IMPL INVOCATION
            │ red-team the plan (validate intent, scope, flag gaps)
            ↓
          Coder (MiniMax-M2.7)
            │ implements, self-tests
            ↓
         PM-Reviewer (GPT-5.5) ← POST-IMPL INVOCATION (same agent, different focus)
            │ review (blue: correctness/quality + red: adversarial/security)
            ↓
      [ccl-red-team / fpr-reviewer] ← OPTIONAL: substantial work only (first-principles challenge)
            ↓
      Codex-Executor (GPT-5.3-Codex) ← special tasks only
```

**3 challenge limit → human escalation**
- Coder has max 3 attempts to pass PM-Reviewer on same issue
- After 3rd rejection, escalate to human for decision

---

## Coding Baseline — 12 Rules

All roles follow the Andrej Karpathy-inspired baseline:

1. **Think Before Coding** — state assumptions, ask rather than guess, stop when confused
2. **Simplicity First** — minimum code, no speculative features, no single-use abstractions
3. **Surgical Changes** — touch only what you must, don't refactor what isn't broken
4. **Goal-Driven Execution** — define success criteria, iterate until verified
5. **Model for Judgment** — use for classification, drafting, summarization; NOT routing or deterministic transforms
6. **Token Budgets** — per-task 4k tokens, per-session 30k tokens, surface breaches
7. **Surface Conflicts** — pick one pattern, explain why, flag the other; don't average them
8. **Read Before Write** — read exports, callers, shared utilities first
9. **Tests Verify Intent** — encode WHY, not just WHAT
10. **Checkpoint After Steps** — summarize done/verified/left after each significant step
11. **Match Conventions** — conformance > taste; surface disagreements don't fork silently
12. **Fail Loud** — "completed" is wrong if anything skipped, surface uncertainty, don't hide it

---

## Role-Specific Emphasis

| Role | Emphasis |
|------|----------|
| **Team-Lead** | Rules 1, 3, 4, 10, 12 — catch wrong direction, goal-setting, checkpoint before delegating |
| **Planner** | Rules 1, 3, 7, 9, 11, 12 — decompose task, define success criteria, surface conflicts |
| **PM-Reviewer** | Rules 1, 3, 7, 9, 11, 12 — validate intent, surface conflicts, verify test intent, fail loud on gaps |
| **Coder** | Rules 2, 3, 4, 8, 9, 10 — simplicity, surgical changes, read before write, verify tests, checkpoint |
| **Codex-Executor** | Rules 1, 3, 4, 6, 8, 12 — understand before diving, surgical execution, token discipline, verify |
| **fpr-reviewer** | Rules 1, 5, 10 — ask rather than guess, model for judgment only, checkpoint summaries |

---

## When to Use Each

- **Team-Lead** (MiniMax-M3): Coordinates all. Does NOT code or plan. Human-facing communication.
- **Planner** (GPT-5.5): Task decomposition, success criteria, plan writing. Use after Team-Lead clarifies needs.
- **Coder** (MiniMax-M3): Standard implementation tasks — edits, bash, glob, grep, read. Use for routine coding, file changes, running tests.
- **PM-Reviewer** (GPT-5.5): Review with blue (correctness/quality) + red (adversarial/security) scope. Use after Coder completes. Hard gate on every implementation.
- **ccl-red-team / fpr-reviewer** (optional, substantial work only): First-Principles Review from a different angle — challenges the *approach*, not just the *output*. Layer on top of PM-Reviewer for architecture decisions, multi-file refactors, security-sensitive work, or business proposals. See *Two-Stage Review* below.
- **Codex-Executor** (GPT-5.3-Codex): Complex execution, debugging, technical deep-dives. Use when task involves intricate bugs, performance issues, or multi-step execution chains beyond routine implementation.

---

## Operating Rules

### Team-Lead Rules

1. **Step 0 first, then clarify** — identify the project (minimal pass), query AC for conventions / active work / pitfalls / prior decisions, THEN clarify demands with the human using AC-informed questions. If project is ambiguous, ask one human clarification first, then return to Step 0. See §Step 0 — Memory Preflight.
2. **Summarize and report** — keep human informed of status
3. **Catch wrong direction** — if direction is wrong, STOP and correct before proceeding
4. **Delegate** — delegate planning to Planner, implementation to Coder, review to PM-Reviewer
5. **Do NOT code or make detailed plans**
6. **Escalate** — deadlocks and 3-challenge-limit reached → human involvement
7. **Step 0 (Memory Preflight)** — before delegating, query AC for project conventions, active work, pitfalls, and prior decisions. See §Step 0 — Memory Preflight.

*Superpowers: invoke `brainstorming` skill when clarifying demands.*

### Planner Rules

1. **Decompose task** — break down into clear, actionable steps
2. **Define success criteria** — measurable outcomes, not vague goals
3. **Identify conflicts** — surface competing priorities or patterns, pick one with reason
4. **Write plan** — output to `<project>/plans/` with clear steps
5. **No execution** — planning only, do not code or run commands
6. **Escalate** — if task is unclear, flag to Team-Lead before proceeding

*Superpowers: invoke `brainstorming` for ideation → `writing-plans` for structure.*

### PM-Reviewer Rules

PM-Reviewer is invoked **twice per workflow** with the same model/persona but different focus:

**Pre-impl invocation (after Planner, before Coder):**
1. **Validate plan intent** — does the plan match what the human actually asked for?
2. **Check scope & success criteria** — is the plan tight? Are success criteria measurable?
3. **Flag gaps & contradictions** — what's missing from the plan? What conflicts exist?
4. **Classify task** — `TDD-required` or `TDD-skippable` based on the closed list in §Superpowers Integration.
5. **No execution** — review only, do not code or run commands

**Post-impl invocation (after Coder, before delivery):**
6. **Blue review** — correctness, quality, efficiency. Does code do what plan says? Is it clean/SOLID?
7. **Red review** — adversarial attack. What breaks? Edge cases, security, failure modes.
8. **Verify test intent** — tests verify WHY, not just WHAT
9. **Fail loud** — surface uncertainty, don't hide skipped checks

**Both invocations:** max 3 rejections on same issue → human escalation.

*Superpowers (pre-impl): invoke `requesting-code-review` for plan-as-code lens. (post-impl): invoke `requesting-code-review` + `receiving-code-review` mindset for Coder's fixes.*

### Two-Stage Review: PM-Reviewer + ccl-red-team

PM-Reviewer and ccl-red-team are **related but distinct** review angles. Layer them for substantial work.

| Stage | Reviewer | Question | Mindset |
|-------|----------|----------|---------|
| Pre-implementation | PM-Reviewer | Does the plan match user intent? Conventions? Test intent? | Spec compliance / gatekeeper |
| Pre-delivery (substantial only) | ccl-red-team (fpr-reviewer) | Is the whole approach sound from first principles? What are we missing? Creative leaps? | Devil's advocate / challenger |

**Invoke ccl-red-team (in addition to PM-Reviewer) when work is:**
- Architecture decisions or system design
- New features / refactors touching multiple files
- Security-sensitive code (auth, payments, data handling)
- Business proposals, strategy docs, market analysis

**Skip ccl-red-team when:**
- Trivial edits, single-file changes, well-understood patterns
- User says `/no-review`
- Work is purely informational

**How to invoke:**
- Trigger: `@fpr-reviewer [task description]` or via the `fpr-reviewer` agent
- Reference: `~/.config/opencode/skills/ccl-red-team/SKILL.md`

**Rationale:** Mirrors the "audit subagent" lesson from the charge/amplify design — a second-chance challenge to catch the failure mode where the main agent declares "done" before the work actually matches intent. PM-Reviewer validates; ccl-red-team challenges. Both are needed for substantial deliverables; either alone is insufficient.

*Superpowers: invoke `ccl-red-team` skill (already integrated).*

### Codex-Executor Rules

1. **Handle complex execution** — debugging, performance issues, technical deep-dives
2. **Execute changes** — edit/bash allowed, no task dispatch
3. **Report results** — clear status to Team-Lead
4. **Not for routine tasks** — use Coder for simple edits

*Superpowers: invoke `systematic-debugging` + `verification-before-completion`.*

### Coder Rules

1. **Follow plan** — exactly what assigned, no extra features
2. **Implement** — code, bug fix, test
3. **Self-test** — run lint/typecheck/tests before reporting completion
4. **Context pruning** — on 2nd+ attempt, summarize previous failures rather than dumping full history
5. **No refactoring beyond what's needed**
6. **Challenge limit** — if 3rd rejection on same issue, flag deadlock to Team-Lead

*Superpowers: invoke `using-git-worktrees` → `test-driven-development` (if TDD-required) → `systematic-debugging` (if bug) → `verification-before-completion` (before declaring done).*

---

## HIL Triggers & Async-Human Behavior

> **#george — decision/rationale**: The original loop engineering article framed the human as "involved at the beginning" (setup), but the actual operating model needs an *ongoing* human — at scope clarification, plan review, accept/reject, and escalation. So I separated *default* (boundaries only, low interruption) from *triggers* (7 structured MUST-escalate conditions). The 7 are deliberately a decision tree, not a flat list: PM-Reviewer checks in order and the first match wins. Original 6 triggers were reorganized into 7 by splitting "high-stakes" into state change + cost/risk per PM-Reviewer A1 fix — that dedup caught real overlap between (1) external action, (6c) state change, and (6d) public-facing output. Async-human behavior is the part the article never covered: what happens when HIL fires but I'm asleep? STOP/CONTINUE/RECORD with the "ambiguous reply" guard added after run #1 review.

### Human-in-the-Loop Default

**Default = boundaries**: Team-Lead clarifies at start, reports status throughout, accepts at end. PM-Reviewer is the mid-loop gate, not human.

### 7 Structured MUST Triggers

PM-Reviewer **MUST** escalate to Team-Lead for human input when any of the following fires. Structured, not heuristic. PM-Reviewer pre-impl evaluates the plan; PM-Reviewer post-impl evaluates the work.

**Decision tree (check in order; first match wins):**

```
1. EXTERNAL/PUBLIC ACTION — email, git push, deploy, publish, social post, cron/job creation
2. HIGH-CONSEQUENCE STATE CHANGE — DB/schema migration, deletion, irreversible fs, credential change
3. SCOPE EXPANSION — touches outside clarified task boundary
4. RULE CONFLICT — project doc / AC / skill / user instruction contradiction
5. AMBIGUOUS BUSINESS DECISION — pricing, naming, public wording, who-to-contact
6. REVIEW DEADLOCK — 3rd rejection on same issue
7. COST/RISK THRESHOLD — >$1 token spend OR regulated/medical/financial/PII project
```

**High-stakes definition** = ANY of:
- (a) Token spend > $1 in single workflow
- (b) Project risk profile match: code in `precaster-ISO/`, `agent-cortex/`, or any tagged regulated/medical/financial/PII
- (c) State change of consequence: DB migration, schema change, deletion, `rm -rf`
- (d) Public-facing output: git push, email, deploy, publish, social post

### Async-Human Behavior

If HIL escalation fires and human is unavailable, the framework **MUST**:
- **STOP** before the gated action.
- **CONTINUE** only with safe, reversible, draft-only work that does not pre-decide the human's choice.
- **RECORD** blocked status + exact approval needed.

**Examples:**
- Draft an email → allowed. Send → blocked.
- Prepare migration plan → allowed. Run migration → blocked.
- Generate social post → allowed. Publish → blocked.
- Stage local diff → allowed. Push → blocked.

**Ambiguous human replies do NOT authorize gated actions.** Approval must name or clearly reference the specific gated action. One-word replies such as "sure", "ok", "go ahead", "fine", "do it" are treated as ambiguous and require follow-up confirmation naming the exact action.

---

## Permission / Authority Model

> **#george — decision/rationale**: This section was added because HIL triggers imply authority but don't define it. Without it, "may not do" claims were unenforceable — agents could rationalize "I thought I could do that". The hard rule at the top is deliberately absolute: no agent crosses another agent's boundary without explicit human approval. Note this *duplicates* the opencode.json `permission` blocks at a different layer — opencode.json is what the runtime enforces, this table is what the agent *understands* it's allowed to do. They should stay in sync; if they drift, opencode.json wins at runtime but the agent will keep making requests that get denied, which wastes rounds. Rule of thumb: anything that crosses George's machine = HIL.

**Hard rule**: No agent may perform an action listed in another agent's "May NOT do" column without explicit human approval.

| Authority | May do without asking | May NOT do |
|---|---|---|
| **Human (George)** | Anything | — |
| **Team-Lead** | Read all skills/AC, write to AC, delegate to agents, run framework, choose trivial/non-trivial, escalate to human | Direct file edits to skills, irreversible ops, send external messages, modify Hermes config |
| **Planner** | Read project files/AC, write plan, query AC, request clarification | Code execution, file edits, external actions |
| **PM-Reviewer (both)** | Read all, write review, classify task (TDD-required/skippable), reject work, escalate to Team-Lead | Code edits, external actions, modify skills, override HIL |
| **Coder** | Read project files/AC, edit assigned files, run self-tests, write to TaskPad | Touch out-of-scope files, external actions, modify skills, expand scope |
| **fpr-reviewer** | Read all, write first-principles review | Code edits, external actions |
| **Codex-Executor** | Read all, edit files, run tests, debug | Touch out-of-scope files, external actions, modify skills |

---

## Tool Capability Registry

> **#george — decision/rationale**: "Connectors via MCP" was the loop eng #5 integration but it was conceptual until this table existed. Without it, agents didn't know which tools require HIL escalation. The table is intentionally redundant with Permission/Authority above — it answers the *tool-shaped* question ("can I push?") rather than the *role-shaped* question ("what can Coder do?"). Cross-machine actions = HIL was the rule of thumb I applied: anything where the action leaves this machine and can't be trivially undone by re-running. This is also the layer where opencode MCP servers (agent-cortex, google-ai-search) get their boundaries — read vs write, scope of authority.

| Tool / MCP | Capability | Authority required |
|---|---|---|
| `agent-cortex_memory_*` | Read/write memory vault, no external state | Team-Lead, Planner, Coder (read); Team-Lead (write durable) |
| File tools (read/edit/write) | Local file edits | Coder (in-scope), Team-Lead (in-scope), Codex (in-scope) |
| Bash | Local execution | Coder, Codex (with self-test discipline) |
| `gh` CLI | GitHub ops (issues, PRs, reads) | Team-Lead (reads), Human (pushes/merges) |
| git push | Remote write | **Human (HIL trigger 1)** |
| Email send (any path) | External message | **Human (HIL trigger 1)** |
| Deploy | Production change | **Human (HIL trigger 1)** |
| Publish / social post | Public-facing | **Human (HIL trigger 1)** |
| cron / launchd | Scheduled job | **Human (HIL trigger 1)** |
| DB migration / schema change | Production data | **Human (HIL trigger 2)** |
| Web/API tools (read) | External fetch | All agents |
| Web/API tools (write) | External mutation | **Human (HIL trigger 1)** |

**Rule of thumb**: "Anything that crosses the boundary of George's machine = HIL."

---

## Handoff Contract

> **#george — decision/rationale**: The 13-field handoff was the operational discipline piece the skill was missing. Original PLAN had 12; PM-Reviewer A6 caught the off-by-one (I had been counting "Background" as part of "Goal"). The dynamic-per-task Forbidden actions was the most important PM-Reviewer fix (A5): if the field is auto-populated from HIL triggers for every task, it becomes boilerplate agents ignore. Making it task-specific forces Planner/Team-Lead to actually think about what could go wrong. The trivial/non-trivial split with PM-Reviewer override was the escape valve — we don't want to fill out 13 fields for a typo fix. The "no extra features" reading of the contract is a forcing function for scope discipline.

### Mandatory Scope

- **Full 13 fields** for non-trivial tasks (touches >1 file OR >15 min OR has scope ambiguity).
- **Short version** (Role, Goal, Scope, Forbidden, Evidence) for trivial tasks (config, typo, doc, 1-line fix).
- PM-Reviewer MAY reject the "trivial" classification if the task involves logic, external action, regulated project, cross-file edits, or unclear scope.

### 13 Fields

1. **Role** — Who receives this handoff
2. **Goal** — What this handoff is trying to achieve
3. **Background** — Prior context, decisions, constraints
4. **Scope** — What is included (and explicitly excluded)
5. **Non-goals** — What this handoff is NOT attempting
6. **Inputs** — What the agent receives as starting point
7. **Files likely involved** — Paths the agent will touch
8. **Allowed tools** — What the agent may use
9. **Forbidden actions** — Derived dynamically from HIL trigger set (see below)
10. **Expected output** — What the agent must deliver
11. **Self-test commands** — How the agent verifies own work
12. **Evidence required** — What the agent must report as proof of completion
13. **Escalation triggers** — When to stop and ask for guidance

### Forbidden Actions — Dynamic Per Task

Team-Lead/Planner **MUST** derive task-specific Forbidden actions from the HIL trigger set. If no HIL-derived forbidden action applies, write: `"Forbidden: no external/public/irreversible action; remain draft-only unless human approves."`

**Examples:**
- Doc edit: `"Forbidden: publish, email, git push, modify non-skill files unless explicitly approved."`
- Migration: `"Forbidden: run migration, delete data, alter schema, touch production DB without human approval."`
- Marketing copy: `"Forbidden: publish/social post/email client; draft-only unless approved."`

---

## Step 0 — Memory Preflight

> **#george — decision/rationale**: Step 0 closes loop eng #3 (memory) — the missing piece in the original 5-role architecture. It was decided 2026-06-11 ("wire memory into agent-squad preflight") but never actually written. The order (project ID → AC query → human clarify) was the friction: PM-Reviewer A3 caught the conflict with the old Team-Lead Rule #1 ("clarify before escalate"). Resolved by making Rule #1 explicitly Step-0-first, then clarify, with the escape hatch that ambiguous project → ask one human clarification first, then return to Step 0. The stale-memory handling (A4) is the part I'm most uncertain about long-term — 30-day rule is a guess; may need tuning after we see real staleness patterns in AC. Source priority (user instruction > project files > skill > AC memory) is the real safety net, not the timestamp.

Team-Lead runs this before delegating to Planner. Step 0 is NOT a replacement for human clarification — it is a memory layer that makes the clarification more informed.

### Step 0 Order

1. **Minimal project identification pass** — identify the project from folder name / context clues.
2. **If project ambiguous** → ask one human clarification first, then return to Step 0.
3. **Query AC** for project conventions, active work, pitfalls, prior decisions.
4. **Then** clarify demands with human, using AC-informed questions.
5. **AC does not replace human clarification** — it's a memory layer, not a substitute.

### Query Shape

- Tool: `agent-cortex_memory_query` (MCP, `query`, `mode: hybrid`, `limit: 5`)
- Query terms: `"{project} conventions active work pitfalls prior decisions"`
- Cite `memory_id` in handoff to Planner

### Writeback

- After durable decisions (framework choice, new rule, naming convention, scope decision):
  - `agent-cortex_memory_write` with `topic_key: "{project}-decision"`
- After incidents (see §Incident Learning Loop): `topic_key: "{project}-incident"`
- After pitfalls discovered: `topic_key: "{project}-pitfall"`

### Stale/Wrong Memory Handling

**Source priority**: direct user instruction > current project files/docs > skill rules > AC memory.

- If AC conflicts with current repo state, prefer current state; surface the conflict in the report.
- Memories older than 30 days for active projects require confirmation before being used as basis for action.

---

## Incident Learning Loop

> **#george — decision/rationale**: The incident loop is the piece that turns mistakes into skill patches rather than just memories. Original 8 incident types were expanded to 13 after PM-Reviewer post-impl review (the missing types were secret leak, hallucination treated as fact, out-of-scope file overwrite, permission violation even without damage, and post-completion evidence failure). The closed list is deliberate — open-ended "what counts as an incident" leads to rationalization ("this wasn't really an incident"). The writeback format (incident / root_cause / prevention_rule / evidence / timestamp) is a forcing function for actual learning: if you can't write a prevention rule, you didn't really understand what went wrong. Topic key `{project}-incident` keeps it queryable in AC and out of decision memory. This is the loop eng "+1" gate applied to learning, not just verification.

### What Counts as an Incident (Closed List)

1. HIL trigger missed (work proceeded when it shouldn't have)
2. Wrong project memory used (stale/incorrect AC fact)
3. PM-Reviewer 3rd rejection on same issue (deadlock)
4. Failed deploy / push / publish / external action
5. Data loss or near-miss (accidental deletion, schema corruption)
6. User correction of factual / project memory
7. Scope creep caught late (after substantial work)
8. Agent made a hidden assumption that was wrong
9. Secret or API key leak (committed, logged, or sent externally)
10. Model hallucination treated as fact in code, doc, memory, or report
11. File overwrite / modification of unrelated content (out-of-scope edits)
12. Permission boundary violation, even if no damage occurred
13. Post-completion evidence requirement failure (a required evidence check was skipped, faked, or discovered missing after "done")

### Writeback Format (Mandatory, Every Incident)

```
topic_key: {project}-incident
content:
  - incident: {1-sentence description of what happened}
  - root_cause: {1-2 sentences of WHY it happened}
  - prevention_rule: {the new rule or check that prevents recurrence}
  - evidence: {links to the run, command outputs, memory ids}
  - timestamp: {ISO 8601}
```

**Routing**: writeback happens after the run ends (in the same session if possible, or as a follow-up TaskPad item).

---

## 3-Challenge Limit & Human Escalation

> If Coder receives 3 rejections from PM-Reviewer on the same issue:
> 1. Coder escalates **"deadlock flag"** to Team-Lead with:
>    - The disagreement description
>    - What PM-Reviewer expects
>    - What Coder attempted
> 2. Team-Lead escalates to human with summary
> 3. Human decides: clarify scope, override PM-Reviewer, replace Coder, or abandon

---

## Architecture Notes (from Red Team Review)

Known failure modes and mitigations:

### One-Shot Architecture Constraints
- Coder session dies after completion; PM-Reviewer cannot "bounce" directly
- PM-Reviewer reports to Team-Lead; Team-Lead respawns Coder with findings
- State transfer via summary, not raw log dumps

### Context Management
- Attempt 1: Full context acceptable
- Attempt 2+: Coder must summarize previous failures before respawning
- Avoid token exhaustion from accumulated iteration logs

### Base Prompt Override
- Subagents inherit platform defaults (e.g., "Answer in 1-3 sentences")
- For detailed review output, PM-Reviewer: *"Provide full detail in your output, not abbreviated responses."*

---

## Standard Prompts

### Team-Lead Prompt

```
You are the Team-Lead. Your role:
1. Understand human's demands and clarify needs
2. Summarize and report status to human
3. Catch wrong direction — if direction is wrong, STOP and correct before proceeding
4. Delegate to Planner (planning), Coder (implementation), PM-Reviewer (review)
You do NOT write code or make detailed plans. Keep context lean. Escalate deadlocks to human.
```

### Planner Prompt

```
You are the Planner. Your role:
1. Decompose task into clear, actionable steps
2. Define measurable success criteria
3. Identify and surface conflicting patterns — pick one, explain why
4. Write plan to <project>/plans/
Provide full detail in your output, not abbreviated responses.
You do NOT write code or execute commands. Flag issues to Team-Lead.
```

### PM-Reviewer Prompt

```
You are the PM Reviewer. Your role:
1. Blue review: correctness, quality, efficiency — does code do what plan says? Is it clean/SOLID?
2. Red review: adversarial attack — what breaks? Edge cases, security, failure modes?
3. Verify test intent — tests verify WHY, not just WHAT
4. Fail loud — surface uncertainty, don't hide skipped checks
Provide full detail in your output, not abbreviated responses.
You do NOT write code or execute commands. Flag issues to Team-Lead.
```

### Codex-Executor Prompt

```
You are Codex-Executor. Your role:
1. Handle complex code execution, debugging, and technical deep-dives
2. Execute code changes with edit/bash access
3. Run tests, verify fixes
4. Report execution results
You do NOT dispatch subtasks. You work under Team-Lead direction.
```

### Coder Prompt

```
You are the Coder. Your role:
1. Receive implementation tasks from Team-Lead/Planner-approved plan
2. Implement according to plan and success criteria
3. Self-test — run lint/typecheck/tests before reporting completion
4. If you receive 3 consecutive rejections on the same issue, flag 'deadlock' to Team-Lead
Do exactly what is assigned — no extra features, no refactoring beyond what's needed.
```

---

## Completion Checklist + Evidence Requirements

> **#george — decision/rationale**: The per-refinement evidence table is the "+1 verification gate" applied at the artifact level, not just the rule level. PM-Reviewer A8 was the gap: rules existed as aspirations without proof-of-compliance. The table is the forcing function — every handoff and every completion report must include the relevant evidence rows. If evidence is missing, work is NOT done, even if the code works. This is also where we close the "checkbox prose" failure mode: agents will say "AC checked ✓" without showing the actual query terms; the table makes that impossible. The async-human row was added after PM-Reviewer post-impl because it was the easiest place to enforce the ambiguous-reply guard — specific action name required. Incident assessment row was added so every run has to explicitly state "no incidents" or list them, which is the operational hook for the incident learning loop above.

Every rule in the skill must produce observable artifacts. PM-Reviewer MUST verify these before accepting work.

- [ ] Team-Lead clarified demands with human
- [ ] Team-Lead ran Step 0 (AC preflight) — project identified, query terms used, memories returned
- [ ] Team-Lead delegated to Planner
- [ ] Planner wrote plan with success criteria
- [ ] PM-Reviewer (pre-impl) red-teamed the plan, accepted or sent back to Planner
- [ ] PM-Reviewer (pre-impl) classified task as `TDD-required` or `TDD-skippable`
- [ ] Coder implemented according to plan
- [ ] Coder self-tested (lint/typecheck/tests)
- [ ] PM-Reviewer (post-impl) completed blue + red review
- [ ] Challenge limit respected (max 3 rejections per issue)
- [ ] Deadlock escalated to human if 3rd rejection unresolved
- [ ] PM-Reviewer accepted and reported
- [ ] ccl-red-team reviewed (if substantial work) — optional but recommended
- [ ] Team-Lead summarized status to human

### Evidence Requirements

| Refinement | Required evidence |
|---|---|
| HIL checked | Checklist in completion report: which triggers were checked, any matches, escalation decision, human response or block reason. If approval was given, the approval text must name the specific gated action (ambiguous replies do not count). |
| AC preflight ran | project identified, query terms used, memories returned, how findings changed the plan, fallback if no results. Evidence must also show Step 0 ran before human clarification / delegation (not after). |
| Superpowers invoked | For every skill in the role's per-role mapping, mark considered / invoked / skipped-with-reason. Cover the full set: `brainstorming`, `writing-plans`, `requesting-code-review`, `receiving-code-review`, `test-driven-development`, `systematic-debugging`, `verification-before-completion`, `using-git-worktrees`, `ccl-red-team`. |
| Handoff contract | Full 13 fields (non-trivial) or short 5 fields (trivial) present in handoff. |
| TDD applied (logic tasks) | Failing test + final passing test outputs; or skip reason from closed list. For skill updates, code TDD is skipped but `writing-skills` process testing discipline MUST be followed. |
| Async-human | If HIL triggered, evidence that framework stopped before gated action; if human responded, response captured AND verified specific to the gated action. |
| Authority respected | All actions within the agent's "May do" column; no Forbidden actions performed. Completion report confirms no out-of-scope file touched. |
| Incident assessment | Explicit "no incidents" or list of incidents with writeback topic_key references. |

**Format**: A short "Evidence" block at the end of every handoff and completion report. If any required evidence is missing, the work is NOT considered done — even if the code works.

---

## Superpowers Integration

> **#george — decision/rationale**: This is the "combine with superpowers — read, analysis with GPT-5.5" piece from the original ask. The mapping makes explicit what was implicit: GPT-5.5 already runs Planner + PM-Reviewer, but they weren't invoking superpowers process skills — just doing the work without a methodology. Now each role has named superpowers skills it considers/invokes/skips. TDD carve-out is "mandatory for logic, skip for trivial" — this is the rule I'm most likely to revisit; the "is this logic or trivial" judgment call could be a rationalization vector under pressure. The load order / recursion guard was the unblocker: `using-superpowers` → `agent-squad` → process skill, with no self-reload. Without that, an agent could re-trigger agent-squad from within agent-squad and burn context. The 3-of-12 rules that map to skills (1≈brainstorming, 9≈TDD, 12≈verification) is the right ratio — too much overlap would mean one of the two is redundant, but 3/12 means superpowers is a methodology layer, not a replacement for the 12 rules.

### Placement

Single `## Superpowers Integration` section at the end of the skill + 1-line pointer in each role's Operating Rules. `agent-squad` POINTS to superpowers skills by name, does NOT duplicate skill content, does NOT reload itself.

### Load Order / Recursion Guard

- `using-superpowers` is the governing skill for skill selection.
- Skill load order: `using-superpowers` → `agent-squad` → process skill (e.g., `brainstorming`, `TDD`).
- No recursion. No two skills define the same operating rule.

### Per-Role Mapping

| Role | Model | Superpowers skills |
|---|---|---|
| Team-Lead | MiniMax | `brainstorming` (Step 0 + clarify) |
| Planner | GPT-5.5 | `brainstorming` (ideation) → `writing-plans` (structure) |
| PM-Reviewer (pre) | GPT-5.5 | `requesting-code-review` (plan-as-code) |
| Coder | MiniMax | `using-git-worktrees` → `test-driven-development` (logic only) → `systematic-debugging` (if bug) → `verification-before-completion` (before done) |
| PM-Reviewer (post) | GPT-5.5 | `requesting-code-review` + `receiving-code-review` (mindset for Coder's fixes) |
| fpr-reviewer | GPT-5.5 | `ccl-red-team` (already integrated) |
| Codex-Executor | GPT-5.3 | `systematic-debugging` + `verification-before-completion` |

### TDD Scope

**Mandatory** for business logic / API endpoints / parsers / validators / anything with input-output contracts. **Skip code TDD** for: config, doc edits, typo fixes, pure refactor, surgical 1-line non-logic fixes. **Skill updates** also skip code TDD, but MUST follow `writing-skills` process-document testing/evidence discipline (pressure scenarios, baseline behavior, refactor to close loopholes).

PM-Reviewer pre-impl MUST classify the task as `TDD-required` or `TDD-skippable` based on the closed list.

### TDD Enforcement Evidence

Coder MUST report:
- Failing test written/identified BEFORE implementation
- Exact test command + failing output captured
- Minimal implementation made it pass
- Final test command + passing output captured
- If TDD skipped: explicit reason from closed allow-list (config-only / typo-only / doc edit / surgical 1-line / harness unavailable w/ PM-Reviewer approval)

---

## When to Use

- User says "agent-squad", "mode-b", "opencode-only", or "team-lead coding workflow"
- Complex multi-step task where planning/implementation/review separation helps
- Token-efficient mode using GPT-5.5 selectively

## When NOT to Use

- Quick single-step queries (use direct response)
- User explicitly wants simple back-and-forth without structured workflow
- Task is purely informational (no file changes needed)

---

## Reference

- Source AGENTS.md: `~/.config/opencode/AGENTS.md` (12 rules baseline)
- Superpowers skills: `brainstorming`, `writing-plans`, `requesting-code-review`, `receiving-code-review`, `test-driven-development`, `systematic-debugging`, `verification-before-completion`, `using-git-worktrees`, `ccl-red-team`
- Loop Engineering refs: Addy Osmani (addyosmani.com/blog/loop-engineering), AI Coding Wisely, MindStudio
- Project folder: `~/Documents/Georges/01 🎯 Projects/agent-squad/` (git tracked)
- Archived concept docs: `~/Documents/Georges/01 🎯 Projects/agent-squad/_Archived_Data/`
