#############################################################
#	PATHS, ALIASES & MISC
#############################################################
# conda, brew & aws binaries before the system ones
set -gx PATH $HOME/anaconda3/bin /usr/local/bin /usr/local/sbin /usr/local/opt/ruby/bin /opt/local/bin $HOME/Library/Python/3.7/bin $HOME/.composer/vendor/bin $HOME/.local/bin $PATH

# alias tmux for proper coloring
set -x TERM 'xterm-256color'

# cmus notification enable
set -x PYTHON_CONFIGURE_OPTS '--enable-framework'

# lang settings
set -x LANG 'en_US.UTF-8'

# tee-clc java11 fix
set -x TF_NOTELEMETRY 'TRUE'

# enable fzf-tmux
set -U FZF_TMUX 1

# setup fish vim bindings
fish_vi_key_bindings

alias vim='nvim'

#############################################################
#	PLUGIN MANAGER
#############################################################
if not functions -q fundle; eval (curl -sfL https://git.io/fundle-install); end

fundle plugin 'oh-my-fish/theme-bobthefish'
fundle plugin 'urbainvaes/fzf-marks'
fundle plugin 'jhillyerd/plugin-git'

fundle init

#############################################################
#	BOBTHEFISH
#############################################################
set -g theme_nerd_fonts yes
set -g theme_display_user yes
set -g theme_color_scheme gruvbox
set -g theme_newline_cursor yes
set -g theme_newline_prompt '$ '
set -g theme_display_git_master_branch yes

#############################################################
#	CONDA
#############################################################
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
eval /Users/tomasizo/anaconda3/bin/conda "shell.fish" "hook" $argv | source
# <<< conda initialize <<<
