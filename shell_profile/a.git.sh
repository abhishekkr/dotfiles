#profile for git

alias gad='git add'
alias gad='git add -p'
alias gcm='git commit -m'
alias gcp='git clone'
alias gst='git status'
alias gdf='git diff'
alias gdc='git diff --cached'
alias gpr='git pull --rebase'
alias glp='git log -p'
alias ggl="git log --graph --pretty=format:'%C(red)%h%Creset %C(bold yellow)%s%n %Cblue%an%Cred %C(green)%cd'"
alias gglp="git log -p --graph --pretty=format:'%C(red)%h%Creset %C(bold yellow)%s%n %Cblue%an%Cred %C(green)%cd'"
alias git_reset_author='git commit --amend --reset-author'

alias git_upstream_sync_master='git fetch upstream ; git merge upstream/master'
alias git_authors="git shortlog -sn --all"
