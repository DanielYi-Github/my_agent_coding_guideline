#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ── Colors ──
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# ── Banner ──
show_banner() {
    echo ""
    echo -e "${BOLD}=== AI Agent Coding Guideline — Setup ===${NC}"
    echo ""
    echo "Interactive installer for AI coding tools and project template."
    echo "Supports: Claude Code, GitHub Copilot, Codex, Cursor, Gemini CLI,"
    echo "          Google Antigravity, Windsurf, aider, opencode"
    echo ""
}

# ── Prompts ──
prompt_mode() {
    echo -e "${CYAN}Choose mode:${NC}"
    echo "  [1] Install global tools (one-time per machine)"
    echo "  [2] Apply template to an existing project"
    echo "  [3] Both (install + apply)"
    echo ""
    read -rp "Enter choice [1/2/3]: " MODE
    case "$MODE" in
        1|2|3) ;;
        *) echo -e "${RED}Invalid choice. Exiting.${NC}"; exit 1 ;;
    esac
    echo ""
}

prompt_tools() {
    echo -e "${CYAN}Which AI coding tools do you use?${NC}"
    echo "  [1] Claude Code (CLI / VS Code extension)"
    echo "  [2] GitHub Copilot"
    echo "  [3] Codex (OpenAI)"
    echo "  [4] Cursor"
    echo "  [5] Gemini CLI / Google Antigravity"
    echo "  [6] Windsurf / aider / opencode"
    echo ""
    echo "Enter comma-separated numbers, or 'all':"
    read -rp "> " TOOL_INPUT

    SELECTED_TOOLS=()
    if [[ "$TOOL_INPUT" == "all" ]]; then
        SELECTED_TOOLS=(1 2 3 4 5 6)
    else
        IFS=',' read -ra SELECTED_TOOLS <<< "$TOOL_INPUT"
        for i in "${!SELECTED_TOOLS[@]}"; do
            SELECTED_TOOLS[$i]=$(echo "${SELECTED_TOOLS[$i]}" | tr -d ' ')
        done
    fi
    echo ""
}

# ── Platform Detection ──
detect_platform() {
    case "$(uname -s)" in
        Darwin*)              PLATFORM="macos" ;;
        Linux*)               PLATFORM="linux" ;;
        MINGW*|MSYS*|CYGWIN*) PLATFORM="windows" ;;
        *)                    PLATFORM="unknown" ;;
    esac
}

# ── Install: gstack ──
install_gstack() {
    local gstack_dir="$HOME/.claude/skills/gstack"
    if [[ -d "$gstack_dir" ]]; then
        echo -e "${GREEN}  ✓ gstack already installed at $gstack_dir${NC}"
        return
    fi
    echo -e "${YELLOW}  → Installing gstack...${NC}"
    mkdir -p "$HOME/.claude/skills"
    git clone --single-branch --depth 1 https://github.com/garrytan/gstack.git "$gstack_dir"
    if [[ -f "$gstack_dir/setup" ]]; then
        (cd "$gstack_dir" && ./setup)
    fi
    echo -e "${GREEN}  ✓ gstack installed${NC}"
}

# ── Install: rtk ──
install_rtk() {
    if command -v rtk &>/dev/null; then
        local ver
        ver="$(rtk --version 2>/dev/null || echo 'version unknown')"
        echo -e "${GREEN}  ✓ rtk already installed ($ver)${NC}"
        return
    fi

    detect_platform
    echo -e "${YELLOW}  → Installing rtk...${NC}"

    case "$PLATFORM" in
        macos)
            if command -v brew &>/dev/null; then
                brew install rtk
            else
                curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh
            fi
            ;;
        linux)
            curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh
            ;;
        windows)
            echo -e "${YELLOW}  ⚠ Windows detected via Git Bash / MSYS.${NC}"
            echo "    Please download rtk manually:"
            echo "    https://github.com/rtk-ai/rtk/releases"
            echo "    Get rtk-x86_64-pc-windows-msvc.zip, extract, add rtk.exe to PATH."
            return
            ;;
        *)
            echo -e "${RED}  ✗ Unknown platform. Please install rtk manually:${NC}"
            echo "    https://github.com/rtk-ai/rtk/releases"
            return
            ;;
    esac

    if command -v rtk &>/dev/null; then
        rtk init -g
        echo -e "${GREEN}  ✓ rtk installed and global hook initialized${NC}"
    fi
}

# ── Print: Claude Code manual steps ──
print_claude_manual_steps() {
    echo ""
    echo -e "${YELLOW}  ── Manual steps (run inside Claude Code) ──${NC}"
    echo ""
    echo "  1. Install superpowers plugin:"
    echo "     /plugin install superpowers@claude-plugins-official"
    echo ""
    echo "  2. (Optional) Install karpathy-skills plugin:"
    echo "     /plugin marketplace add forrestchang/andrej-karpathy-skills"
    echo "     /plugin install andrej-karpathy-skills@karpathy-skills"
    echo ""
    echo "  3. (Optional) Install caveman for output token compression:"
    echo "     See: https://github.com/JuliusBrussee/caveman"
    echo ""
    echo -e "${YELLOW}  Restart Claude Code after installation.${NC}"
    echo ""
}

# ── Install dispatch ──
install_tools() {
    echo -e "${BOLD}── Global Tool Installation ──${NC}"
    echo ""

    for tool in "${SELECTED_TOOLS[@]}"; do
        case "$tool" in
            1)
                echo -e "${BLUE}[Claude Code]${NC}"
                install_gstack
                install_rtk
                print_claude_manual_steps
                ;;
            2)
                echo -e "${BLUE}[GitHub Copilot]${NC}"
                echo -e "${GREEN}  ✓ No global installation needed. Copilot reads AGENTS.md natively.${NC}"
                echo ""
                ;;
            3)
                echo -e "${BLUE}[Codex]${NC}"
                echo -e "${GREEN}  ✓ No global installation needed. Codex reads AGENTS.md natively.${NC}"
                echo ""
                ;;
            4)
                echo -e "${BLUE}[Cursor]${NC}"
                echo -e "${GREEN}  ✓ No global installation needed. Cursor reads AGENTS.md natively.${NC}"
                echo ""
                ;;
            5)
                echo -e "${BLUE}[Gemini CLI / Google Antigravity]${NC}"
                echo -e "${GREEN}  ✓ No global installation needed. These tools read AGENTS.md natively.${NC}"
                echo ""
                ;;
            6)
                echo -e "${BLUE}[Windsurf / aider / opencode]${NC}"
                echo -e "${GREEN}  ✓ No global installation needed. These tools read AGENTS.md natively.${NC}"
                echo ""
                ;;
        esac
    done
}

# ── Safe Copy ──
safe_copy() {
    local src="$1"
    local dest="$2"
    local filename
    filename="$(basename "$dest")"

    if [[ ! -f "$src" ]]; then
        echo -e "${RED}  ✗ Source not found: $src${NC}"
        return 1
    fi

    mkdir -p "$(dirname "$dest")"

    if [[ -f "$dest" ]]; then
        if diff -q "$src" "$dest" &>/dev/null; then
            echo -e "${GREEN}  ✓ $filename — already up to date${NC}"
            return
        fi

        echo -e "${YELLOW}  ⚠ $filename already exists and differs.${NC}"
        read -rp "    Overwrite? [y]es / [n]o / [d]iff: " choice
        case "$choice" in
            y|Y)
                cp "$dest" "${dest}.bak"
                echo "    (backed up to ${filename}.bak)"
                cp "$src" "$dest"
                echo -e "${GREEN}  ✓ $filename — updated${NC}"
                ;;
            d|D)
                echo ""
                diff -u "$dest" "$src" || true
                echo ""
                read -rp "    Overwrite now? [y/n]: " confirm
                if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                    cp "$dest" "${dest}.bak"
                    cp "$src" "$dest"
                    echo -e "${GREEN}  ✓ $filename — updated${NC}"
                else
                    echo "    Skipped."
                fi
                ;;
            *)
                echo "    Skipped."
                ;;
        esac
    else
        cp "$src" "$dest"
        echo -e "${GREEN}  ✓ $filename — created${NC}"
    fi
}

# ── Apply Template ──
apply_template() {
    local target_dir="$1"

    if [[ ! -d "$target_dir" ]]; then
        echo -e "${RED}Directory does not exist: $target_dir${NC}"
        read -rp "Create it? [y/n]: " create
        if [[ "$create" == "y" || "$create" == "Y" ]]; then
            mkdir -p "$target_dir"
        else
            echo "Exiting."
            exit 1
        fi
    fi

    echo -e "${BOLD}── Applying Template to: $target_dir ──${NC}"
    echo ""

    # ── Core files (all tools) ──
    echo -e "${CYAN}Core files (all tools):${NC}"
    safe_copy "$SCRIPT_DIR/AGENTS.md" "$target_dir/AGENTS.md"

    if [[ ! -d "$target_dir/plans" ]]; then
        mkdir -p "$target_dir/plans"
        touch "$target_dir/plans/.gitkeep"
        echo -e "${GREEN}  ✓ plans/ — created${NC}"
    else
        echo -e "${GREEN}  ✓ plans/ — already exists${NC}"
    fi
    echo ""

    # ── Tool-specific files ──
    for tool in "${SELECTED_TOOLS[@]}"; do
        case "$tool" in
            1)
                echo -e "${CYAN}Claude Code files:${NC}"
                safe_copy "$SCRIPT_DIR/CLAUDE.md" "$target_dir/CLAUDE.md"
                echo ""
                ;;
            2)
                echo -e "${CYAN}GitHub Copilot files:${NC}"
                safe_copy "$SCRIPT_DIR/.github/copilot-instructions.md" "$target_dir/.github/copilot-instructions.md"
                echo ""
                ;;
            5)
                echo -e "${CYAN}Gemini CLI / Antigravity files:${NC}"
                safe_copy "$SCRIPT_DIR/GEMINI.md" "$target_dir/GEMINI.md"
                echo ""
                ;;
        esac
    done

    echo -e "${GREEN}${BOLD}Template applied successfully!${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. cd $target_dir"
    echo "  2. Review and customize AGENTS.md for your project"

    local has_claude=false
    for t in "${SELECTED_TOOLS[@]}"; do
        [[ "$t" == "1" ]] && has_claude=true
    done
    if $has_claude; then
        echo "  3. Review CLAUDE.md — adjust the skill routing table if needed"
    fi

    echo "  4. Start describing your intent to the AI tool"
    echo ""
}

# ── Main ──
main() {
    show_banner

    if [[ ! -f "$SCRIPT_DIR/AGENTS.md" ]]; then
        echo -e "${RED}Error: AGENTS.md not found in $SCRIPT_DIR${NC}"
        echo "Please run this script from the template repository root."
        exit 1
    fi

    prompt_mode
    prompt_tools

    if [[ "$MODE" == "1" || "$MODE" == "3" ]]; then
        install_tools
    fi

    if [[ "$MODE" == "2" || "$MODE" == "3" ]]; then
        read -rp "Target project directory: " TARGET_DIR
        TARGET_DIR="${TARGET_DIR/#\~/$HOME}"
        echo ""
        apply_template "$TARGET_DIR"
    fi

    echo -e "${GREEN}${BOLD}Done!${NC}"
}

main "$@"
