# 專案設定 / Project Config — AI 代理編程樣板

> 本檔是「樣板專案」的 Claude Code 專案層設定。複製此目錄到新專案即可沿用。
> This is the project-level Claude Code config for the agent-coding template. Copy this folder to bootstrap a new project.
> 完整說明見 [README.md](README.md)。/ See [README.md](README.md) for the full guide.

---

## 1. 指令優先序 / Instruction Priority

1. **使用者明確指令**（本檔、直接請求）— 最高 / User explicit instructions — highest
2. **Skills**（superpowers、gstack…）— 覆寫預設行為 / override default behavior
3. **預設系統行為** — 最低 / default — lowest

使用者說 WHAT，skill 決定 HOW。「加 X / 修 Y」不代表略過工作流程。
User says WHAT; skills decide HOW. "Add X / Fix Y" never means skip the workflow.

---

## 2. 四層心智模型 / The Four-Layer Model

這些工具**不互相競爭，而是疊在不同高度**。Not competitors — stacked at different altitudes.

| 層 Layer | 工具 Tool | 角色 Role |
|---|---|---|
| 行為 Behavior | andrej-karpathy 4 原則（全域 `~/.claude/CLAUDE.md`，always-on） | 每個動作都遵守 |
| 巨觀流程 Macro | **gstack** | 管「整個 sprint」的產品生命週期 |
| 微觀紀律 Micro | **superpowers** | 管「每段實作」的工程紀律 |
| 節流 Token | **rtk**（輸入，auto）+ caveman（輸出，選用） | 底層省 token |

**核心規則 / Core rule：** gstack 當 sprint 外殼，superpowers 當每個實作子任務的內核。
gstack is the sprint shell; superpowers is the engine inside every coding sub-task.

---

## 3. 階段 → Skill 路由表 / Phase → Skill Routing

> 當「使用者意圖」對上某 skill 的目標時，**直接用該 skill**，不要手動重做。
> When user intent matches a skill's goal, **use that skill** — don't hand-roll it.

| 階段 Phase | 主 skill / Primary skill |
|---|---|
| 0 想法澄清 Ideation | gstack `/office-hours` ／ superpowers `brainstorming` |
| 1 產品/策略規劃 Product plan | gstack `/plan-ceo-review`、`/spec` |
| 2 設計 Design | gstack `/design-consultation`、`/design-shotgun`、`frontend-design` |
| 3 工程規劃 Eng plan | gstack `/plan-eng-review` + superpowers `writing-plans` |
| 4 實作 Build | superpowers `test-driven-development`、`executing-plans`、`subagent-driven-development`；gstack `/autoplan` |
| 5 除錯 Debug | superpowers `systematic-debugging`；gstack `/investigate` |
| 6 審查 Review | superpowers `requesting-code-review`／`receiving-code-review`；gstack `/review`、`/code-review` |
| 7 測試 QA | gstack `/qa`、`/qa-only`、`webapp-testing` |
| 8 出貨 Ship | gstack `/ship`、`/land-and-deploy`、`/canary`；superpowers `finishing-a-development-branch`、`verification-before-completion` |
| 9 文件 Docs | gstack `/document-release`、`/document-generate`、`doc-coauthoring` |
| 10 反思 Reflect | gstack `/retro`、`learn` |
| 全程 Always-on | 行為層 karpathy 原則；節流 rtk（auto）+ caveman（選用） |

決策準則（被迫只挑一個流程主幹時）：Web/產品 → **gstack**；後端/函式庫/CLI → **superpowers**。
Pick-one rule: Web/product → gstack; backend/lib/CLI → superpowers.

---

## 4. 目錄慣例 / Directory Conventions

- `plans/` — superpowers `writing-plans` 與 gstack plan 審查產出的 plan 檔 / plan files
- `docs/` — ADR、設計文件、規格 / ADRs, design docs, specs
- 程式碼依專案語言自行新增（`src/` 等）/ source dirs added per project language

---

## 5. 節流層 / Token-Saving Layer

- **rtk**（已裝 v0.42.0）：CLI 指令經 hook 自動改寫，0 token 開銷，透明省 60–90%。`rtk gain` 看成效。
  rtk auto-rewrites CLI commands via hook (already installed). `rtk gain` shows savings.
- **caveman**（未裝、選用）：壓縮**輸出** token。安裝後 `/caveman` 啟用。見 README「節流層」。
  caveman compresses **output** tokens (not installed; optional). See README.

---

## 6. 補充工具狀態 / Supplementary Tools Status

| 工具 | 狀態 | 備註 |
|---|---|---|
| `multica-ai/andrej-karpathy-skills` | ✅ 已合入全域 CLAUDE.md | 行為層 |
| `obra/superpowers` | ✅ 已裝 plugin | 微觀紀律 |
| `garrytan/gstack` | ✅ 已裝 skills | 巨觀流程 |
| `rtk-ai/rtk` | ✅ 已裝 binary + hook | 節流（輸入） |
| `JuliusBrussee/caveman` | ❌ 未裝（選用） | 節流（輸出）— 安裝指引見 README |
| `mattpocock/skills` | ❌ 未裝（選用） | 補充工程 skill — 安裝指引見 README |
