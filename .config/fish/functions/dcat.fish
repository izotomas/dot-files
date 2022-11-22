function dcat
    argparse -x 'l,t' 't/topic=' 'c/count=' 'l/list-topics' -- $argv
    if test $status -eq 1
        return 1
    end

    set -l topic $_flag_t
    set -l count $_flag_c
    set -l list_topics $_flag_l

    # DAFDA CLUSTER CREDENTIALS
    set -l broker "pkc-e8wrm.eu-central-1.aws.confluent.cloud:9092"
    set -l username $(security find-generic-password -s 'DAFDA_PROD' | grep acct | sed -E "s/.*=\"(.*)\"/\\1/")
    set -l password $(security find-generic-password -s 'DAFDA_PROD' -w)

    if test -n "$list_topics"
        kcat -C -b "$broker" -X security.protocol=SASL_SSL -X sasl.mechanisms=PLAIN -X sasl.username="$username" -X sasl.password="$password" -L | grep "topic" | sed -E "s/.*\"(.*)\".*/\\1/" 2>/dev/null
    else
        kcat -C -b "$broker" -X security.protocol=SASL_SSL -X sasl.mechanisms=PLAIN -X sasl.username="$username" -X sasl.password="$password" -t "$topic" -o-$count -c$count | jq --slurp '.' | fx 2>/dev/null
    end

end

