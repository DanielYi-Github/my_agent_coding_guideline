#Requires -Version 5.1

$ScriptDir = $PSScriptRoot

# ── Banner ──
function Show-Banner {
    Write-Host ""
    Write-Host "=== AI Agent Coding Guideline - Setup ===" -ForegroundColor White
    Write-Host ""
    Write-Host "Interactive installer for AI coding tools and project template."
    Write-Host "Supports: Claude Code, GitHub Copilot, Codex, Cursor, Gemini CLI,"
    Write-Host "          Google Antigravity, Windsurf, aider, opencode"
    Write-Host ""
}

# ── Prompts ──
function Read-Mode {
    Write-Host "Choose mode:" -ForegroundColor Cyan
    Write-Host "  [1] Install global tools (one-time per machine)"
    Write-Host "  [2] Apply template to an existing project"
    Write-Host "  [3] Both (install + apply)"
    Write-Host ""
    $mode = Read-Host "Enter choice [1/2/3]"
    if ($mode -notin @("1", "2", "3")) {
        Write-Host "Invalid choice. Exiting." -ForegroundColor Red
        exit 1
    }
    Write-Host ""
    return $mode
}

function Read-Tools {
    Write-Host "Which AI coding tools do you use?" -ForegroundColor Cyan
    Write-Host "  [1] Claude Code (CLI / VS Code extension)"
    Write-Host "  [2] GitHub Copilot"
    Write-Host "  [3] Codex (OpenAI)"
    Write-Host "  [4] Cursor"
    Write-Host "  [5] Gemini CLI / Google Antigravity"
    Write-Host "  [6] Windsurf / aider / opencode"
    Write-Host ""
    Write-Host "Enter comma-separated numbers, or 'all':"
    $toolInput = Read-Host ">"

    if ($toolInput -eq "all") {
        return @("1", "2", "3", "4", "5", "6")
    }

    $tools = $toolInput -split "," | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }
    return @($tools)
}

# ── Install: gstack ──
function Install-Gstack {
    $gstackDir = Join-Path $env:USERPROFILE ".claude\skills\gstack"
    if (Test-Path $gstackDir) {
        Write-Host "  OK gstack already installed at $gstackDir" -ForegroundColor Green
        return
    }

    Write-Host "  -> Installing gstack..." -ForegroundColor Yellow
    $skillsDir = Join-Path $env:USERPROFILE ".claude\skills"
    if (-not (Test-Path $skillsDir)) {
        New-Item -ItemType Directory -Force -Path $skillsDir | Out-Null
    }

    git clone --single-branch --depth 1 https://github.com/garrytan/gstack.git $gstackDir

    Write-Host "  OK gstack cloned" -ForegroundColor Green
    Write-Host ""
    Write-Host "  !! gstack setup requires bash. Please run in WSL or Git Bash:" -ForegroundColor Yellow
    Write-Host "     cd ~/.claude/skills/gstack && ./setup"
    Write-Host ""
}

# ── Install: rtk ──
function Install-Rtk {
    try { $rtkCmd = Get-Command rtk -ErrorAction Stop } catch { $rtkCmd = $null }
    if ($null -ne $rtkCmd) {
        Write-Host "  OK rtk already installed" -ForegroundColor Green
        return
    }

    Write-Host "  -> rtk not found. Please install manually:" -ForegroundColor Yellow
    Write-Host "     Download from: https://github.com/rtk-ai/rtk/releases"
    Write-Host "     Get: rtk-x86_64-pc-windows-msvc.zip"
    Write-Host "     Extract and add rtk.exe to your PATH."
    Write-Host ""
    Write-Host "     After installation, run:" -ForegroundColor Yellow
    Write-Host "     rtk init -g"
    Write-Host ""
}

# ── Print: Claude Code manual steps ──
function Show-ClaudeManualSteps {
    Write-Host ""
    Write-Host "  -- Manual steps (run inside Claude Code) --" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "  1. Install superpowers plugin:"
    Write-Host "     /plugin install superpowers@claude-plugins-official"
    Write-Host ""
    Write-Host "  2. (Optional) Install karpathy-skills plugin:"
    Write-Host "     /plugin marketplace add forrestchang/andrej-karpathy-skills"
    Write-Host "     /plugin install andrej-karpathy-skills@karpathy-skills"
    Write-Host ""
    Write-Host "  3. (Optional) Install caveman for output token compression:"
    Write-Host "     See: https://github.com/JuliusBrussee/caveman"
    Write-Host ""
    Write-Host "  Restart Claude Code after installation." -ForegroundColor Yellow
    Write-Host ""
}

# ── Install dispatch ──
function Install-Tools {
    param([array]$Tools)

    Write-Host "-- Global Tool Installation --" -ForegroundColor White
    Write-Host ""

    foreach ($tool in $Tools) {
        switch ($tool.ToString().Trim()) {
            "1" {
                Write-Host "[Claude Code]" -ForegroundColor Blue
                Install-Gstack
                Install-Rtk
                Show-ClaudeManualSteps
            }
            "2" {
                Write-Host "[GitHub Copilot]" -ForegroundColor Blue
                Write-Host "  OK No global installation needed. Copilot reads AGENTS.md natively." -ForegroundColor Green
                Write-Host ""
            }
            "3" {
                Write-Host "[Codex]" -ForegroundColor Blue
                Write-Host "  OK No global installation needed. Codex reads AGENTS.md natively." -ForegroundColor Green
                Write-Host ""
            }
            "4" {
                Write-Host "[Cursor]" -ForegroundColor Blue
                Write-Host "  OK No global installation needed. Cursor reads AGENTS.md natively." -ForegroundColor Green
                Write-Host ""
            }
            "5" {
                Write-Host "[Gemini CLI / Google Antigravity]" -ForegroundColor Blue
                Write-Host "  OK No global installation needed. These tools read AGENTS.md natively." -ForegroundColor Green
                Write-Host ""
            }
            "6" {
                Write-Host "[Windsurf / aider / opencode]" -ForegroundColor Blue
                Write-Host "  OK No global installation needed. These tools read AGENTS.md natively." -ForegroundColor Green
                Write-Host ""
            }
        }
    }
}

# ── Safe Copy ──
function Copy-SafeFile {
    param(
        [string]$Source,
        [string]$Destination
    )

    $fileName = Split-Path $Destination -Leaf

    if (-not (Test-Path $Source)) {
        Write-Host "  X Source not found: $Source" -ForegroundColor Red
        return
    }

    $destDir = Split-Path $Destination -Parent
    if (-not (Test-Path $destDir)) {
        New-Item -ItemType Directory -Force -Path $destDir | Out-Null
    }

    if (Test-Path $Destination) {
        $srcContent = Get-Content $Source -Raw -Encoding UTF8
        $destContent = Get-Content $Destination -Raw -Encoding UTF8

        if ($srcContent -eq $destContent) {
            Write-Host "  OK $fileName -- already up to date" -ForegroundColor Green
            return
        }

        Write-Host "  !! $fileName already exists and differs." -ForegroundColor Yellow
        $choice = Read-Host "    Overwrite? [y]es / [n]o / [d]iff"

        switch ($choice.ToLower()) {
            "y" {
                Copy-Item $Destination "${Destination}.bak" -Force
                Write-Host "    (backed up to ${fileName}.bak)"
                Copy-Item $Source $Destination -Force
                Write-Host "  OK $fileName -- updated" -ForegroundColor Green
            }
            "d" {
                Write-Host ""
                $srcLines = Get-Content $Source -Encoding UTF8
                $destLines = Get-Content $Destination -Encoding UTF8
                $diffs = Compare-Object $destLines $srcLines
                foreach ($d in $diffs) {
                    if ($d.SideIndicator -eq "=>") {
                        Write-Host ("+ " + $d.InputObject) -ForegroundColor Green
                    } else {
                        Write-Host ("- " + $d.InputObject) -ForegroundColor Red
                    }
                }
                Write-Host ""
                $confirm = Read-Host "    Overwrite now? [y/n]"
                if ($confirm.ToLower() -eq "y") {
                    Copy-Item $Destination "${Destination}.bak" -Force
                    Copy-Item $Source $Destination -Force
                    Write-Host "  OK $fileName -- updated" -ForegroundColor Green
                } else {
                    Write-Host "    Skipped."
                }
            }
            default {
                Write-Host "    Skipped."
            }
        }
    } else {
        Copy-Item $Source $Destination -Force
        Write-Host "  OK $fileName -- created" -ForegroundColor Green
    }
}

# ── Apply Template ──
function Apply-Template {
    param(
        [string]$TargetDir,
        [array]$Tools
    )

    if (-not (Test-Path $TargetDir)) {
        Write-Host "Directory does not exist: $TargetDir" -ForegroundColor Red
        $create = Read-Host "Create it? [y/n]"
        if ($create.ToLower() -eq "y") {
            New-Item -ItemType Directory -Force -Path $TargetDir | Out-Null
        } else {
            Write-Host "Exiting."
            exit 1
        }
    }

    Write-Host "-- Applying Template to: $TargetDir --" -ForegroundColor White
    Write-Host ""

    # ── Core files (all tools) ──
    Write-Host "Core files (all tools):" -ForegroundColor Cyan
    Copy-SafeFile -Source (Join-Path $ScriptDir "AGENTS.md") -Destination (Join-Path $TargetDir "AGENTS.md")

    $plansDir = Join-Path $TargetDir "plans"
    if (-not (Test-Path $plansDir)) {
        New-Item -ItemType Directory -Force -Path $plansDir | Out-Null
        "" | Out-File -FilePath (Join-Path $plansDir ".gitkeep") -Encoding utf8 -NoNewline
        Write-Host "  OK plans/ -- created" -ForegroundColor Green
    } else {
        Write-Host "  OK plans/ -- already exists" -ForegroundColor Green
    }
    Write-Host ""

    # ── Tool-specific files ──
    foreach ($tool in $Tools) {
        switch ($tool.ToString().Trim()) {
            "1" {
                Write-Host "Claude Code files:" -ForegroundColor Cyan
                Copy-SafeFile -Source (Join-Path $ScriptDir "CLAUDE.md") -Destination (Join-Path $TargetDir "CLAUDE.md")
                Write-Host ""
            }
            "2" {
                Write-Host "GitHub Copilot files:" -ForegroundColor Cyan
                Copy-SafeFile -Source (Join-Path $ScriptDir ".github\copilot-instructions.md") -Destination (Join-Path $TargetDir ".github\copilot-instructions.md")
                Write-Host ""
            }
            "5" {
                Write-Host "Gemini CLI / Antigravity files:" -ForegroundColor Cyan
                Copy-SafeFile -Source (Join-Path $ScriptDir "GEMINI.md") -Destination (Join-Path $TargetDir "GEMINI.md")
                Write-Host ""
            }
        }
    }

    Write-Host "Template applied successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Next steps:"
    Write-Host "  1. cd $TargetDir"
    Write-Host "  2. Review and customize AGENTS.md for your project"
    if ($Tools -contains "1") {
        Write-Host "  3. Review CLAUDE.md -- adjust the skill routing table if needed"
    }
    Write-Host "  4. Start describing your intent to the AI tool"
    Write-Host ""
}

# ── Main ──
Show-Banner

if (-not (Test-Path (Join-Path $ScriptDir "AGENTS.md"))) {
    Write-Host "Error: AGENTS.md not found in $ScriptDir" -ForegroundColor Red
    Write-Host "Please run this script from the template repository root."
    exit 1
}

$mode = Read-Mode
$tools = Read-Tools

if ($mode -in @("1", "3")) {
    Install-Tools -Tools $tools
}

if ($mode -in @("2", "3")) {
    $targetDir = Read-Host "Target project directory"
    Write-Host ""
    Apply-Template -TargetDir $targetDir -Tools $tools
}

Write-Host "Done!" -ForegroundColor Green
