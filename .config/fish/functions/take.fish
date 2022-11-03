function take
    if test -d "$argv[1]"
        cd "$argv[1]"
        return 0;
    end
    mkdir -p "$argv[1]"; and cd "$argv[1]"
end
