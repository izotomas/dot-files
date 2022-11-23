function fzf-dcat
    dcat -t $(dcat -l | fzf) | fx
end
