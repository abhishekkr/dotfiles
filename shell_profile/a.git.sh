#profile for git

alias ga='git add'
alias gad='git add -p'

alias gcm='git commit --signoff -m'
alias gcm0='git commit --signoff --allow-empty -m'

alias gcp='git clone'

gco(){
  local CHECKOUT_PATH="$1"
  local DO_IT="n"
  git diff ${CHECKOUT_PATH}
  echo "----------------------------------------------------------------"
  echo -n "enter to checkout (y|N): "
  read DO_IT
  [[ "${DO_IT}" == "y" || "${DO_IT}" == "Y" ]] && git checkout ${CHECKOUT_PATH}
}

alias gdf='git diff'
alias gdw='git diff --word-diff'
alias gdc='git diff --cached'

alias gpr='git pull --rebase'
alias gpull='git pull'
alias gpullo='git pull origin'

alias gpush='git push'
alias gpusho='git push origin'
alias git_upstream_sync_master='git fetch upstream ; git merge upstream/master'

alias gst='git status'
alias gsb='git status -sb'
alias gsa="git status -sb | grep -E '^[A|M][\ M]'"
gsbb(){
  local _WHERE="$1"
  [[ -z "${_WHERE}" ]] && _WHERE="."
  git status -sb $_WHERE | grep -v '^?? '| sed 's/^M /+|/g' | sed 's/^ M / | /g'
}

alias gbrr='git branch -r'

alias glp='git log -p'
alias ggl="git log --graph --pretty=format:'%C(red)%h%Creset %C(bold yellow)%s%n %Cblue%an%Cred %C(green)%cd'"
alias gglp="git log -p --graph --pretty=format:'%C(red)%h%Creset %C(bold yellow)%s%n %Cblue%an%Cred %C(green)%cd'"
alias git_authors='git shortlog -sn'
alias git_authors_all="git shortlog -sn --all"
alias git_workdays="git log --date=short --format="%ci"|awk '{print $1}'|uniq"
alias git_submodule_r="git submodule update --init --recursive"

alias git_undo='git reset --soft HEAD~1'
alias git_reset_author='git commit --signoff --amend --reset-author'
alias git_amend='git commit --signoff --amend'

gpull_all(){
  for _a in `ls` ; do
    echo $_a
    cd $_a ; git pull ; cd ..
  done
  unset _a
}

gsb-all(){
  for _a in `ls` ; do
    echo ""
    echo $_a
    cd $_a ; git status -sb ; cd ..
    echo "----------------------------------------------------------------"
  done
  unset _a
}

gitviz(){
  if [ $# -ne 2 ]; then
    echo "Syntax: gitviz <path_to_gitrepo> (<path_to_mp4>)"
    return
  fi

  gource $1/.git/ --stop-at-end --output-ppm-stream -1280x720 -o - | ffmpeg -y -r 60 -f image2pipe -vcodec ppm -i - -vcodec libx264 -preset ultrafast -pix_fmt yuv420p -crf 1 -threads 0 -bf 0 "$2"
  echo "play $2 to view vizualization"
}

git-conf(){
  local _GIT_DIR="$1"
  [[ -z "$_GIT_DIR" ]] && _GIT_DIR=$(pwd)
  cat "${_GIT_DIR}/.git/config"
}

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

git-ignore(){
  if [[ $# -eq 0 ]]; then
    cat >> ./.gitignore << GITIGNORE
*swn
*swo
*swp
*~
*.tmp
temp/*
.bundle
.venv
.goenv
.config
*.cfg
*.lock
*.sock
GITIGNORE
  else
    for _TO_IGNORE in $@; do
      cat "$_TO_IGNORE" >> ./.gitignore
    done
  fi
}

git-readme(){
  _ABOUT_IT="$@"
  if [[ $# -eq 0 ]]; then
    _README_FOR=`basename $PWD`
  fi
  cat >> ./README.md << READMEEOF
## ${_README_FOR}
---

${_ABOUT_IT}

READMEEOF
}

gitinit(){
  for REPO_TO_INIT in $@; do
    if [ -d "${PWD}/${REPO_TO_INIT}/.git" ]; then
      echo "${PWD}/${REPO_TO_INIT} is already a git repo."
    else
      echo "initializing git repo: ${PWD}/${REPO_TO_INIT}"
      git init $REPO_TO_INIT
      cd $REPO_TO_INIT
      git-readme
      git-ignore
      cd -
    fi
  done
}

alias git-fork-of="git remote add forkof"
alias git-fork-of-pull="git pull forkof master"

alias git-fetch-tags="git fetch --tags"
alias git-push-tags="git push origin --tags"

git-tag-later(){
  if [[ $# -ne 3 ]]; then
    echo "Syntax: git-tag-later '<TAG>' '<TAG-MESSAGE>' '<COMMIT-HASH>'"
    return 1
  else
    _GIT_TAG_TEXT="$1"
    _GIT_TAG_MSG="$2"
    _GIT_REPO_HASH="$3"
    git tag -a "${_GIT_TAG_TEXT}" -m "${_GIT_TAG_MSG}" "${_GIT_REPO_HASH}"
  fi
}

git-rm-sensitive-text(){
  local _SENSITIVE_TEXT="$1"
  local _CHANGE_TO_TEXT="$2"
  local _LEAKY_FILE="$3"

  git filter-branch --tree-filter "sed -i 's/${_SENSITIVE_TEXT}/${_CHANGE_TO_TEXT}/g' ${_LEAKY_FILE}" -- --all

  git push origin --force --all
  git push origin --force --tags

  git for-each-ref --format='delete %(refname)' refs/original | git update-ref --stdin
  git reflog expire --expire=now --all
  git gc --prune=now
}

git-rm-sensitive(){
  SENSITIVE_MISTAKE="$1"
  git filter-branch --force --index-filter "git rm --cached --ignore-unmatch $SENSITIVE_MISTAKE" --prune-empty --tag-name-filter cat -- --all

  echo "$SENSITIVE_MISTAKE" >> .gitignore
  git add .gitignore
  git commit --signoff -m "$SENSITIVE_MISTAKE gitignore-d"

  git push origin --force --all
  git push origin --force --tags

  git for-each-ref --format='delete %(refname)' refs/original | git update-ref --stdin
  git reflog expire --expire=now --all
  git gc --prune=now
}

git-commits-count(){
  git log --all | grep '^commit ' | wc -l
}
