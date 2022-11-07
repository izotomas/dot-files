#############################################################
#	PATHS, ALIASES & ABBR
#############################################################
# conda, brew & aws binaries before the system ones
set -gx PATH /usr/local/share/dotnet /opt/homebrew/bin /usr/local/bin /usr/local/sbin /usr/local/opt/ruby/bin /opt/local/bin /opt/local/sbin $HOME/.local/bin $HOME/.cargo/bin $HOME/.dotnet/tools $PATH

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
set -U FZF_CTRL_T_COMMAND 'rg --files --no-ignore --hidden --follow --glob "!.git/*"'
set -U FZF_CTRL_T_OPTS '--preview="bat --color=always {}"'

set -gx EDITOR 'nvim'

# remove greeting
set fish_greeting

# setup fish vim bindings
fish_vi_key_bindings

# DFDS Stuff
# Set 'saml' as the default AWS profile
set -x AWS_PROFILE 'saml'
# Set the Hellman config file as the default for kubectl
set -x KUBECONFIG ~/.kube/hellman-saml.config

alias snyk='/Users/tomasizo/Library/Application\ Support/JetBrains/Rider2022.2/plugins/snyk-intellij-plugin/snyk-macos'
alias vim='nvim'
alias mux='tmuxinator'
abbr -a -g k9sn 'k9s -n $K8S_NAMESPACE'
abbr -a -g awsl 'saml2aws login --force --skip-prompt'

#############################################################
#	PLUGINS
#############################################################
if not functions -q fundle; eval (curl -sfL https://git.io/fundle-install); end

fundle plugin 'urbainvaes/fzf-marks'
fundle plugin 'jhillyerd/plugin-git'
fundle plugin 'edc/bass'
fundle plugin 'kevinhwang91/fzf-tmux-script'

fundle init

#############################################################
#	COLORS & STYLE
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
function start_tmux
    if type tmux > /dev/null
        #if not inside a tmux session, and if no session is started, start a new session
        if test -z "$TMUX" ; and test -z $TERMINAL_CONTEXT
            tmux -2 attach; or tmux -2 new-session
        end
    end
end

# searches for string in files
# TODO: use bat for preview, bind to some _FZF_CTRL_ command
function rga-fzf
    set RG_PREFIX 'rga --files-with-matches --hidden -g \'!.git/\''
    if test (count $argv) -gt 1
        set RG_PREFIX "$RG_PREFIX $argv[1..-2]"
    end
    set -l file $file
    set file (
        FZF_DEFAULT_COMMAND="$RG_PREFIX '$argv[-1]'" \
        fzf --sort \
            --preview='test ! -z {} && \
                rga --pretty --context 5 {q} {}' \
            --phony -q "$argv[-1]" \
            --bind "change:reload:$RG_PREFIX {q}" \
            --preview-window='50%:wrap'
    ) && \
    echo "opening $file" && \
    open "$file"
end

direnv hook fish | source

#############################################################
#	CONDA
#############################################################
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
eval /opt/homebrew/Caskroom/miniconda/base/bin/conda "shell.fish" "hook" $argv | source
# <<< conda initialize <<<
conda deactivate
conda activate
