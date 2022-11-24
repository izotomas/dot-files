function fzf-dcat --description 'Read Dafda events'
    dcat -t $(dcat -l | fzf) | fx
end
