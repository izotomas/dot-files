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

    # load variables to environment
    direnv allow
end
