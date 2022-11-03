#############################################################
#	PATHS, ALIASES & MISC
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

#############################################################
#	PLUGIN MANAGER
#############################################################
if not functions -q fundle; eval (curl -sfL https://git.io/fundle-install); end

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
function start_tmux
    if type tmux > /dev/null
        #if not inside a tmux session, and if no session is started, start a new session
        if test -z "$TMUX" ; and test -z $TERMINAL_CONTEXT
            tmux -2 attach; or tmux -2 new-session
        end
    end
end

function azenv --argument-names ci_yml
    # use default ci.yml
    if test -z "$ci_yml"
        set ci_yml "azure-pipelines.yml"
    end

    # fail if missing
    if test ! -f "$ci_yml"
        return 1
    end

    # prep output file
    set DUMP_FILE ".envrc.$K8S_ENV"
    rm -f $DUMP_FILE
    touch $DUMP_FILE

    # extract variable groups from az-pipeline.yml
    set GROUPS $(cat $ci_yml | yq ".stages | .[] | select(.stage | match(\"(?i).*$K8S_ENV\")) | .variables.[].group")

    # extract variables to output file
    echo "extracting variables to $DUMP_FILE"

    for GROUP_NAME in $GROUPS
        set VARS $(az pipelines variable-group list --group-name "$GROUP_NAME")
        echo $VARS | jq -r '.[] .variables | to_entries | map("export \(.key)=\(.value.value|@sh)")|.[]' >> $DUMP_FILE
    end
end

function awsenv --argument-names env
    # use prod as default env
    if test -z "$env"
        set env "prod"
    end

    set -l AWS_ACCOUNT $(aws sts get-caller-identity | jq -r '.Account')

    # fail if not logged in
    if test -z "$AWS_ACCOUNT"
        "Failed to extract aws account. make sure you are logged in and try again (saml2aws login)"
        return 1
    end

    # setup envrc for direnv
    printf "export SAML2AWS_ROLE=\"arn:aws:iam::$AWS_ACCOUNT:role/Capability\"
export K8S_NAMESPACE=\"\$(cat ./k8s/deployment.yml | yq '.metadata.namespace')\"
export K8S_ENV=\"$env\"
ENVRC_AZ=\".envrc.\$K8S_ENV\"
if test -f \$ENVRC_AZ; then
    source \$ENVRC_AZ
fi" > .envrc
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
