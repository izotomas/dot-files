function awsenv --argument-names env
    # use prod as default env
    if test -z "$env"
        set env "prod"
    end

    set -l AWS_ACCOUNT $(aws sts get-caller-identity | jq -r '.Account')
    set -l K8S_NAMESPACE $(aws iam list-account-aliases | jq -r '.AccountAliases[0]' | sed 's/dfds-//g')

    # fail if not logged in
    if test -z "$AWS_ACCOUNT"
        echo "Failed to extract aws account. make sure you are logged in and try again (go-aws-sso)"
        return 1
    end

    # setup envrc for direnv
    echo "creating .envrc file..."
    printf "export SAML2AWS_ROLE=\"arn:aws:iam::$AWS_ACCOUNT:role/Capability\"
export AWS_ACCOUNT_ID=\"$AWS_ACCOUNT\"
export K8S_NAMESPACE=\"$K8S_NAMESPACE\"
export K8S_ENV=\"$env\"
ENVRC_AZ=\".envrc.\$K8S_ENV\"
if test -f \$ENVRC_AZ; then
    source \$ENVRC_AZ
fi" > .envrc

    # allow .envrc
    direnv allow
end

