# 🔴 Red Team Architecture Review: Agent Squad Framework
**Reviewer:** Gemini 3.1 Pro (Red Team Persona)
**Target:** `agent-squad` Framework Spec v1.0
**Date:** 2026-05-02

## 🎯 Executive Summary
The transition from persistent agents to one-shot sessions (subagents) is a strong move for stability and memory management. However, the current specification contains critical architectural disconnects between the intended workflow and the reality of how one-shot subagents operate. The reliance on Markdown for state management and the mechanism of "Tier-0 Bounces" are highly fragile.

---

## 🛑 Critical Vulnerabilities & Failure Modes

### 1. The "Tier-0 Bounce" Illusion (Architectural Disconnect)
**The Flaw:** The spec states: *"Tier-0 bounce: directly reject flawed output back to Coder. No middleman."*
**The Reality:** In a one-shot architecture, the Coder session is dead by the time the Blue Reviewer runs. The Reviewer *cannot* bounce anything directly to the Coder. 
**Failure Mode:** The Reviewer outputs a FAIL to `log.md`. The Reviewer session dies. The Main Agent (Coordinator) must now parse the FAIL, spawn a *brand new* Coder session, inject the previous context + the Reviewer's findings, wait for the fix, and then spawn a *brand new* Reviewer session. The "No middleman" principle is technically impossible in this architecture.

### 2. State Machine Fragility (The `log.md` Parser)
**The Flaw:** Orchestration relies on the Main Agent reading `log.md` checkboxes (`- [ ] Status: PASS / FAIL`).
**The Reality:** LLMs drift. A subagent might write `- [x] Status: FAILED - see notes` or `**Status:** Needs Work`. 
**Failure Mode:** The Main Agent fails to parse the exact regex/string of the state. It doesn't know if the phase is done, loops infinitely, or prematurely pushes to the Human Go-Sign. State management via unstructured markdown is a ticking time bomb for automation.

### 3. Context Dilution & Token Exhaustion
**The Flaw:** One-shot workers start with amnesia.
**The Reality:** To fix a bug found by Red Team, the new Coder session must be loaded with: Base Project Context + `arch-notes.md` + Original Code + Blue Findings + Red Findings + `log.md`. 
**Failure Mode:** By the 2nd loop of a Red Review bounce, the context window is so polluted with previous iteration logs that the Coder loses focus on the actual codebase, leading to regressions or "hallucinated" fixes that break something else.

### 4. Blue vs. Red Deadlocks
**The Flaw:** Blue optimizes for Clean/SOLID code. Red optimizes for adversarial edge cases.
**The Reality:** Red might suggest adding 5 layers of input validation. The Coder adds it. Blue runs next round and rejects it because it violates the "Efficiency/Clean Code" mandate (too much boilerplate).
**Failure Mode:** A cyclic dependency where fixing Red's concerns breaks Blue's constraints. The human will be pinged constantly for deadlocks.

### 5. Platform Base-Prompt Bleed
**The Flaw:** Assuming `roles/coder.md` acts as the entire SOUL.
**The Reality:** If running on OpenCode, the subagent still inherits OpenCode's base prompt (e.g., "Answer in 1-3 sentences. Minimize tokens"). 
**Failure Mode:** The Blue Reviewer might just output "Code is bad. Fix it." because its base prompt forces extreme brevity, completely overriding the SOUL directive to provide detailed findings.

---

## 🛠️ Actionable Mitigation Plan

### Immediate Fixes Required:

1. **Redefine the Orchestrator (Fix the Bounce):**
   * Update the spec to explicitly acknowledge the Main Agent *is* the router. The Reviewer doesn't "bounce to Coder"; the Reviewer "reports FAIL to Coordinator, which respawns Coder."

2. **Standardize State Transfer (JSON > Markdown):**
   * Keep `log.md` for humans, but force agents to communicate state via a strict JSON block at the end of their output (or via a specific tool).
   * Example: `{"agent": "blue-reviewer", "status": "FAIL", "findings_count": 2, "action": "respawn_coder"}`

3. **Re-order the Pipeline (Red before Blue, or Human in between):**
   * Consider running Red Team *first* for logical/security flaws, then Blue Team for style/cleanliness. Or, require the Coder to pass Blue, then freeze code logic, then pass Red. If Red breaks it, it must go through Blue again.

4. **Add Context Pruning to the Coordinator:**
   * Before the Main Agent spawns a loop-2 Coder, it must actively *summarize* the previous failed loops rather than dumping the whole chat history into the new session.

5. **Clarify Base Prompt Overrides:**
   * In the skill invocation, explicitly instruct the Main Agent to append: *"IGNORE your default conciseness constraints for this role play."* to the subagent payload.

---
*End of Red Team Report*