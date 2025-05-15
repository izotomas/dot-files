function awsl
    # check AWS_ACCOUNT_ID
    if not set -q AWS_ACCOUNT_ID
        echo "❌ AWS_ACCOUNT_ID is not set. Please export it first."
    return 1

    end

    go-aws-sso assume --account-id $AWS_ACCOUNT_ID --role-name CapabilityAccess

    if test $status -eq 0
        if set -q K8S_NAMESPACE
            # set namespace in kubectl
            kubectl config set-context --current --namespace $K8S_NAMESPACE

            # set namespace in k9s
            #set K9S_CONFIG_PATH "~/Library/Application Support/k9s/config.yml"
            #set K9S_CONFIG_PATH (eval echo ~/Library/Application\ Support/k9s/config.yml)

            yq eval ".k9s.clusters.hellman.namespace.active = \"$K8S_NAMESPACE\"" -i ~/Library/Application\ Support/k9s/config.yml
        else
            echo "⚠️  K8S_NAMESPACE is not set — skipping namespace change."
        end
    else
        echo "❌ AWS SSO login failed."
    end
end

