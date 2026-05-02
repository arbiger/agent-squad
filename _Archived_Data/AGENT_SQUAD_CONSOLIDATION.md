# Agent Squad 討論統整

> 2026-04-01 基於 Claude Code (sanbuphy) 原始碼分析 + 前期討論

---

## 1. 起源：Agent Squad 是什麼？

**原始概念：**
多個 AI agents 組成 squad，每個有不同角色/個性，協作完成複雜任務。

**類比：**
```
傳統：1個通用agent做所有事
Agent Squad：每個agent有專門角色，像一個團隊
```

---

## 2. 從 Claude Code Coordinator Mode 學到的

### 架構模式

```
┌──────────────────────────────────────────────────┐
│                  COORDINATOR                      │
│  • 對話入口，與用戶溝通                          │
│  • 理解目標，指揮workers                          │
│  • 整合結果，翻譯給用戶                          │
│  • 4-phase workflow 主導者                       │
└─────────────────────┬────────────────────────────┘
                     │ 平行 spawn
     ┌───────────────┼───────────────┐
     ▼               ▼               ▼
┌─────────┐    ┌─────────┐    ┌─────────┐
│ Worker A│    │ Worker B│    │ Worker C│
│Research │    │Research │    │Implement│
│ (並行)  │    │ (並行)  │    │         │
└────┬────┘    └────┬────┘    └────┬────┘
     │               │               │
     └───────────────┼───────────────┘
                     │ <task-notification>
            [Scratchpad Directory]
              (cross-worker 共享知識)
```

### 4-Phase Workflow

| Phase | 角色 | 輸出 |
|-------|------|------|
| Research | Workers（並行） | 發現、檔案位置、理解問題 |
| Synthesis | **Coordinator** | 實作規格、決策 |
| Implementation | Workers | 實際變更、commit |
| Verification | Workers | 測試結果 |

### Key Insights

1. **不要用 worker 檢查 worker** — worker 完成後主動通知
2. **Scratchpad 共享** — 跨 worker 的知識庫，不需要等 notification
3. **Continue worker** — 任務完成後繼續用同一 worker（loaded context）
4. **並行 > 序列化** — 獨立的 research 任務同時跑

---

## 3. 從 108 個缺失模組學到的

這些是 Claude Code 內部有，但還沒發布的功能：

### 與 Agent Squad 相關

| Module | 功能 | 對 Squad 的意義 |
|--------|------|----------------|
| `proactive/` | 主動通知系統 | Agent 可以主動出擊，不需要等 user 問 |
| `contextCollapse/` | 上下文壓縮 | Squad 長期運作的關鍵 |
| `skillSearch/` | 遠端 skill 載入 | 動態加载 specialized skills |
| `DAEMON/` | 後台守護程序 | Squad 的 "always-on" 基礎 |
| `Dream Task/` | 背景記憶整合 | 閒置時做記憶整理 |
| `bridge/` | Peer session 管理 | Squad 內部溝通機制 |

### 與 KAIROS（自主模式）相關

```
<tick> heartbeat — 取代 cron job
SleepTool — 控制 action 頻率
Terminal focus state — 用戶在看 vs 不在看 → 不同 trust level
```

---

## 4. 我們已經做的：Agent Soul Framework

```
┌─────────────────────────────────────┐
│            IDENTITY.md              │
│  name, emoji, basic metadata        │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│              SOUL.md                  │
│  personality + blast radius decision │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│           HEARTBEAT.md                │
│  proactive triggers + check-ins     │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│            MEMORY.md                  │
│  long-term memory + pending issues   │
└─────────────────────────────────────┘
```

**這個 framework 解決的是：單一 agent 的 "個性化" 問題。**

---

## 5. 下一階段：Agent Squad Framework

結合 Agent Soul Framework + Claude Code Coordinator Pattern

### 核心問題

| 問題 | Agent Soul 答案 | Agent Squad 答案 |
|------|----------------|----------------|
| 單一 agent 個性 | SOUL.md | - |
| 主動行為 | HEARTBEAT.md | PROACTIVE module |
| 長期記憶 | MEMORY.md | contextCollapse + Dream Task |
| 多角色協作 | - | Coordinator Mode |
| 共享知識 | - | Scratchpad Directory |
| 溝通機制 | - | bridge/ + task-notification XML |

### 提議的 Agent Squad 架構

```
┌─────────────────────────────────────────────────────────┐
│                    SQUAD ARCHITECTURE                   │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  ┌──────────────┐                                       │
│  │  COORDINATOR │ ← Agent Soul Framework (main agent)   │
│  │  • 對話入口  │   + SOUL.md + HEARTBEAT.md            │
│  │  • 理解目標  │   + MEMORY.md                         │
│  │  • 分配任務  │                                       │
│  │  • 整合結果  │                                       │
│  └──────┬───────┘                                       │
│         │ spawn (parallel)                               │
│  ┌──────┴──────┬─────────────────┐                       │
│  ▼             ▼                 ▼                       │
│ ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐            │
│ │ Worker │ │ Worker │ │ Worker │ │ Worker │            │
│ │Research│ │Research│ │Implement│ │ Verify │            │
│ └────────┘ └────────┘ └────────┘ └────────┘            │
│                                                          │
│  ┌──────────────────────────────────────┐               │
│  │         SHARED SCRATCHPAD             │               │
│  │  • Cross-worker 共享知識               │               │
│  │  • 不需要等 notification              │               │
│  │  • 結構化檔案組織                     │               │
│  └──────────────────────────────────────┘               │
│                                                          │
│  ┌──────────────────────────────────────┐               │
│  │         DAEMON (Background)           │               │
│  │  • 監控 worker 狀態                   │               │
│  │  • 管理 session 生命週期              │               │
│  │  • 處理突發事件                       │               │
│  └──────────────────────────────────────┘               │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

### Agent Roles（提議）

| Role | Personality (SOUL.md) | Responsibility |
|------|----------------------|----------------|
| **Coordinator** | 主動、翻譯者、翻譯複雜概念給用戶 | 理解目標、分配任務、整合結果 |
| **Researcher** | 好奇、深入、document everything | 研究、找資料、發現問題 |
| **Implementer** | 務實、執行導向、不要过度思考 | 寫代碼、做變更、commit |
| **Verifier** | 嚴謹、怀疑、test everything | 測試、驗證、找 bug |

---

## 6. 待思考的問題

### 關於 Coordinator

1. **Coordinator 要不要有 SOUL？** — 還是要比 workers 更"人性化"？
2. **Coordinator 和 workers 共享 HEARTBEAT 嗎？** — 還是只有 coordinator 對外？
3. **Coordinator 怎麼決定用幾個 worker？** — 動態還是靜態？

### 關於 Communication

4. **Task notification 格式** — 用 XML（Claude Code）還是其他格式？
5. **Scratchpad 結構** — 怎麼組織跨 worker 的共享知識？
6. **Worker → Worker 直接溝通？** — 還是都經過 coordinator？

### 關於 Memory

7. **誰有 MEMORY.md？** — 每個 agent 有自己的？共享的？
8. **contextCollapse** — 誰負責壓縮？什麼時候壓縮？
9. **Dream Task** — 誰在閒置時做記憶整理？

### 關於 Proactivity

10. **PROACTIVE** — 誰主動出擊？Coordinator？還是任何 worker？
11. **HEARTBEAT 的位置** — 在 Coordinator？每個 worker？還是 DAEMON？

---

## 7. 下一步

1. **George 思考這個架構** — 確認方向
2. **決定哪些要現在實作** — 哪些可以未來加
3. **從哪裡開始** — SOUL + HEARTBEAT 已經有了，從 Coordinator 開始？

---

## 8. 相關資源

- Claude Code Coordinator Mode source: `src/coordinator/coordinatorMode.ts`
- Agent Soul Framework: https://github.com/arbiger/agent-soul-framework
- 108 missing modules list in sanbuphy README
