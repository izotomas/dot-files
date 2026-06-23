function lw-tmux --description "open project in tmux"
    if not string match -q "$HOME/lunar/*" (pwd)
        echo "error: must be run from ~/lunar/<project>"
        return 1
    end
    tmuxinator start lw (basename (pwd))
end
