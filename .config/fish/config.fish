if status is-interactive
    # Commands to run in interactive sessions can go here
end


# Fish syntax highlighting
set -g fish_color_autosuggestion '555'  'brblack'
set -g fish_color_cancel -r
set -g fish_color_command --bold
set -g fish_color_comment red
set -g fish_color_cwd green
set -g fish_color_cwd_root red
set -g fish_color_end brmagenta
set -g fish_color_error brred
set -g fish_color_escape 'bryellow'  '--bold'
set -g fish_color_history_current --bold
set -g fish_color_host normal
set -g fish_color_match --background=brblue
set -g fish_color_normal normal
set -g fish_color_operator bryellow
set -g fish_color_param cyan
set -g fish_color_quote yellow
set -g fish_color_redirection brblue
set -g fish_color_search_match 'bryellow'  '--background=brblack'
set -g fish_color_selection 'white'  '--bold'  '--background=brblack'
set -g fish_color_user brgreen
set -g fish_color_valid_path --underline
set --universal nvm_default_version v18.12.1

set -Ux EDITOR nvim

set -gx HELIX_RUNTIME $HOME/helix/runtime

set -Ux PYENV_ROOT $HOME/.pyenv
fish_add_path $PYENV_ROOT/bin

set -x PATH $HOME/.rbenv/bin $PATH
status --is-interactive; and source (rbenv init -|psub)

set -gx COMPOSE_DOCKER_CLI_BUILD 1
set -gx DOCKER_BUILDKIT 1

#set -gx NODE_OPTIONS --openssl-legacy-provider

set -gx PATH "$HOME/.cargo/bin" $PATH
set -x PATH $PATH /usr/local/go/bin
set -x PATH $PATH $HOME/.pub-cache/bin
set -x GOPATH $GOPATH $HOME/go
set -x PATH $PATH $GOPATH/bin
fish_add_path $HOME/.local/share/bob/nvim-bin

zoxide init fish | source
starship init fish | source
pyenv init - | source
kubectl completion fish | source
fish_add_path $HOME/.spicetify

# Aliases
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias cat='bat'
alias ls='exa -l'

fish_add_path /home/sebastianpantinliljevall/.spicetify
