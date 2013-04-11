#!/bin/bash
# Usage Example: $ clone-github github_id
# would clone all the git repositories managed under github_id at current path
# save it as /etc/profiles/a.github.sh
##

clone-github(){
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

clone-github-to-contribute(){
  if [ -z $1 ];
  then
    sed -i 's/git\:\/\/github\.com\//git@github.com:/' **/.git/config
  else
    sed -i 's/git\:\/\/github\.com\//git@github.com:/' $1/.git/config
  fi
}
