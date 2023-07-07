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

# colima
set -gx DOCKER_HOST "unix:///Users/tomasizo/.colima/default/docker.sock"


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
set -x OP_ACCOUNT 'dfds'
# Set the Hellman config file as the default for kubectl
set -x KUBECONFIG ~/.kube/hellman-saml.config
# az cli token
set -x AZURE_DEVOPS_EXT_PAT $(security find-generic-password -s 'AZURE_DEVOPS_PAT' -w)

# aws cli completion
complete --command aws --no-files --arguments '(begin; set --local --export COMP_SHELL fish; set --local --export COMP_LINE (commandline); aws_completer | sed \'s/ $//\'; end)'


alias vim='nvim'
alias mux='tmuxinator'
abbr -a -g k9sn 'k9s -n $K8S_NAMESPACE'
abbr -a -g awsl 'go-aws-sso assume --account-id $AWS_ACCOUNT_ID --role-name CapabilityAccess'

bind \cf fzf-rga
bind -M insert \cf fzf-rga

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
