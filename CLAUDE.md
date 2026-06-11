@AGENTS.md

# 專案設定 / Project Config — Claude Code 專屬層

> **通用層（行為原則 + 開發工作流 + 慣例 + 指令優先序）已由上方 `@AGENTS.md` 匯入。**
> The universal layer (principles, workflow, conventions, priority) is imported from `@AGENTS.md` above.
> 本檔只放 **Claude Code 專屬的可執行機制（Tier 2）**：skill 路由、rtk 節流。
> This file holds only **Claude Code-exclusive executable mechanisms (Tier 2)**.
> 完整說明見 [README.md](README.md)；多工具配置見 [docs/MULTI-TOOL-SETUP.md](docs/MULTI-TOOL-SETUP.md)。

---

## 四層心智模型中，Claude Code 多了什麼 / What Claude Code Adds

通用層（AGENTS.md）給的是**原則與流程**；Claude Code 在其上多了**可執行自動化**：

| 層 Layer | Claude Code 的對應機制 |
|---|---|
| 巨觀流程 Macro | **gstack** skills（`/office-hours`、`/plan-*-review`、`/design-*`、`/qa`、`/ship`…） |
| 微觀紀律 Micro | **superpowers** skills（`brainstorming`、`writing-plans`、`test-driven-development`…） |
| 節流 Token | **rtk**（輸入，auto hook）+ caveman（輸出，選用） |

**核心規則：** gstack 當 sprint 外殼，superpowers 當每個實作子任務的內核。
其他工具沒有這些 skill，請改照 AGENTS.md §2 的文字版清單手動推進。

---

## 階段 → Skill 路由表 / Phase → Skill Routing（Claude Code only）

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

決策準則（被迫只挑一個流程主幹時）：Web/產品 → **gstack**；後端/函式庫/CLI → **superpowers**。
Pick-one rule: Web/product → gstack; backend/lib/CLI → superpowers.

---

## 節流層 / Token-Saving Layer（Claude Code）

- **rtk**（已裝 v0.42.0）：CLI 指令經 hook 自動改寫，0 token 開銷，透明省 60–90%。`rtk gain` 看成效。
- **caveman**（未裝、選用）：壓縮**輸出** token。安裝後 `/caveman` 啟用。見 README「節流層」。

---

## 工具狀態 / Tools Status

| 工具 | 狀態 | 層 |
|---|---|---|
| `multica-ai/andrej-karpathy-skills` | ✅ 已合入全域 CLAUDE.md（且本 repo `AGENTS.md` 亦有可攜版） | 行為 |
| `obra/superpowers` | ✅ 已裝 plugin | 微觀紀律 |
| `garrytan/gstack` | ✅ 已裝 skills | 巨觀流程 |
| `rtk-ai/rtk` | ✅ 已裝 binary + hook | 節流（輸入） |
| `JuliusBrussee/caveman` | ❌ 未裝（選用） | 節流（輸出） |
| `mattpocock/skills` | ❌ 未裝（選用） | 補充工程 skill |
