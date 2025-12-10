if [[ $PS1~="nixos" ]]
then
  # non voglio condividere tutto il config tra distrobox e la base della sistema
else
  alias logsync="journalctl -u syncthing -b"
  source <(fzf --zsh)
fi
