# Agent-Squad × Loop Engineering Integration — Design Spec

**Date:** 2026-06-13
**Status:** Draft → User review
**Author:** George + Team-Lead (MiniMax-M3)
**Adversarial reviewer:** PM-Reviewer (GPT-5.5) — 12 fixes integrated
**Target:** `~/.config/opencode/skills/agent-squad/SKILL.md` (live) + mirror to `~/Documents/Georges/01 🎯 Projects/agent-squad/SKILL.md`

---

## 1. Context

George read the AI Loop Engineering concept (Addy Osmani, 2026) and connected it to the existing `agent-squad` direction. The system is already more than a coding workflow — it is becoming an **agent team framework**. This spec captures the design for integrating:

- Human-in-the-loop (proactive, not just at boundaries)
- AI Loop Engineering 6+1 frame (anchoring + closing the memory gap)
- agent-squad roles (5-role architecture, unchanged)
- AC cross-agent memory (Step 0 preflight + writeback)
- Superpowers process skills (per-role invocation)
- Evidence-based completion (per-refinement evidence requirements)
- Permission/authority model + tool capability registry
- Incident learning loop

**Files reviewed:**
- `~/Desktop/ai-loop-engineering-summary-2026-06-11.md` (140 lines, concept summary)
- `~/Desktop/PLAN-agent-squad-agent-team-framework.md` (603 lines, framework plan)
- `~/.config/opencode/skills/agent-squad/SKILL.md` (295 lines, current skill)
- `~/.config/opencode/opencode.json` (5 agents + 2 copywriters defined)
- Project folder: `~/Documents/Georges/01 🎯 Projects/agent-squad/` (git tracked)

**Adversarial review:**
- PM-Reviewer (GPT-5.5) red-teamed the locked 5 refinements → flagged 12 specific gaps → all 12 accepted by George.

---

## 2. Goals

After this update, the agent-squad skill will:

1. **Close the loop eng #3 (memory) gap** by adding AC preflight (Step 0) to Team-Lead.
  2. **Make human-in-loop proactive** via the 7 MUST triggers (organized as a decision tree, originally 6 categories) + async-human handling.
3. **Wire superpowers process skills** explicitly per role (read + analysis with GPT-5.5 + superpowers methodology).
4. **Standardize handoff discipline** via 13-field contract (was 12, count fixed).
5. **Anchor the conceptual frame** by mapping agent-squad to loop eng 6+1.
6. **Define authority + tool boundaries** so agents know what they may do without asking.
7. **Enable incident learning** by defining what counts as an incident + writeback format.
8. **Be enforceable, not aspirational** — every rule has evidence requirements.

**Success criteria:**
- A reviewer can verify HIL was checked, AC was queried, TDD was applied, contract was honored, authority was respected — all from artifacts in the run.
- A new agent reading the skill knows exactly what to do, when, and with what authority.
- George sees status reports that reference memory ids, evidence commands, and HIL decisions.

---

## 3. Non-Goals

Out of scope for this update:

- New companion files (`references/agent-contract-schema.md`, `references/incident-learning-loop.md`, `references/tool-capability-registry.md`) — future session per PLAN Phase 2.
- Full 14-section PLAN implementation — we ship the 8+1 sections that close the most critical gaps; the rest are deferred.
- Automating the framework — no new scripts, no new launchd jobs, no new MCP servers.
- Re-organizing the existing 5-role architecture — it stays.
- Modifying opencode.json — agent definitions and permissions stay as-is for now.
- Hermes-side changes (registration as Hermes skill) — separate session.

---

## 4. Background

### 4.1 Current state (gap analysis)

| Loop Eng # | Element | Current agent-squad | Status |
|---|---|---|---|
| 1 | Automation | Not in skill | ❌ deferred (launchd shell scaffold handles) |
| 2 | Worktree isolation | Implicit (git standard) | ⚠️ made explicit via superpowers pointer |
| 3 | **Memory** | Decided 2026-06-11, **not wired** | ❌ → **fixed by Step 0** |
| 4 | Skills / KB | Skill itself is this | ✓ |
| 5 | Connectors | Implicit (MCP in opencode.json) | ⚠️ → made explicit via tool capability registry |
| 6 | Sub-agents | 5-role architecture | ✓ |
| +1 | Human verification | PM-Reviewer × 2 + 12 rules + 3-challenge limit | ⚠️ → strengthened with 6 HIL triggers + async-human handling |

### 4.2 5-role architecture (unchanged)

```
Human ↔ Team-Lead (MiniMax)
        ↓
       Planner (GPT-5.5)
        ↓
       PM-Reviewer [PRE-IMPL] (GPT-5.5)
        ↓
       Coder (MiniMax)
        ↓
       PM-Reviewer [POST-IMPL] (GPT-5.5)
        ↓
      [fpr-reviewer] (optional)
        ↓
       Codex-Executor (GPT-5.3)
```

### 4.3 The 12-rules baseline (unchanged)

The 12 Karpathy-inspired rules remain the always-on code of conduct for every role. This update does NOT modify them — it adds superpowers hooks that operationalize 3 of them (Rule 1 ≈ brainstorming, Rule 9 ≈ TDD, Rule 12 ≈ verification-before-completion).

---

## 5. The 22 Design Decisions

### 5.1 HIL design (decisions 1, 2, 3, 11, 12)

**Default = boundaries (A.1)**: Team-Lead clarifies at start, reports status throughout, accepts at end. PM-Reviewer is the mid-loop gate, not human.

**7 structured MUST triggers** (PM-Reviewer MUST escalate to Team-Lead for human input when any fires). Originally 6 triggers, reorganized into 7 categories per PM-Reviewer fix A1 — the original "high-stakes" trigger is now split into 2 separate decision-tree items (state change + cost/risk). The 6 original categories are all preserved:

```
Decision tree (check in order; first match wins):

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

**Wording rule**: "PM-Reviewer MUST escalate to Team-Lead for human input when [trigger]." Structured, not heuristic. PM-Reviewer pre-impl evaluates the plan; PM-Reviewer post-impl evaluates the work.

**Async-human behavior** (decision 12): If HIL escalation fires and human is unavailable, the framework MUST:
- **STOP** before the gated action.
- **CONTINUE** only with safe, reversible, draft-only work that does not pre-decide the human's choice.
- **RECORD** blocked status + exact approval needed.

Examples:
- Draft an email → allowed. Send → blocked.
- Prepare migration plan → allowed. Run migration → blocked.
- Generate social post → allowed. Publish → blocked.
- Stage local diff → allowed. Push → blocked.

### 5.2 AC preflight — Step 0 (decisions 4, 5, 13, 14)

**Step 0 order** (decision 13 — explicit, no conflict with Team-Lead rule #1):
1. **Minimal project identification pass** — identify the project from folder name / context clues.
2. **If project ambiguous** → ask one human clarification first, then return to Step 0.
3. **Query AC** for project conventions, active work, pitfalls, prior decisions.
4. **Then** clarify demands with human, using AC-informed questions.
5. **AC does not replace human clarification** — it's a memory layer, not a substitute.

**Query shape**:
- `agent-cortex_memory_query` (MCP tool, `query`, `mode: hybrid`, `limit: 5`)
- Query terms: `"{project} conventions active work pitfalls prior decisions"`
- Cite memory_id in handoff to Planner

**Writeback**:
- After durable decisions (framework choice, new rule, naming convention, scope decision):
  - `agent-cortex_memory_write` with `topic_key: "{project}-decision"`
- After incidents (see §5.7): `topic_key: "{project}-incident"`
- After pitfalls discovered: `topic_key: "{project}-pitfall"`

**Stale/wrong memory handling** (decision 14):
- **Source priority**: direct user instruction > current project files/docs > skill rules > AC memory.
- If AC conflicts with current repo state, prefer current state; surface the conflict in the report.
- Memories older than 30 days for active projects require confirmation before being used as basis for action.

### 5.3 Superpowers integration (decisions 6, 7, 17, 22)

**Placement** (decision 6): Single `## Superpowers Integration` section at the end of the skill + 1-line pointer in each role's Operating Rules.

**Per-role mapping**:

| Role | Model | Superpowers skills |
|---|---|---|
| Team-Lead | MiniMax | `brainstorming` (Step 0 + clarify) |
| Planner | GPT-5.5 | `brainstorming` (ideation) → `writing-plans` (structure) |
| PM-Reviewer (pre) | GPT-5.5 | `requesting-code-review` (plan-as-code) |
| Coder | MiniMax | `using-git-worktrees` → `test-driven-development` (logic only) → `systematic-debugging` (if bug) → `verification-before-completion` (before done) |
| PM-Reviewer (post) | GPT-5.5 | `requesting-code-review` + `receiving-code-review` (mindset for Coder's fixes) |
| fpr-reviewer | GPT-5.5 | `ccl-red-team` (already integrated) |
| Codex-Executor | GPT-5.3 | `systematic-debugging` + `verification-before-completion` |

**TDD scope** (decision 7): Mandatory for business logic / API endpoints / parsers / validators / anything with input-output contracts. Skip for: config, doc edits, typo fixes, pure refactor, skill updates, surgical 1-line non-logic fixes.

**TDD enforcement evidence** (decision 17) — Coder MUST report:
- Failing test written/identified BEFORE implementation
- Exact test command + failing output captured
- Minimal implementation made it pass
- Final test command + passing output captured
- If TDD skipped: explicit reason from closed allow-list (config-only / typo-only / doc edit / surgical 1-line / harness unavailable w/ PM-Reviewer approval)

PM-Reviewer pre-impl MUST classify the task as `TDD-required` or `TDD-skippable` based on the closed list.

**Load order / recursion guard** (decision 22):
- `using-superpowers` is the governing skill for skill selection.
- `agent-squad` POINTS to superpowers skills by name, does NOT duplicate skill content, does NOT reload itself.
- Skill load order: `using-superpowers` → `agent-squad` → process skill (e.g., `brainstorming`, `TDD`).
- No recursion. No two skills define the same operating rule.

### 5.4 Handoff contract (decisions 8, 9, 15, 16)

**Field count** (decision 16): **13 fields**, not 12. (Role, Goal, Background, Scope, Non-goals, Inputs, Files likely involved, Allowed tools, Forbidden actions, Expected output, Self-test commands, Evidence required, Escalation triggers.)

**Mandatory scope** (decision 8):
- **Full 13 fields** for non-trivial tasks (touches >1 file OR >15 min OR has scope ambiguity).
- **Short version** (Role, Goal, Scope, Forbidden, Evidence) for trivial tasks (config, typo, doc, 1-line fix).
- PM-Reviewer MAY reject the "trivial" classification if the task involves logic, external action, regulated project, cross-file edits, or unclear scope.

**Forbidden actions** (decisions 9, 15) — **DYNAMIC PER TASK**, not blanket boilerplate:
- Team-Lead/Planner MUST derive **task-specific** Forbidden actions from the HIL trigger set.
- If no HIL-derived forbidden action applies, write: `"Forbidden: no external/public/irreversible action; remain draft-only unless human approves."`
- Example forbidden sets:
  - Doc edit: "Forbidden: publish, email, git push, modify non-skill files unless explicitly approved."
  - Migration: "Forbidden: run migration, delete data, alter schema, touch production DB without human approval."
  - Marketing copy: "Forbidden: publish/social post/email client; draft-only unless approved."

### 5.5 Loop engineering anchoring (decision 10)

**Placement**: 1-paragraph framing section at the start of the new skill, plus a small mapping table.

**Framing**:
> AI Loop Engineering (Addy Osmani, 2026) defines 6 elements + 1 verification gate. agent-squad is the productionized sub-agent pattern (element #6). This skill also integrates the other 5 elements to varying degrees: #2 worktree via superpowers, #3 memory via AC preflight (Step 0), #4 skills (the skill itself), #5 connectors via MCP. The +1 verification gate is operationalized as PM-Reviewer × 2 + 12 rules + 3-challenge limit + the 6 HIL triggers defined here.

**Mapping table**: 7 rows (6 elements + 1 verification), each row = element + agent-squad integration status.

### 5.6 Permission / authority model (decision 19)

**Authority hierarchy** (top of skill, called out explicitly):

| Authority | May do without asking | May NOT do |
|---|---|---|
| **Human (George)** | Anything | — |
| **Team-Lead** | Read all skills/AC, write to AC, delegate to agents, run framework, choose trivial/non-trivial, escalate to human | Direct file edits to skills, irreversible ops, send external messages, modify Hermes config |
| **Planner** | Read project files/AC, write plan, query AC, request clarification | Code execution, file edits, external actions |
| **PM-Reviewer (both)** | Read all, write review, classify task (TDD-required/skippable), reject work, escalate to Team-Lead | Code edits, external actions, modify skills, override HIL |
| **Coder** | Read project files/AC, edit assigned files, run self-tests, write to TaskPad | Touch out-of-scope files, external actions, modify skills, expand scope |
| **fpr-reviewer** | Read all, write first-principles review | Code edits, external actions |
| **Codex-Executor** | Read all, edit files, run tests, debug | Touch out-of-scope files, external actions, modify skills |

**Hard rule**: No agent may perform an action listed in another agent's "May NOT do" column without explicit human approval.

### 5.7 Incident learning loop (decision 20)

**What counts as an incident** (closed list):
1. HIL trigger missed (work proceeded when it shouldn't have)
2. Wrong project memory used (stale/incorrect AC fact)
3. PM-Reviewer 3rd rejection on same issue (deadlock)
4. Failed deploy / push / publish / external action
5. Data loss or near-miss (accidental deletion, schema corruption)
6. User correction of factual / project memory
7. Scope creep caught late (after substantial work)
8. Agent made a hidden assumption that was wrong

**Writeback format** (mandatory, every incident):
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

### 5.8 Tool capability registry (decision 21)

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

### 5.9 Per-refinement evidence requirements (decision 18)

**Every rule in the skill must produce observable artifacts**. PM-Reviewer MUST verify these before accepting work.

| Refinement | Required evidence |
|---|---|
| HIL checked | Checklist in completion report: which triggers were checked, any matches, escalation decision, human response or block reason |
| AC preflight ran | project identified, query terms used, memories returned, how findings changed the plan, fallback if no results |
| Superpowers invoked | "Process skills considered/invoked: brainstorming yes/no/why, TDD yes/no/why, verification-before-completion yes/no/why" |
| Handoff contract | Full 13 fields (non-trivial) or short 5 fields (trivial) present in handoff |
| TDD applied (logic tasks) | Failing test + final passing test outputs; or skip reason from closed list |
| Async-human | If HIL triggered, evidence that framework stopped before gated action; if human responded, response captured |
| Authority respected | All actions within the agent's "May do" column; no Forbidden actions performed |
| Loop eng integration | Memory/connectors/sub-agents sections exercised per the design |

**Format**: A short "Evidence" block at the end of every handoff and completion report. If any required evidence is missing, the work is NOT considered done — even if the code works.

---

## 6. New Skill Structure (14 sections + 2 new)

The new SKILL.md will have these sections, in this order:

1. **Purpose** (unchanged)
2. **Loop Engineering Anchoring** (NEW, decision 10)
3. **Core Flow** (unchanged, ASCII diagram)
4. **Coding Baseline — 12 Rules** (unchanged)
5. **Role-Specific Emphasis** (unchanged, with superpowers pointer added)
6. **When to Use Each** (unchanged)
7. **Operating Rules** (existing, with superpowers 1-line pointer added per role)
8. **HIL Triggers & Async-Human Behavior** (NEW, decisions 1, 2, 3, 11, 12)
9. **Permission / Authority Model** (NEW, decision 19)
10. **Tool Capability Registry** (NEW, decision 21)
11. **Handoff Contract** (NEW, decisions 8, 9, 15, 16)
12. **Step 0 — Memory Preflight** (NEW, decisions 4, 5, 13, 14)
13. **Incident Learning Loop** (NEW, decision 20)
14. **Three-Challenge Limit & Human Escalation** (unchanged)
15. **Architecture Notes from Red Team Review** (unchanged)
16. **Standard Prompts** (unchanged)
17. **Completion Checklist + Evidence Requirements** (expanded, decision 18)
18. **Superpowers Integration** (NEW, decisions 6, 7, 17, 22)
19. **When to Use / Not Use** (unchanged)
20. **Reference** (updated paths)

Net: ~14 → 20 sections, +6 new sections, 6 expanded, 8 unchanged. Estimated total: ~600 lines.

---

## 7. What This Design Is Not

- Not fully autonomous replacement for George.
- Not all-agent free-for-all.
- Not a memory dump.
- Not a giant bureaucracy for every small task.
- Not an LLM routing layer that decides everything silently.

It IS:
- A structured operating system for agent teams.
- Human-led.
- Evidence-driven.
- Review-gated.
- Memory-aware.
- Skill-improving.

---

## 8. Open Questions / Next Steps

### 8.1 For this session

- User reviews this spec.
- If approved, update `~/.config/opencode/skills/agent-squad/SKILL.md` per the structure in §6.
- Mirror to `~/Documents/Georges/01 🎯 Projects/agent-squad/SKILL.md`.
- Commit in agent-squad git repo.

### 8.2 For next session (deferred per PLAN Phase 2)

- Companion files: `references/agent-contract-schema.md`, `references/incident-learning-loop.md`, `references/tool-capability-registry.md`.
- Test with one real substantial task end-to-end (Phase 4 of PLAN).
- Wire Step 0 into actual subagent prompts (currently the rule is in the skill; the prompts in opencode.json don't yet reference it).
- Hermes-side registration of agent-squad as a Hermes skill.

### 8.3 For later (PLAN Phase 3+)

- Connector gap (loop eng #5): which MCPs to add beyond agent-cortex and google-ai-search?
- Automation gap (loop eng #1): when to elevate from shell scaffold to Multica / Paperclip?
- Memory hygiene loop (PLAN §4.4): how to keep AC vault lean and current.

---

## 9. Reference

### 9.1 Source files

- `~/Desktop/ai-loop-engineering-summary-2026-06-11.md` — AI Loop Engineering concept summary
- `~/Desktop/PLAN-agent-squad-agent-team-framework.md` — 14-section framework plan
- `~/.config/opencode/skills/agent-squad/SKILL.md` — current skill (pre-update)
- `~/.config/opencode/opencode.json` — agent definitions
- `~/.config/opencode/AGENTS.md` — 12 rules baseline
- `~/Documents/Georges/01 🎯 Projects/agent-squad/SKILL.md` — git mirror

### 9.2 Superpowers skills referenced

- `brainstorming` — ideation, explore intent
- `writing-plans` — multi-step task planning
- `requesting-code-review` — review lens
- `receiving-code-review` — review response mindset
- `test-driven-development` — TDD for logic
- `systematic-debugging` — bug methodology
- `verification-before-completion` — evidence before claiming done
- `using-git-worktrees` — isolated workspace
- `ccl-red-team` — first-principles challenge (already integrated)

### 9.3 Loop Engineering references

- Addy Osmani — https://addyosmani.com/blog/loop-engineering/
- AI Coding Wisely — https://ai-coding.wiselychen.com/loop-engineering-five-plus-one-implementation-guide/
- MindStudio — https://www.mindstudio.ai/blog/what-is-loop-engineering-ai-coding-agents

---

**End of design spec. Reviewer: please confirm or flag changes before implementation.**
