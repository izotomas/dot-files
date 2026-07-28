#############################################################
#	PATHS, ALIASES & ABBR
#############################################################
# conda, brew & aws binaries before the system ones
set -gx PATH /usr/local/share/dotnet /opt/homebrew/bin /opt/homebrew/opt/coreutils/libexec/gnubin /usr/local/bin /usr/local/sbin /usr/local/opt/ruby/bin /opt/local/bin /opt/local/sbin $HOME/.local/bin $HOME/.cargo/bin $HOME/.dotnet/tools $HOME/.bun/bin $PATH

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

set -x KUBECONFIG ~/.zplug/repos/lunarway/lw-zsh/k8s-login/kubeconfig/dev
set -x OPENAI_API_KEY $(security find-generic-password -s 'OPENAI' -w)
set -x LINEAR_API_KEY $(security find-generic-password -s 'LINEAR_API_TOKEN' -w)
set -x LUNAR_HUMIO_PAT $(security find-generic-password -s 'LUNAR_HUMIO_PAT' -w)
set -x OPENAI_BASE_URL 'https://eu.api.openai.com/v1'
set -x GOPRIVATE 'github.com/lunarway/*,go.lunarway.com/*'

# aws cli completion
complete --command aws --no-files --arguments '(begin; set --local --export COMP_SHELL fish; set --local --export COMP_LINE (commandline); aws_completer | sed \'s/ $//\'; end)'


alias vim='nvim'
alias mux='tmuxinator'
abbr -a -g k9sn 'k9s -n $K8S_NAMESPACE'
# disable for now, using a function instead
# abbr -a -g awsl 'go-aws-sso assume --account-id $AWS_ACCOUNT_ID --role-name CapabilityAccess'

bind \cf fzf-rga
bind -M insert \cf fzf-rga


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

function conda_load
  eval /opt/homebrew/Caskroom/miniconda/base/bin/conda "shell.fish" "hook" | source
end

