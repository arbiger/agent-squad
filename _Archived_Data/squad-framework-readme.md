# 🐾 OpenClaw Matrix Squad Framework

A streamlined, high-performance multi-agent framework built for OpenClaw. Optimized for a single-model (e.g., Claude 3.5 Sonnet) setup using Mindset Isolation, Tier-0 Evaluator-Optimizer loops, and dynamic self-evolutionary memory.

## 🏗 First Principles: Why This Framework Works

Many multi-agent systems fail because they over-complicate simple tasks or suffer from "Self-Confirmation Bias" when a single agent reviews its own work.

This framework is built on two core principles:
- **Conflict-Driven Role Isolation**: We separate roles (e.g., Coder vs. Reviewer) not just for the sake of having a team, but because they require conflicting system prompts and tool permissions.
- **Evaluator-Optimizer Loops (Tier 0)**: Instead of the Manager acting as a middleman for every bug, the Reviewer directly bounces flawed output back to the Executor.

## 🧠 Architecture & Agent Roles

```
┌────── User ──────┐
│ "calling squad [project] [context]" │
 └────────┬────────┘
          ↓
┌───── Squad Manager ─────┐ ← Orchestrator & Arbitrator
│ [SCOPING] [DELEGATING] [ARBITRATION] [ESCALATING] │
└────────┬────────┘
         │
    ┌────┴────┐
    │         │
    ↓         ↓
Dev Squad   Market Squad
    │         │
┌───┴───┐ ┌──┴────┐
│       │ │       │
↓       ↓ ↓       ↓
Architect  Code-Reviewer  Researcher  Copywriter
Coder   (Red Team)      Brand-Reviewer
                            (Red Team)
         ↓
      Observer ← Async Memory & Logging
```

### Core Agents

| Agent | Role | Key Responsibility |
|-------|------|-------------------|
| **Squad Manager** | Orchestrator | Delegate, arbitrate, escalate |
| **Observer** | Memory Guardian | Log decisions, extract rules |
| **Architect** | System Blueprint | Create CLAUDE.md, architecture docs |
| **Coder** | Implementation | Write production code |
| **Code Reviewer** | Security Audit | Tier-0 bounce, reject flawed code |
| **Researcher** | Market Intel | Web search, gather insights |
| **Copywriter** | Content Creator | Write marketing copy |
| **Brand Reviewer** | Brand Guardrail | Tier-0 bounce, reject off-brand copy |

## ⚙️ Human Escalation Configuration

Configure when the system should escalate to human intervention. Add to your skill's `SKILL.md`:

### Default Behavior
```markdown
## 預設行為
- max_review_rounds: 1
- human_escalation: enabled
- trigger_on_reject: true
- trigger_on_uncertain: true
```

### Customization Options
```markdown
## 使用者可以修改
- max_review_rounds: 2       # 多一輪辯論
- human_escalation: disabled  # 完全不呼叫人類
- trigger_on_reject: false    # Reviewer reject 時不通過人類
- trigger_on_uncertain: false # 不確定時不通過人類
```

## 🔄 Workflow Pipeline

```
calling → Squad Manager wakes up
    ↓
[Stage 1] Parse Intent (Architect/Researcher)
    ↓ Reviewer audit → Observer logs (pass/fail) [async]
    ↓
[Stage 2] Data Collection & Analysis (Architect/Researcher)
    ↓ Reviewer audit → Observer logs (pass/fail) [async]
    ↓
[Stage 3] Execution (Coder/Copywriter)
    ↓ Reviewer audit → Observer logs (pass/fail) [async]
```

## ⚖️ Three-Tier Arbitration

| Tier | Who | Action |
|------|-----|--------|
| **Tier 0** | Reviewer | Direct bounce to executor (max 2 loops) |
| **Tier 1** | Squad Manager | Rule-making for unresolved conflicts |
| **Tier 2** | User | Major strategic decisions |

## 📁 Each Agent Contains

- `SOUL.md` — Core principles and constraints
- `IDENTITY.md` — Character description and tone

## 🚀 Getting Started

### Step 1: Register Agents
```bash
openclaw agents add squad-manager --workspace ./workspaces/squad-manager
openclaw agents add observer --workspace ./workspaces/observer
openclaw agents add architect --workspace ./workspaces/architect
openclaw agents add coder --workspace ./workspaces/coder
openclaw agents add code-reviewer --workspace ./workspaces/code-reviewer
openclaw agents add researcher --workspace ./workspaces/researcher
openclaw agents add copywriter --workspace ./workspaces/copywriter
openclaw agents add brand-reviewer --workspace ./workspaces/brand-reviewer
```

### Step 2: Configure Model
```json
{
  "agents": {
    "defaults": {
      "model": "anthropic/claude-3-5-sonnet"
    }
  }
}
```

### Step 3: Activate
Say: `"calling squad [project name] [context]"`

## 💡 Advanced Tips

1. **Model Tiering**: Use cheaper models for executors (Coder, Researcher), premium for Managers and Reviewers.
2. **Self-Evolution**: Reviewers can write to `BRAND.md` / `CLAUDE.md` — ask them to "update project rules" when issues recur.
3. **Observer Memory**: The Observer automatically extracts decisions into permanent rules in `docs/decisions/`.
