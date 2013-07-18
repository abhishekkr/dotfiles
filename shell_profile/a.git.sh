#profile for git

alias gad='git add'
alias gad='git add -p'
alias gcm='git commit -m'
alias gcp='git clone'
alias gst='git status'
alias gsb='git status -sb'
alias gdf='git diff'
alias gdw='git diff --word-diff'
alias gdc='git diff --cached'
alias gpr='git pull --rebase'
alias glp='git log -p'
alias ggl="git log --graph --pretty=format:'%C(red)%h%Creset %C(bold yellow)%s%n %Cblue%an%Cred %C(green)%cd'"
alias gglp="git log -p --graph --pretty=format:'%C(red)%h%Creset %C(bold yellow)%s%n %Cblue%an%Cred %C(green)%cd'"
alias git_reset_author='git commit --amend --reset-author'

alias git_upstream_sync_master='git fetch upstream ; git merge upstream/master'
alias git_authors='git shortlog -sn'
alias git_authors_all="git shortlog -sn --all"
alias git_undo='git reset --soft HEAD^1'
alias git_amend='git commit --amend'

git_credit(){
  if [ $# -ne 2 ]; then
    echo "Syntax: <cmd> Name id@email"
  else
    git credit "$1" $2
  fi
}

git_commit_as(){
  if [ $# -ne 2 ]; then
    echo "Syntax: <cmd> Name id@email"
  else
    git commit --amend --author "${1} <${2}>" -C HEAD
  fi
}
