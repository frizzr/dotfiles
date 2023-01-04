alias vi=nvim
alias vim=nvim
alias cat=bat
alias gita="python3 -m gita"

alias curls="curl --netrc-file <(gpg -d ~/.netrc.gpg)"

alias kc="kubectl config"
alias kccc="kubectl config current-context"
alias kcgcs="kubectl config get-contexts"
alias kcuc="kubectl config use-context"
kcucr() { kcuc aws-rtlse-$1 }
kcucp() { kcuc aws-pas-$1 }
kchelp() {
    echo "kc = kubectl config .."
    echo "kccc = get current context"
    echo "kcgcs = get context list"
    echo "kcuc = use context .."
    echo "kcucr = use context aws-rtlse-.."
    echo "kcucp = use context aws-pas-.."
}
kch() { kchelp }
