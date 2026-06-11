# AI 代理編程樣板與使用指引
## Agent-Coding Template & Field Guide

把目前 vibe-coding 圈內較知名的幾套 skill / 工具，整合成**一套可重用的樣板專案 + 一份深度使用指引**。
複製本目錄即可獲得已調好的行為規範、開發流程與節流設定；本文件回答最關鍵的問題：**在開發的哪個階段，該用哪一個 skill。**

> An integration of well-known vibe-coding skills/tools into one reusable template + a field guide.
> Core question it answers: **which skill to use at which phase of development.**

---

## 0. TL;DR（先看這段）

1. 這些工具**不互相競爭**，而是疊在**四個高度**：行為（karpathy）→ 巨觀流程（gstack）→ 微觀紀律（superpowers）→ 節流（rtk + caveman）。
2. 「該用哪一種 skill 管流程？」→ **不二選一**。預設 = **gstack 當 sprint 外殼**、**superpowers 當每段實作的內核**。被迫挑一個：Web/產品→gstack；後端/CLI→superpowers。
3. 用法：**讓意圖對上 skill 就直接用 skill**，照[階段→skill 路由表](#4-階段--skill-路由表)走，別手動重做流程。

---

## 1. 如何使用此樣板 / How to Use

```
複製本目錄 → 在裡面開新專案 → 直接對 Claude 描述需求
Copy this folder → start your project inside → just describe what you want
```

- 行為層（karpathy 4 原則）已在你的全域 `~/.claude/CLAUDE.md`，**每次都生效**，不需設定。
- 本專案的 [CLAUDE.md](CLAUDE.md) 已宣告路由表，Claude 會在對的階段自動觸發對的 skill。
- 你只需要：**用自然語言描述意圖**（「我想做一個 X 功能」），其餘交給路由表。

---

## 2. 四層心智模型 / The Four-Layer Model

整套方法的核心：**這些 repo 不是替代品，而是疊在不同高度，各管一件事。**

```
┌─────────────────────────────────────────────────────────┐
│ 行為層 Behavior   andrej-karpathy 4 原則（always-on）     │  ← 每個動作都遵守 HOW-to-think
├─────────────────────────────────────────────────────────┤
│ 巨觀流程 Macro     gstack：產品生命週期 sprint 編排        │  ← 管「整個 sprint」
│ 微觀紀律 Micro     superpowers：每個 coding 子任務的紀律   │  ← 管「每段實作」
│   （補充 documented：mattpocock/skills）                  │
├─────────────────────────────────────────────────────────┤
│ 節流層 Token       rtk（輸入，auto）+ caveman（輸出，選用）│  ← 底層省 token
└─────────────────────────────────────────────────────────┘
```

**為什麼這樣分？** 因為它們解決的是**不同層次的失敗模式**：
- karpathy → 解決「LLM 亂假設、過度複雜化」的**思考失敗**。
- gstack → 解決「沒有產品/設計/QA/出貨流程，東西從縫隙漏掉」的**流程失敗**。
- superpowers → 解決「實作沒紀律、跳過測試、宣稱完成卻沒驗證」的**工程失敗**。
- rtk / caveman → 解決「context 與 token 爆掉、變慢變貴」的**成本失敗**。

四者疊起來才完整：紀律的實作（superpowers）放進有流程的 sprint（gstack），每個動作都守規矩（karpathy），底層持續省 token（rtk/caveman）。

---

## 3. 各 Repo 深度比較 / Deep Comparison

| Repo | 所屬層 | 用途 / What it does | 典型觸發語 / Trigger | 安裝狀態 |
|---|---|---|---|---|
| **andrej-karpathy-skills** (`multica-ai`) | 行為 | 4 條原則矯正 LLM 通病：①Think Before Coding 不亂假設、②Simplicity First 不過度設計、③Surgical Changes 只動該動的、④Goal-Driven 定義可驗證成功條件 | （always-on，無需觸發） | ✅ 已合入全域 `~/.claude/CLAUDE.md` |
| **superpowers** (`obra`) | 微觀紀律 | 14 個 skill 的嚴格工程流程：`brainstorming`→`writing-plans`→`executing-plans`／`subagent-driven-development`→`test-driven-development`→`systematic-debugging`→`verification-before-completion`。強調 TDD、子代理並行、完成前先驗證 | 「做一個功能 / 修 bug / 寫計畫 / 重構」 | ✅ plugin v5.1.0 |
| **gstack** (`garrytan`) | 巨觀流程 | ~60 個「角色化」skill，把 Claude 變成虛擬工程團隊（CEO/設計/工程主管/QA/發布）。Sprint：Think→Plan→Build→Review→Test→Ship→Reflect。代表：`/office-hours`、`/plan-*-review`、`/design-*`、`/qa`、`/ship`、`/browse` | 「審我的計畫 / 設計畫面 / 跑 QA / 出貨部署」 | ✅ skills 目錄 |
| **rtk** (`rtk-ai`) | 節流（輸入） | CLI proxy，經 hook 自動改寫指令（`git status`→`rtk git status`），0 token 開銷，省 60–90% 工具輸出 token。`rtk gain` 看成效 | （auto，無需觸發） | ✅ v0.42.0 |
| **caveman** (`JuliusBrussee`) | 節流（輸出） | 壓縮 agent **輸出** token ~65%，去掉贅詞用片語。研究指出「限制簡短回應在某些 benchmark 反而 +26 分準確度」 | `/caveman`、「talk like caveman」 | ❌ 未裝（選用） |
| **mattpocock/skills** (`mattpocock`) | 微觀補充 | 補充工程 skill：`grill-with-docs`（逼問+建共識+寫 ADR）、`diagnose`（結構化除錯）、`to-prd`、`improve-codebase-architecture`、`zoom-out`、`handoff` | （依各 skill） | ❌ 未裝（選用；只有 Anthropic 的 `frontend-design`） |

> ⚠️ **誠實標註**：caveman 與 mattpocock/skills 目前**並未安裝**，本指引將它們列為「選用」並附[安裝指引](#7-未安裝工具安裝指引選用)。其餘四者皆已就緒。

---

## 4. 階段 → Skill 路由表 / Phase → Skill Routing

開發的每個階段，對應「該觸發哪個 skill」。**讓意圖對上 skill 就直接用，別手動重做。**

| 階段 Phase | 主 skill / Primary skill | 層 | 說明 |
|---|---|---|---|
| 0 想法澄清 Ideation | gstack `/office-hours`／superpowers `brainstorming` | 流程 | 把模糊想法逼成清楚需求；別急著寫碼 |
| 1 產品/策略規劃 | gstack `/plan-ceo-review`、`/spec` | 巨觀 | 範疇、優先序、把意圖變可執行 spec |
| 2 設計 Design | gstack `/design-consultation`、`/design-shotgun`、`frontend-design` | 巨觀 | 視覺/設計系統探索（有 UI 才需要） |
| 3 工程規劃 Eng plan | gstack `/plan-eng-review` + superpowers `writing-plans` | 雙 | 架構審查 + 寫出可逐步執行的 plan 檔（落 `plans/`） |
| 4 實作 Build | superpowers `test-driven-development`、`executing-plans`、`subagent-driven-development`；gstack `/autoplan` | 微觀 | 紅綠重構、子代理並行、照 plan 執行 |
| 5 除錯 Debug | superpowers `systematic-debugging`；gstack `/investigate` | 微觀 | 先寫重現測試再修；根因調查 |
| 6 審查 Review | superpowers `requesting-code-review`／`receiving-code-review`；gstack `/review`、`/code-review` | 雙 | 落地前審查；收到 review 要技術嚴謹不盲從 |
| 7 測試 QA | gstack `/qa`、`/qa-only`、`webapp-testing` | 巨觀 | 真實瀏覽器 QA、邊測邊修 |
| 8 出貨 Ship | gstack `/ship`、`/land-and-deploy`、`/canary`；superpowers `finishing-a-development-branch`、`verification-before-completion` | 雙 | 完成前先驗證；PR/部署/金絲雀 |
| 9 文件 Docs | gstack `/document-release`、`/document-generate`、`doc-coauthoring` | 巨觀 | 出貨後同步文件 |
| 10 反思 Reflect | gstack `/retro`、`learn` | 巨觀 | 回顧、把學到的存成 learning |
| **全程 Always-on** | 行為層 karpathy 原則；節流 rtk（auto）+ caveman（選用） | 底層 | 自動生效 |

---

## 5. gstack vs superpowers：決策準則 / Which One?

這是使用者最關心的問題。**答案：不二選一，而是合用於不同高度。**

```
        ┌──────────── 一個 Sprint（gstack 外殼）────────────┐
        │  /office-hours → /plan-eng-review → … → /ship    │
        │                       │                          │
        │              每個實作子任務（superpowers 內核）   │
        │              brainstorm→plan→TDD→debug→verify     │
        └──────────────────────────────────────────────────┘
```

- **gstack（巨觀）** 管「整個 sprint」：產品決策、設計評審、QA、發布。它是流程的**外殼**。
- **superpowers（微觀）** 管「每段實作」：在 Build／Debug 階段，每個 coding 子任務都用它的紀律。它是引擎的**內核**。
- 兩者交會在「工程規劃」與「審查」：gstack 提供角色化評審視角，superpowers 提供可逐步執行的 plan 與 TDD。

**被迫只挑一個流程主幹時：**

| 你的專案 | 主幹 | 理由 |
|---|---|---|
| Web / 產品應用（有畫面、要 QA、要部署） | **gstack** | 設計/QA/ship/canary 是它的強項 |
| 後端 / 函式庫 / CLI（正確性優先、無 UI） | **superpowers** | TDD/plan/debug 紀律是它的強項 |
| 混合 / 都有 | **兩者合用**（本樣板預設） | 外殼 gstack + 內核 superpowers |

---

## 6. 端到端範例 / End-to-End Walkthrough

> 仿「心得驗證」敘事：一個 feature 從想法到出貨，實際的 skill 呼叫順序。
> 情境：要在一個 Web app 加上「使用者匯出 CSV」功能。

```
你：「我想加一個讓使用者匯出資料成 CSV 的功能」

0. 想法澄清   → superpowers `brainstorming`
   逼問：匯出哪些欄位？權限？大檔案怎麼辦？→ 釐清需求，不亂假設（karpathy ①）

1. 工程規劃   → gstack `/plan-eng-review` + superpowers `writing-plans`
   審查架構（串流 vs 一次載入）→ 寫出 plan 檔落到 plans/，列出可驗證步驟

2. 實作       → superpowers `test-driven-development` + `executing-plans`
   先寫「空資料 / 含逗號 / 大檔」的失敗測試 → 再實作到綠燈（karpathy ④ 目標驅動）
   只動匯出相關檔案，不順手重構鄰近程式（karpathy ③）

3. 除錯       → superpowers `systematic-debugging`
   逗號跳脫出錯 → 先寫重現測試再修，不亂猜

4. 審查       → gstack `/code-review` 或 superpowers `requesting-code-review`
   落地前掃正確性與可簡化處（karpathy ② 簡單優先）

5. 測試       → gstack `/qa`
   真實瀏覽器點「匯出」、驗證下載檔內容，邊測邊修

6. 出貨       → superpowers `verification-before-completion` → gstack `/ship`
   先真的跑一遍確認可用，再開 PR / 部署

全程：rtk 自動省下所有 git/build/test 指令的輸出 token；想更省可 /caveman 壓縮輸出。
```

**心得重點 / Key takeaways：**
- 不要一開口就寫碼 —— 0、1 階段（brainstorm + plan）省下最多返工。
- TDD 不是負擔，是「目標驅動」的具體化（karpathy ④）：先有可驗證的失敗測試，迴圈就能自走。
- gstack 負責「不漏階段」，superpowers 負責「每段都紮實」，karpathy 負責「每個動作都不犯通病」。

---

## 7. 節流層 / Token-Saving Layer

兩個工具省的是**不同方向**的 token：

### rtk（輸入/工具輸出，已裝 ✅）
- CLI 指令經 hook **自動改寫**（`git status`→`rtk git status`），0 token 開銷，透明省 60–90%。
- 查成效：
  ```bash
  rtk gain              # 總省下的 token
  rtk gain --history    # 各指令使用與省量
  rtk discover          # 從歷史找出更多可省機會
  ```

### caveman（輸出壓縮，未裝、選用 ❌）
- 壓縮 agent **回應輸出** ~65%，去贅詞用片語，保留技術內容。
- 安裝後用法：`/caveman [lite|full|ultra]` 啟用、「normal mode」關閉；`/caveman-stats` 看省量。
- **適用時機**：長對話、reviewer 看摘要即可、CI log 解讀 —— 不適合需要完整解釋的教學情境。

> rtk 省「進來的」、caveman 省「出去的」。兩者互補，可同時開。

---

## 8. 未安裝工具安裝指引（選用）/ Optional Installs

> 以下兩者目前**未安裝**。若要補齊「輸出節流」與「補充工程 skill」兩層，可依官方說明安裝。
> 安裝為改動系統的動作，請自行確認後執行。

### caveman（輸出 token 壓縮）
- 來源：`https://github.com/JuliusBrussee/caveman`（需 Node ≥18）
- Windows 安裝請依該 repo README 的 PowerShell 一鍵指令；安裝後重開 Claude Code，輸入 `/caveman` 驗證。

### mattpocock/skills（補充工程 skill）
- 來源：`https://github.com/mattpocock/skills`
- 提供 `grill-with-docs`、`diagnose`、`to-prd`、`improve-codebase-architecture`、`zoom-out`、`handoff` 等。
- 與既有層的關係：屬**微觀紀律**的補充，與 superpowers 同層；若已用 superpowers 的 `brainstorming`/`systematic-debugging`，可視需求挑 `to-prd`、`improve-codebase-architecture` 等補位。
- 依該 repo README 安裝為 plugin / skills 後，重開 Claude Code 即可在 skill 列表看到。

---

## 9. Quickstart（5 步）

1. **複製本目錄**到新專案位置（連同 `CLAUDE.md`、`docs/`、`plans/`）。
2. 確認全域工具就緒：`rtk --version`（節流）、Claude Code 已載入 superpowers + gstack skills。
3. 在目錄內**用自然語言描述需求**（「我想做…」）。
4. 讓 Claude 照[路由表](#4-階段--skill-路由表)走：想法→計畫→TDD 實作→QA→ship。
5. （選用）長對話想更省 token，開 `/caveman`；隨時 `rtk gain` 看節省成效。

---

## 目錄結構 / Layout

```
.
├── CLAUDE.md      # 專案層設定 + 路由表（Claude 讀這個）
├── README.md      # 本指引
├── docs/          # ADR / 設計文件 / 規格的落點
└── plans/         # writing-plans 與 plan 審查產出的 plan 檔
```

---

## 來源 / Sources
- andrej-karpathy-skills — https://github.com/multica-ai/andrej-karpathy-skills
- superpowers — https://github.com/obra/superpowers
- gstack — https://github.com/garrytan/gstack
- mattpocock/skills — https://github.com/mattpocock/skills
- rtk — https://github.com/rtk-ai/rtk
- caveman — https://github.com/JuliusBrussee/caveman
