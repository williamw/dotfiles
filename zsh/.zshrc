export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="frisk"

# Override default behaviors:
# CASE_SENSITIVE="true"
# HYPHEN_INSENSITIVE="true"
# ENABLE_CORRECTION="true"
# export LANG=en_US.UTF-8

plugins=(
	dotenv
	git
	macos
)

source $ZSH/oh-my-zsh.sh

if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='nvim'
 else
   export EDITOR='nvim'
 fi

# cargo
export PATH=$HOME/.cargo/bin:$PATH

# homebrew (macOS only)
[[ "$OSTYPE" == "darwin"* ]] && export PATH="/opt/homebrew/bin:$PATH"

#nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
nvm use --silent default

# alias claude="/Users/billw/.claude/local/claude"
export PATH="$HOME/.local/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
alias pn=pnpm
# pnpm end
