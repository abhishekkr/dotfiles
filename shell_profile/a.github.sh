#!/bin/bash
# Usage Example: $ clone-github github_id
# would clone all the git repositories managed under github_id at current path
# save it as /etc/profiles/a.github.sh
##

# usage:
#   $ clone-github mr_x
clone-github(){
  GITHUB_ID=$1
  GITHUB_REPO_URI="https://github.com/"$GITHUB_ID"?tab=repositories"
  repos=`curl -skL $GITHUB_REPO_URI | grep 'name codeRepository' | sed 's/.*href=\"//' | sed 's/".*//'`
  for line in `echo $repos | xargs -L1`;
  do
    if [[ -z $line ]]; then
      next
    fi
    repo_git='git://github.com'$line'.git'
    repo_dir=$(basename $line)
    if [[ -d "${repo_dir}" ]]; then
      echo 'Fetching master latest pull for: '$repo_git
      pushd "${repo_dir}" ; git pull ; popd
    else
      echo "Cloning... "$repo_git
      git clone $repo_git
    fi
  done
}
clone_github(){
  clone-github $@
}


git-conf-to-contribute(){
  if [ -z $1 ];
  then
    sed -i 's/https\:\/\/github\.com\//git@github.com:/' **/.git/config
    sed -i 's/git\:\/\/github\.com\//git@github.com:/' **/.git/config
  else
    sed -i 's/https\:\/\/github\.com\//git@github.com:/' **/.git/config
    sed -i 's/git\:\/\/github\.com\//git@github.com:/' $1/.git/config
  fi
}

#old github style # no contrib
# usage:
#   $ clone-github-private github.private_instance.com mr_x
clone_github_private(){
  GITHUB_HOST=$1
  GITHUB_ID=$2
  repos=`curl -skL https://$GITHUB_HOST/$GITHUB_ID | grep 'title="Forks"' | sed "s/.*$GITHUB_ID\///" | sed 's/\/network"\stitle="Forks">//'`
  for line in `echo $repos | xargs -L1`;
  do
    if [ ! -z $line ];
    then
      repo_git='https://'$GITHUB_HOST'/'$GITHUB_ID'/'$line'.git'
      if [ -e $line ]; then
        echo 'Fetching master latest pull for: '$repo_git
        cd $line ; git pull ; cd -
      else
        echo "Cloning... "$repo_git
        `git clone $repo_git`
      fi
    fi
  done
}

git-conf-to-https(){
  if [ -z $1 ];
  then
    sed -i 's/git\:\/\/github\.com\//https\:\/\/github.com:/' **/.git/config
  else
    sed -i 's/git\:\/\/github\.com\//https\:\/\/github.com:/' $1/.git/config
  fi
}
