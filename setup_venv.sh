#!/bin/bash
set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

error() {
    echo -e "${RED}❌ Error: $1${NC}" >&2
    exit 1
}

success() {
    echo -e "${GREEN}✅ $1${NC}"
}

warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

check_dependencies() {

    if ! command -v sudo >/dev/null 2>&1; then
        warning "sudo not found - some operations might require root privileges"
    fi

    if command -v apt-get >/dev/null 2>&1; then
        PKG_MANAGER="apt-get"
    elif command -v dnf >/dev/null 2>&1; then
        PKG_MANAGER="dnf"
    elif command -v yum >/dev/null 2>&1; then
        PKG_MANAGER="yum"
    elif command -v brew >/dev/null 2>&1; then
        PKG_MANAGER="brew"
    else
        error "Could not detect package manager"
    fi
}

install_python() {
    if ! command -v python3 &>/dev/null; then
        warning "Python3 not found. Attempting installation..."
        
        case $PKG_MANAGER in
            "apt-get")
                sudo apt-get update && sudo apt-get install -y python3 python3-venv python3-pip
                ;;
            "dnf"|"yum")
                sudo $PKG_MANAGER install -y python3 python3-virtualenv python3-pip
                ;;
            "brew")
                brew install python@3.10
                ;;
            *)
                error "Unsupported package manager for Python installation"
                ;;
        esac

        if ! command -v python3 &>/dev/null; then
            error "Failed to install Python3"
        fi
        success "Python3 installed successfully"
    fi

    if ! python3 -c "import ensurepip, venv" 2>/dev/null; then
        warning "Python virtual environment module missing. Installing..."
        case $PKG_MANAGER in
            "apt-get") sudo apt-get install -y python3-venv ;;
            "dnf"|"yum") sudo $PKG_MANAGER install -y python3-virtualenv ;;
            *) error "Please install python3-venv manually for your distribution" ;;
        esac
    fi
}

setup_venv() {
    local VENV_DIR="$HOME/venv"
    
    if [ -d "$VENV_DIR" ] && [ ! -f "$VENV_DIR/bin/activate" ]; then
        warning "Found incomplete virtual environment. Cleaning up..."
        rm -rf "$VENV_DIR"
    fi

    if [ ! -d "$VENV_DIR" ]; then
        echo -e "\nCreating Python virtual environment..."
        if ! python3 -m venv "$VENV_DIR"; then
            error "Failed to create virtual environment"
        fi
        success "Virtual environment created at $VENV_DIR"
    fi

    echo -e "\nUpdating Python package manager..."
    if ! "$VENV_DIR/bin/python" -m pip install --upgrade pip setuptools wheel; then
        error "Failed to update pip"
    fi
    success "Pip upgraded to latest version"
}

configure_shell() {
    local SHELL_CONFIG
    local SHELL_TYPE

    case $SHELL in
        *zsh*)  SHELL_TYPE="zsh"; SHELL_CONFIG="$HOME/.zshrc" ;;
        *bash*) SHELL_TYPE="bash"; SHELL_CONFIG="$HOME/.bashrc" ;;
        *fish*) SHELL_TYPE="fish"; SHELL_CONFIG="$HOME/.config/fish/config.fish" ;;
        *)      error "Unsupported shell: $SHELL" ;;
    esac

    if [ ! -f "$SHELL_CONFIG" ]; then
        warning "Creating new shell config: $SHELL_CONFIG"
        touch "$SHELL_CONFIG"
    fi

    if [ ! -f "$SHELL_CONFIG.bak" ]; then
        cp "$SHELL_CONFIG" "$SHELL_CONFIG.bak"
        success "Created backup of shell config: $SHELL_CONFIG.bak"
    fi

    case $SHELL_TYPE in
        "zsh")
            configure_zsh
            ;;
        "bash")
            configure_bash
            ;;
        "fish")
            configure_fish
            ;;
    esac

    success "Shell configuration updated for $SHELL_TYPE"
}

configure_zsh() {
    local CONFIG_LINES=(
        '# Python Virtual Environment Auto-activation'
        'export VIRTUAL_ENV_DISABLE_PROMPT=1'
        'source $HOME/venv/bin/activate'
    )

    for line in "${CONFIG_LINES[@]}"; do
        if ! grep -qF "$line" "$SHELL_CONFIG"; then
            echo "$line" >> "$SHELL_CONFIG"
        fi
    done

    if [ -f "$HOME/.oh-my-zsh/oh-my-zsh.sh" ]; then
        warning "Detected Oh My Zsh - ensuring compatibility"
        if ! grep -q 'source $HOME/venv/bin/activate' "$SHELL_CONFIG"; then
            echo 'source $HOME/venv/bin/activate' >> "$SHELL_CONFIG"
        fi
    fi
}

configure_bash() {
    local CONFIG_LINES=(
        '# Python Virtual Environment Auto-activation'
        'export VIRTUAL_ENV_DISABLE_PROMPT=1'
        'source $HOME/venv/bin/activate'
    )

    for line in "${CONFIG_LINES[@]}"; do
        if ! grep -qF "$line" "$SHELL_CONFIG"; then
            echo "$line" >> "$SHELL_CONFIG"
        fi
    done
}

configure_fish() {
    local CONFIG_LINES=(
        '# Python Virtual Environment Auto-activation'
        'set -gx VIRTUAL_ENV_DISABLE_PROMPT 1'
        'source $HOME/venv/bin/activate.fish'
    )

    for line in "${CONFIG_LINES[@]}"; do
        if ! grep -qF "$line" "$SHELL_CONFIG"; then
            echo "$line" >> "$SHELL_CONFIG"
        fi
    done
}

finalize() {
    echo -e "\n${GREEN}🎉 Setup completed successfully!${NC}"
    echo -e "To start using your environment:"
    echo -e "1. Open a new terminal window"
    echo -e "2. Verify activation with: ${YELLOW}which python${NC}"
    echo -e "3. Check Python version: ${YELLOW}python --version${NC}"
}

check_dependencies
install_python
setup_venv
configure_shell
finalize
