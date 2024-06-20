# Export path
export PATH=$HOME/bin:/usr/local/bin:$HOME/.local/bin:$PATH
export PYENV_ROOT="$HOME/.pyenv"
export PATH=$HOME/.local/share/bob/nvim-bin:$PATH

[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.config/.oh-my-zsh"
export ZSH_CUSTOM="$HOME/.config/zsh-custom"

# Theme
ZSH_THEME=""
source $ZSH_CUSTOM/catppuccin_macchiato-zsh-syntax-highlighting.zsh

# Plugins
plugins=(git zsh-nvm zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# Init different stuff
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
eval "$(pyenv init -)"

# Aliases
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias cat='bat'
alias ls='exa -l'
alias random-tag='(echo $RANDOM | md5sum | head -c 20)'
alias force-build='(devspace deploy --var BUILD_NAME=$(random-tag) --force-build)'

# Env vars
export COMPOSE_DOCKER_CLI_BUILD=1
export DOCKER_BUILDKIT=1

# other stuff
source <(devspace completion zsh)


# Neovim config switcher


vv() {
  # Assumes all configs exist in directories named ~/.config/nvim-*
  local config=$(fd --max-depth 1 --glob 'nvim-*' ~/.config | fzf --prompt="Neovim Configs > " --height=~50% --layout=reverse --border --exit-0)
 
  # If I exit fzf without selecting a config, don't open Neovim
  [[ -z $config ]] && echo "No config selected" && return
 
  # Open Neovim with the selected config
  NVIM_APPNAME=$(basename $config) nvim $@
}


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
