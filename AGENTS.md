# AGENTS.md — 跨工具開發指引（單一真相 / Single Source of Truth）

> 本檔是**所有 AI 編程工具**的共同指引來源（Codex、GitHub Copilot、Cursor、Gemini CLI、Google Antigravity、Windsurf、Claude Code…）。
> This file is the shared instruction source for **all AI coding tools**.
> 維護鐵則：**只改這個檔**；其他工具的設定檔都指向它，不要複製內容（避免漂移）。
> Maintenance rule: **edit only this file**; every tool config points here — never copy (avoid drift).
> 配置方式見 / Setup guide: [docs/MULTI-TOOL-SETUP.md](docs/MULTI-TOOL-SETUP.md)

---

## 1. 行為原則 / Behavior Principles（always-on，每個動作都遵守）

源自 Andrej Karpathy 對 LLM 編程通病的觀察。/ Derived from Andrej Karpathy's notes on common LLM coding failures.

### ① 先想再寫 / Think Before Coding
不要替使用者亂假設，不要藏起困惑，攤開取捨。/ Don't assume on the user's behalf; don't hide confusion; surface tradeoffs.
- 明確說出假設；不確定就問。/ State assumptions; if uncertain, ask.
- 有多種解讀就全列出，別私自選一個。/ Multiple interpretations → present them, don't pick silently.
- 有更簡單的做法就講出來。/ If a simpler approach exists, say so.

### ② 簡單優先 / Simplicity First
解決問題的最小程式碼，不做臆測性的東西。/ Minimum code that solves the problem; nothing speculative.
- 不加沒要求的功能、抽象、彈性、設定。/ No unrequested features, abstractions, flexibility, or config.
- 不為不可能的情境寫錯誤處理。/ No error handling for impossible scenarios.
- 寫了 200 行但其實 50 行能解 → 重寫。/ 200 lines where 50 would do → rewrite.
- 自問：「資深工程師會說這過度複雜嗎？」是 → 簡化。

### ③ 手術式改動 / Surgical Changes
只動你必須動的；只清理你自己造成的爛攤子。/ Touch only what you must; clean up only your own mess.
- 不「順手改善」鄰近程式、註解、格式。/ Don't "improve" adjacent code/comments/formatting.
- 不重構沒壞的東西；配合既有風格。/ Don't refactor what isn't broken; match existing style.
- 看到無關的死碼 → 指出，別刪。/ Unrelated dead code → mention it, don't delete.
- 檢驗：每一行改動都能直接追溯到使用者的要求。/ Every changed line traces to the request.

### ④ 目標驅動 / Goal-Driven Execution
把任務變成可驗證的成功條件，迴圈到驗證通過。/ Turn tasks into verifiable criteria; loop until verified.
- 「加驗證」→「為不合法輸入寫測試，再讓它通過」。
- 「修 bug」→「先寫能重現的測試，再讓它通過」。
- 「重構 X」→「改動前後測試都要綠」。

> 取捨：以上偏向謹慎而非速度；瑣碎任務請自行判斷。/ These bias toward caution over speed; use judgment on trivial tasks.

---

## 2. 開發工作流 / Development Workflow（工具無關的檢查清單）

依序推進 **Think → Plan → Build → Review → Test → Ship → Reflect**。
每個 AI 工具都應照這套走；差別只在「是否有可執行的自動化」（見 §4）。

> ☑ = 進入下一階段前該勾掉的項目。/ ☑ = check before moving on.

### 0–1. Think / Plan（想清楚、寫計畫）
- ☑ 把模糊想法逼成清楚需求：問範疇、邊界、權限、失敗情境。/ Pin down scope, edges, permissions, failure cases.
- ☑ 探索既有程式：先找可重用的函式/工具/模式，**不要重造輪子**。/ Reuse existing code before writing new.
- ☑ 寫一份「可逐步執行」的計畫，落到 `plans/`：每步附**驗證方式**。/ Write a step-by-step plan in `plans/`, each step with a verification.
- ☑ 計畫含「不做的事」邊界，防範圍蔓延。/ Include a scope guard.

### 2. Build（實作 — TDD 紀律）
- ☑ **先寫失敗測試**，再寫實作到綠燈（紅→綠→重構）。/ Write a failing test first, then make it pass.
- ☑ 一次一小步、頻繁取得回饋。/ Small steps, rapid feedback.
- ☑ 只動計畫範圍內的檔案（呼應原則③）。/ Touch only in-scope files.
- ☑ 改動產生的孤兒（沒用到的 import/變數）要清掉；既有死碼不動。/ Remove orphans your change created; leave pre-existing dead code.

### 3. Review（審查）
- ☑ 落地前自審：正確性、可簡化處、是否偏離需求。/ Self-review for correctness, simplification, drift.
- ☑ 收到他人/AI 的 review：技術上嚴謹查證，別盲從也別表演式同意。/ Verify feedback technically; no blind agreement.

### 4. Test / QA（測試）
- ☑ 跑全部測試，貼出**真實輸出**；別宣稱通過卻沒跑。/ Run tests, show real output; never claim-without-running.
- ☑ 有 UI 就實際操作一遍（手動或瀏覽器自動化）。/ For UI, actually exercise the flow.

### 5. Ship（出貨）
- ☑ **完成前先驗證**：真的跑一遍，確認行為符合需求，再宣稱完成。/ Verify before claiming done — evidence before assertions.
- ☑ 對外/難回復的動作（部署、刪除、推送）先確認再做。/ Confirm irreversible/outward actions first.
- ☑ commit / PR 訊息誠實反映實況（測試失敗就說失敗）。/ Report outcomes faithfully.

### 6. Reflect（反思）
- ☑ 回顧哪裡返工、哪裡可沉澱成慣例或文件。/ Note rework; capture learnings into docs/conventions.

---

## 3. 專案慣例 / Project Conventions

- `plans/` — 計畫檔（每步附驗證）/ plan files (each step verifiable)
- `docs/` — ADR、設計文件、規格 / ADRs, design docs, specs
- 程式碼依語言自建（`src/` 等）/ source dirs per language

指令優先序 / Instruction priority：**使用者明確指令 > 本指引 > 工具預設**。
使用者說 WHAT，本指引決定 HOW。「加 X / 修 Y」不代表略過工作流程。

---

## 4. 工具能力差異 / Tool Capability Tiers

本指引分兩層 / This guide has two tiers：

- **Tier 1（可攜，本檔全部內容）**：任何 AI 工具都能遵守的純指令。/ Portable — pure instructions any tool can follow.
- **Tier 2（Claude Code 專屬，見 [CLAUDE.md](CLAUDE.md)）**：可執行的自動化 —— superpowers skills、gstack 斜線指令（`/ship`、`/qa`…）、rtk 節流 hook、caveman。**這些只在 Claude Code 會跑**；在 Codex/Copilot/Antigravity 等請改用上方 §2 的文字版清單手動推進。
  Executable automation that **runs only in Claude Code**; elsewhere follow the §2 checklist manually.

> 換句話說：**所有工具都拿到同一套原則與流程**；Claude Code 額外多了「自動化執行」。
> Every tool gets the same principles and flow; Claude Code additionally automates them.
