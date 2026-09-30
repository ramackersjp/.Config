# ================================================
# This bashRC can kill you! ~ J.P. Ramackers
# ================================================

[[ $- != *i* ]] && return

if [[ -n "${GHOSTTY_RESOURCES_DIR-}" &&
      -f "$GHOSTTY_RESOURCES_DIR/shell-integration/bash/ghostty.bash" ]]; then
    source "$GHOSTTY_RESOURCES_DIR/shell-integration/bash/ghostty.bash"
fi

source ~/.local/share/blesh/ble.sh
source ~/.local/share/omarchy/default/bash/rc

blehook PRECMD+='bleopt prompt_rps1='


if [[ ${BLE_VERSION-} && $(command -v pacman) ]] &&
   pacman -Q ghostty 2>/dev/null | grep -q '^ghostty 1\.3\.1' &&
   [[ $(type -t __ghostty_precmd) == function ]]; then
  __ghostty_precmd() {
    local ret="$?"
    if test "$_ghostty_executing" != "0"; then
      _GHOSTTY_SAVE_PS1="$PS1"
      _GHOSTTY_SAVE_PS2="$PS2"

      PS1='\[\e]133;P;k=i\a\]'$PS1'\[\e]133;B\a\]'
      PS2='\[\e]133;P;k=s\a\]'$PS2'\[\e]133;B\a\]'

      if [[ "$PS1" == *"\n"* ]]; then
        PS1="${PS1//\\n/\\n$'\\[\\e]133;P;k=s\\a\\]'}"
      fi

      if [[ "$GHOSTTY_SHELL_FEATURES" == *"cursor"* ]]; then
        builtin local cursor=5  
        [[ "$GHOSTTY_SHELL_FEATURES" == *"cursor:steady"* ]] && cursor=6  

        [[ "$PS1" != *"\[\e[${cursor} q\]"* ]] && PS1=$PS1"\[\e[${cursor} q\]"
        [[ "$PS0" != *'\[\e[0 q\]'* ]] && PS0=$PS0'\[\e[0 q\]' 
      fi

      if [[ "$GHOSTTY_SHELL_FEATURES" == *"title"* ]]; then
        PS1=$PS1'\[\e]2;\w\a\]'
      fi
    fi

    if test "$_ghostty_executing" != ""; then
      builtin printf "\e]133;D;%s;aid=%s\a" "$ret" "$BASHPID"
    fi

    if [[ -n "${BLE_VERSION-}" ]]; then
      builtin printf "\e]133;P;k=i\a"
    else
      builtin printf "\e]133;A;redraw=last;cl=line;aid=%s\a" "$BASHPID"
    fi

    if [[ "$_ghostty_last_reported_cwd" != "$PWD" ]]; then
      _ghostty_last_reported_cwd="$PWD"
      builtin printf "\e]7;kitty-shell-cwd://%s%s\a" "$HOSTNAME" "$PWD"
    fi

    _ghostty_executing=0
  }
fi

if command -v mise >/dev/null 2>&1; then
    eval "$(mise activate bash)"
fi

export GOBIN="$HOME/.local/bin"
export PATH="$GOBIN:$PATH"

export PATH="$(go env GOPATH)/bin:$PATH"

export VIRTUAL_ENV_DISABLE_PROMPT=1

# ================================================
# Extra aliases
# ================================================

alias ll='ls -lah --color=auto'
alias la='ls -A'
alias update='sudo pacman -Syu'
alias fix='source ~/.bashrc'
alias code='cd ~/Code/ && ls -a'
alias nanoxmr='/opt/nanominer/nanominer /home/jp/config.ini'
alias gh-update='cd ~/cli && git pull && make && cp bin/gh ~/.local/bin/gh'
alias tp='cd ~/Code/taxiprijs/ && ls -a'

#=================================================
# Extra functions for extract and cd
#=================================================

function extract () {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjvf $1    ;;
      *.tar.gz)    tar xzvf $1    ;;
      *.tar.xz)    tar xvf $1    ;;
      *.bz2)       bzip2 -d $1    ;;
      *.rar)       unrar2dir $1    ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1    ;;
      *.tgz)       tar xzf $1    ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1    ;;
      *.7z)        7z x $1    ;;
      *.ace)       unace x $1    ;;
      *)           echo "'$1' cannot be extracted via extract()"   ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

function cd() {
    new_directory="$*";
    if [ $# -eq 0 ]; then
        new_directory=${HOME};
    fi;
    builtin cd "${new_directory}" && /bin/ls -lhF --time-style=long-iso --color=auto --ignore=lost+found
}


# Override tdl to open nvim without file tree
tdl() {
  [[ -z $1 ]] && { echo "Usage: tdl <c|cx|codex|other_ai> [<second_ai>]"; return 1; }
  [[ -z $TMUX ]] && { echo "You must start tmux to use tdl."; return 1; }

  local current_dir="${PWD}"
  local editor_pane ai_pane ai2_pane
  local ai="$1"
  local ai2="$2"

  editor_pane="$TMUX_PANE"

  tmux rename-window -t "$editor_pane" "$(basename "$current_dir")"

  tmux split-window -v -p 15 -t "$editor_pane" -c "$current_dir"

  ai_pane=$(tmux split-window -h -p 30 -t "$editor_pane" -c "$current_dir" -P -F '#{pane_id}')

  if [[ -n $ai2 ]]; then
    ai2_pane=$(tmux split-window -v -t "$ai_pane" -c "$current_dir" -P -F '#{pane_id}')
    tmux send-keys -t "$ai2_pane" "$ai2" C-m
  fi

  tmux send-keys -t "$ai_pane" "$ai" C-m

  tmux send-keys -t "$editor_pane" "$EDITOR" C-m

  tmux select-pane -t "$ai_pane"
}

. "$HOME/.local/share/../bin/env"

alias fan-server="ssh pihole@10.0.0.27"
