#!/usr/bin/env zsh
alias logsync="journalctl -u syncthing -b"
bindkey -v
source <(fzf --zsh)
