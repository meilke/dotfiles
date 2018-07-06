alias googc='google-chrome --explicitly-allowed-ports=6668'
alias clean-scrot='find ~/ -maxdepth 1 -type f -name "*_scrot.png" -exec rm -rf {} \;'
alias replace_coded_linebreaks="sed -e $'s/----/\\\n/g'"
alias kexec="kubectl --context $1 -n $2 exec -it $3 env TERM=xterm COLUMNS=$COLUMNS LINES=$LINES bash"
alias t="todo.sh -d ~/.config/todo.txt-cli/config"
alias drmin="docker images | awk '/<none>/ { print $3 }' | xargs -r docker rmi -f"
alias v="vagrant"
alias vs="v status"
alias vgs="v global-status"
alias vdf="v destroy -f"
