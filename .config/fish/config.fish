#############################################################
#	PATHS, ALIASES & MISC
#############################################################
# conda, brew & aws binaries before the system ones
set -gx PATH /usr/local/bin /usr/local/sbin /usr/local/opt/ruby/bin /opt/local/bin /opt/local/sbin $HOME/.local/bin $PATH

# alias tmux for proper coloring
set -x TERM 'screen-256color'

# cmus notification enable
set -x PYTHON_CONFIGURE_OPTS '--enable-framework'

# lang settings
set -x LANG 'en_US.UTF-8'

# tee-clc java11 fix
set -x TF_NOTELEMETRY 'TRUE'

# enable fzf-tmux
set -U FZF_TMUX
set -U FZF_TMUX_OPTS '-p 80%'

# theme for bat and fzf preview (zenbrun not found)
# set -x BAT_THEME 'zenbrun'

# remove greeting
set fish_greeting

# setup fish vim bindings
fish_vi_key_bindings

alias vim='nvim'

#############################################################
#	PLUGIN MANAGER
#############################################################
if not functions -q fundle; eval (curl -sfL https://git.io/fundle-install); end

fundle plugin 'jethrokuan/fzf'
fundle plugin 'urbainvaes/fzf-marks'
fundle plugin 'jhillyerd/plugin-git'
fundle plugin 'edc/bass'
fundle plugin 'kevinhwang91/fzf-tmux-script'

fundle init

#############################################################
#	COLORS
#############################################################
set -g fish_color_command b8bb26
set -g fish_color_param ebdbb2
set -g fish_color_redirection ebdbb2
set -g fish_color_operator yellow

set -Ux LSCOLORS CxfxcxdxBxegedabagacad

# prompt starship
starship init fish | source

#############################################################
#	MISC
#############################################################
function print_fish_colors --description 'Shows the various fish colors being used'
    set -l clr_list (set -n | grep fish | grep color | grep -v __)
    if test -n "$clr_list"
        set -l bclr (set_color normal)
        set -l bold (set_color --bold)
        printf "\n| %-34s | %-34s |\n" Variable Definition
        echo '|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯|¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯|'
        for var in $clr_list
            set -l def $$var
            set -l clr (set_color $def ^/dev/null)
            or begin
                printf "| %-38s | %s%-38s$bclr |\n" "$var" (set_color --bold white --background=red) "$def"
                continue
            end
            printf "| $clr%-38s$bclr | $bold%-38s$bclr |\n" "$var" "$def"
        end
        echo '|________________________________________|________________________________________|'\n
    end
end

function take
    mkdir -p $argv
    cd $argv
end

function start_tmux
    if type tmux > /dev/null
        #if not inside a tmux session, and if no session is started, start a new session
        if test -z "$TMUX" ; and test -z $TERMINAL_CONTEXT
            tmux -2 attach; or tmux -2 new-session
        end
    end
end

start_tmux
#############################################################
#	CONDA
#############################################################
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
eval /usr/local/Caskroom/miniconda/base/bin/conda "shell.fish" "hook" $argv | source
# <<< conda initialize <<<

# HACK: for some reson conda was not activating propertly
conda deactivate
conda activate
