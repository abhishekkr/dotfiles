#!/bin/bash
# Usage Example: $ clone-github github_id
# would clone all the git repositories managed under github_id at current path
# save it as /etc/profiles/a.github.sh
##

clone_github(){
  GITHUB_ID=$1
  GITHUB_REPO_URI="https://github.com/"$GITHUB_ID"?tab=repositories"
  repos=`curl -skL $GITHUB_REPO_URI | grep 'title="Forks"' | sed "s/.*$GITHUB_ID\///" | sed 's/\/network"\stitle="Forks">//'`
  for line in `echo $repos | xargs -L1`;
  do
    if [ ! -z $line ];
    then
      repo_git='git://github.com/'$GITHUB_ID'/'$line'.git'
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

clone_github_to_contribute(){
  if [ -z $1 ];
  then
    sed -i 's/git\:\/\/github\.com\//git@github.com:/' **/.git/config
  else
    sed -i 's/git\:\/\/github\.com\//git@github.com:/' $1/.git/config
  fi
}

#old github style # no contrib
# usgae:
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

clone_git_to_https(){
  if [ -z $1 ];
  then
    sed -i 's/git\:\/\/github\.com\//https\:\/\/github.com:/' **/.git/config
  else
    sed -i 's/git\:\/\/github\.com\//https\:\/\/github.com:/' $1/.git/config
  fi
}
