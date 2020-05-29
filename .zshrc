# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#############################################################
#	PATHS, ALIASES & MISC
#############################################################
# Conda & Homebrew binaries and scripts before system ones
export PATH=/usr/local/bin:/usr/local/sbin:/usr/local/opt/ruby/bin:/opt/local/bin:$HOME/.local/bin:$PATH

#Fuzzy search plugin
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# alias tmux for proper coloring
export TERM='xterm-256color'

# Zplug
export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

#FZF - use ag to search
export FZF_DEFAULT_COMMAND="ag -l -uG '^(?!.*\.(pvm|iso|dmg)).*$'"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# cmus notifications enable
export PYTHON_CONFIGURE_OPTS="--enable-framework"

# Lang setting
export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
export EDITOR='vim lazygit'

# Key timeout
export KEYTIMEOUT=1

# tmux autostart
#ZSH_TMUX_AUTOSTART="true"

# Compilation flags
export ARCHFLAGS="-arch x86_64"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Date format in history
HIST_STAMPS="dd/mm/yyyy"

# tee-clc java11 fix
export TF_NOTELEMETRY=TRUE

alias vim='nvim'
alias cc='pwd | tr -d '\n' | pbcopy' # copy current path to clipboard
alias ~='cd ~'
alias ..='cd ..'
#############################################################
#	PLUGIN MANAGER
#############################################################
# Check if zplug is installed
if [[ ! -d ~/.zplug ]]; then
  git clone https://github.com/zplug/zplug ~/.zplug
  source ~/.zplug/init.zsh && zplug update --self
fi

# Essential
source ~/.zplug/init.zsh

# Bundles
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-history-substring-search"
zplug "uvaes/fzf-marks"
zplug "romkatv/powerlevel10k", as:theme, depth:1
zplug "robbyrussell/oh-my-zsh/plugins/docker"

# oh-my-zsh library
zplug "plugins/tmux",  from:oh-my-zsh, as:plugin
zplug "plugins/sudo", from:oh-my-zsh
zplug "plugins/colored-man-pages", from:oh-my-zsh
zplug "plugins/ssh-agent", from:oh-my-zsh, if:"which ssh-agent"
zplug "plugins/z",  from:oh-my-zsh
zplug "plugins/git",  from:oh-my-zsh, as:plugin
zplug "plugins/osx",  from:oh-my-zsh, as:plugin
zplug "lib/clipboard", from:oh-my-zsh, defer:0
zplug "lib/compfix", from:oh-my-zsh, defer:0
zplug "lib/completion", from:oh-my-zsh, defer:0
zplug "lib/correction", from:oh-my-zsh, defer:0
zplug "lib/directories", from:oh-my-zsh, defer:0
zplug "lib/grep", from:oh-my-zsh, defer:0
zplug "lib/key-bindings", from:oh-my-zsh, defer:0
zplug "lib/misc", from:oh-my-zsh, defer:0
zplug "lib/termsupport", from:oh-my-zsh, defer:0

# Install packages that have not been installed yet
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    else
        echo
    fi
fi

zplug load

#############################################################
#	KEY BINDINGS
#############################################################
# use vim bindings
bindkey -v

#remove unused bindings
bindkey -r "^F"
bindkey -r "^@"
bindkey -r "^D"
bindkey -r "^Q"

bindkey '^K' history-substring-search-up
bindkey '^J' history-substring-search-down
bindkey '^H' backward-kill-word
bindkey '^R' history-incremental-search-backward
bindkey '^P' fzf-file-widget
bindkey '^O' fzf-cd-tmux-widget
bindkey '^E' fzf-history-widget
bindkey '\`' autosuggest-clear
bindkey '^ ' autosuggest-accept
bindkey '^G' jump
bindkey '^F^G' fzf-git-aliases
#############################################################
#	FUNCTIONS
#############################################################

fzf-cd-tmux-widget() {
	local cmd="${FZF_ALT_C_COMMAND:-"command find -L . -mindepth 1 \\( -path '*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune     -o -type d -print 2> /dev/null | cut -b3-"}"
	setopt localoptions pipefail 2> /dev/null
	local dir=$(eval "$cmd" | fzf-tmux -d 30%)
	if [[ -z "$dir" ]]
	then
		zle redisplay
		return 0
	fi
	cd "$dir"
	local ret=$?
	zle reset-prompt
	typeset -f zle-line-init > /dev/null && zle zle-line-init
        return $ret
}
zle -N fzf-cd-tmux-widget

function take() {
  mkdir -p $1
  cd $1
}

fkill() {
    local pid
    if [ "$UID" != "0" ]; then
        pid=$(ps -f -u $UID | sed 1d | fzf-tmux -d 15 | awk '{print $2}')
    else
        pid=$(ps -ef | sed 1d | fzf-tmux -d 15 | awk '{print $2}')
    fi

    if [ "x$pid" != "x" ]
    then
        echo $pid | xargs kill -${1:-9}
    fi
}

fzf-git-aliases() {
    eval $(alias | grep git | fzf-tmux -d 15 | grep -Eoh '^\w+')
}
zle -N fzf-git-aliases
#############################################################
#	TEST
#############################################################
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/usr/local/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/usr/local/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
        . "/usr/local/Caskroom/miniconda/base/etc/profile.d/conda.sh"
    else
        export PATH="/usr/local/Caskroom/miniconda/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
