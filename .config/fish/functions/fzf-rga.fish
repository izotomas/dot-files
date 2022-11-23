# searches for string in files
# TODO: use bat for preview, bind to some _FZF_CTRL_ command
function fzf-rga
    set RG_PREFIX 'rga --files-with-matches --no-ignore-vcs --hidden -g \'!.git/\''
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


