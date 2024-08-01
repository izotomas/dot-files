function dcat
    argparse -x 'l,t' -x 'l,c' 't/topic=' 'c/count=!_validate_int' 'l/list-topics' -- $argv
    if test $status -eq 1
        echo "[Error] failed parsing arguments"
        return 1
    end

    set -l topic $_flag_t
    set -l count $_flag_c
    set -l list_topics $_flag_l

    if test -z "$count"
        set count "100"
    end

    # DAFDA CLUSTER CREDENTIALS
    set -l dafda_credentials "DAFDA_TRACKING"
    if test -n "$K8S_NAMESPACE"
        set -l credentials_sufix $(echo $K8S_NAMESPACE | cut -d '-' -f 2 | string upper)
        set dafda_credentials "DAFDA_$credentials_sufix"

    end
    set -l broker "pkc-e8wrm.eu-central-1.aws.confluent.cloud:9092"
    set -l username $(security find-generic-password -s $dafda_credentials | grep acct | sed -E "s/.*=\"(.*)\"/\\1/")
    set -l password $(security find-generic-password -s $dafda_credentials -w)

    if test -z $username; or test -z $password
        echo "[Error] credentials for $dafda_credentials not found"
        return 1
    end
    if test -n "$list_topics"
        kcat -C -b "$broker" -X security.protocol=SASL_SSL -X sasl.mechanisms=PLAIN -X sasl.username="$username" -X sasl.password="$password" -L | grep -E "topic\s" | sed -E "s/.*\"(.*)\".*/\\1/" 2>/dev/null
    else
        kcat -C -b "$broker" -X security.protocol=SASL_SSL -X sasl.mechanisms=PLAIN -X sasl.username="$username" -X sasl.password="$password" -t "$topic" -o-$count -c$count | jq --slurp '.' 2>/dev/null
    end

end

