# 多工具配置指引 / Multi-Tool Setup Guide

如何讓**不同 AI 編程工具**（Claude Code、Codex、GitHub Copilot、Cursor、Gemini CLI、Google Antigravity、Windsurf…）都套用本專案的開發指引。
How to make the project's dev guidelines apply across **every AI coding tool**.

---

## 1. 核心策略：一個 SSOT + 各工具指向它

**單一真相（Single Source of Truth）= 根目錄的 [`AGENTS.md`](../AGENTS.md)。**

`AGENTS.md` 是 2026 跨工具的 de-facto 標準（已移交 Linux Foundation 治理），幾乎所有 AI 編程工具都原生讀它。
策略很簡單：

```
            ┌─────────────────────┐
            │     AGENTS.md       │  ← 唯一真相（原則 + 工作流）
            │  (root, SSOT)       │
            └──────────┬──────────┘
        ┌──────────────┼───────────────┬──────────────┐
        ▼              ▼               ▼              ▼
   Claude Code     Codex          Copilot        Cursor/Gemini/
   CLAUDE.md       原生讀          .github/        Antigravity/Windsurf
   (@AGENTS.md)    AGENTS.md       copilot-…→指向   原生讀 AGENTS.md
```

- **不要複製、不要 symlink** → 用「原生讀取」或「`@`-import 指向」。複製會漂移（drift），改一邊忘另一邊。
  No copies, no symlinks → native read or `@`-import. Copies drift.
- **維護鐵則：永遠只改 `AGENTS.md`**，其餘檔案都只是指標。

---

## 2. 最重要的觀念：什麼可攜、什麼不可攜（Tier 1 vs Tier 2）

| | Tier 1 — 可攜 | Tier 2 — Claude Code 專屬 |
|---|---|---|
| **內容** | karpathy 4 行為原則 + 工作流文字清單（`AGENTS.md`） | superpowers skills、gstack 斜線指令（`/ship`、`/qa`）、rtk hook、caveman |
| **本質** | 純指令（prose）—— 給 LLM 讀的規則 | 可執行機制 —— Claude Code 的 plugin/skill/hook |
| **跨工具** | ✅ 任何工具都能遵守 | ❌ **只有 Claude Code 會跑**；在 Codex 打 `/ship` 不會有任何效果 |

> **結論**：所有工具都拿到**同一套原則與流程**；差別只在「Claude Code 能自動執行，其他工具是 AI/人照清單手動推進」。
> 你不會因為換工具就失去指引——只會失去「自動化」這層便利。

**離開 Claude Code 會少什麼、怎麼補：**

| Claude Code 有 | 其他工具的替代做法 |
|---|---|
| `brainstorming` / `/office-hours` skill | 照 `AGENTS.md` §2「Think/Plan」清單，主動逼問需求 |
| `writing-plans` skill | 手動在 `plans/` 寫「每步附驗證」的計畫檔 |
| `test-driven-development` skill | 照清單：先寫失敗測試再實作 |
| `/qa`、`webapp-testing` | 手動跑流程／用該工具自己的瀏覽器/測試能力 |
| `/ship`、`/land-and-deploy` | 手動跑測試→驗證→開 PR（照 §2「Ship」清單） |
| rtk（輸入節流）、caveman（輸出節流） | 多數工具有自己的 context 管理；無直接等價物 |

**選用的原生移植（進階）**：若想在他工具補回部分自動化——Cursor 用 `.cursor/rules/*.mdc`、Google Antigravity 用其 Knowledge Base、跨工具可用 **MCP server** 提供共用能力。這些是各工具自家機制，非本專案 skill 的直接搬移。

---

## 3. 各工具配置一覽 / Per-Tool Config Table

| 工具 Tool | 讀取檔 Reads | 你要做的事 What you do |
|---|---|---|
| **Claude Code** | `CLAUDE.md`（頂端 `@AGENTS.md`） | ✅ 已配置，無需動作 |
| **Codex (OpenAI)** | `AGENTS.md`（root / nested / `~/.codex/AGENTS.md`） | ✅ 自動讀，無需動作 |
| **GitHub Copilot** | `AGENTS.md` + `.github/copilot-instructions.md` | ✅ 兩者皆備，無需動作 |
| **Cursor** | `AGENTS.md`（+ `.cursor/rules/*.mdc` 選用） | ✅ 原生讀，無需動作 |
| **Gemini CLI** | `AGENTS.md → GEMINI.md` | ✅ 原生讀，無需動作 |
| **Google Antigravity** | `AGENTS.md → GEMINI.md → 預設` | ✅ 原生讀，無需動作 |
| **Windsurf / aider / opencode** | `AGENTS.md` | ✅ 原生讀，無需動作 |

> 本樣板已備好 `AGENTS.md`、`CLAUDE.md`（含 import）、`.github/copilot-instructions.md`。
> 上述「無需動作」是指**複製本樣板後即生效**——你只要在該工具開啟此專案目錄即可。

---

## 4. 逐工具設定步驟 / Step-by-Step

### Claude Code（已配置）
- `CLAUDE.md` 第一行 `@AGENTS.md` 已把通用層匯入；另有 Tier 2 skill 路由表。開啟專案即生效。

### Codex (OpenAI)
1. 在此專案目錄啟動 Codex（CLI 或 IDE）。
2. Codex 會自動讀根目錄 `AGENTS.md`。無需額外設定。
3. （選用）全域預設可放 `~/.codex/AGENTS.md`；單檔上限 32 KiB。

### GitHub Copilot
1. Copilot coding agent 原生讀 `AGENTS.md`。
2. 部分 VS Code Copilot Chat 版本偏好 `.github/copilot-instructions.md` —— 本樣板已放薄指標指向 `AGENTS.md`。
3. 無需額外設定。

### Cursor
1. Cursor 原生讀根目錄 `AGENTS.md`。
2. （選用）若要 path-scoped 覆寫，新增 `.cursor/rules/*.mdc`，並在其中註明「以 `AGENTS.md` 為準」，避免另寫一份造成漂移。

### Gemini CLI
1. 在專案目錄啟動。讀取順序 `AGENTS.md → GEMINI.md`。
2. （選用）若工具版本只認 `GEMINI.md`，建一個 `GEMINI.md` 內容只寫一行指向 `AGENTS.md`（指標，不複製）。

### Google Antigravity
1. 開啟專案。讀取順序 `AGENTS.md → GEMINI.md → 預設`，所有 agent 啟動前都會讀。
2. （選用）善用 Antigravity 的 **Knowledge Base** 把跨任務學到的規則沉澱、團隊共享——對應 `AGENTS.md` §2「Reflect」。

### Windsurf / aider / opencode
- 皆原生 fallback 到 `AGENTS.md`。開啟專案即生效。

---

## 5. 維護 / Maintenance

1. **只改 `AGENTS.md`**。所有工具的設定檔都指向它，不複製內容。
2. 改 Tier 2（Claude 專屬 skill 路由、rtk）才動 `CLAUDE.md`。
3. 定期確認 `.github/copilot-instructions.md`、（若有）`GEMINI.md` 仍只是「指標」而非複製品 —— 防漂移。

---

## 來源 / Sources
- AGENTS.md 標準 — https://agents.md/
- Copilot 支援 AGENTS.md — https://github.blog/changelog/2025-08-28-copilot-coding-agent-now-supports-agents-md-custom-instructions/
- VS Code 自訂指引 — https://code.visualstudio.com/docs/agent-customization/custom-instructions
- Google Antigravity — https://antigravity.google/docs/agent-manager
