#!/bin/bash

if [ -z $REPO_ROOT ]; then
  REPO_ROOT=$(dirname $(dirname $0))
  cd $REPO_ROOT
  REPO_ROOT=${PWD}
  cd -
fi

## 'link all shell profiles'
profile_setup(){
  mkdir -p "${HOME}/cache/pip"

  # projectrc ## git-ignored
  ProjectRC="${REPO_ROOT}/shell_profile/nda.project.sh"
  echo "#!/bin/bash" | tee $ProjectRC > /dev/null
  echo "#non git config" | tee -a $ProjectRC > /dev/null

  ALLRC="/etc/profile.d/a.profiles.sh"
  echo "#!/bin/bash" | sudo tee $ALLRC > /dev/null
  echo "#one RC to load all" | sudo tee -a $ALLRC > /dev/null
  echo "re_source(){" | sudo tee -a $ALLRC > /dev/null

  for RCFilePath in `ls $REPO_ROOT/shell_profile/*.sh`; do
    RCFilename=$(basename $RCFilePath)
    destination="/etc/profile.d/${RCFilename}"
    echo "source ${destination}" | sudo tee -a $ALLRC > /dev/null
    if [[ -f "$destination" ]]; then
      if [[ ! -L "$destination" ]]; then
        echo "[ERROR:] ${destination} has a file present, check!"
        continue
      fi
      echo "${destination} link already exists."
      continue
    fi
    sudo ln -sf "${RCFilePath}" "${destination}"
    if [[ ! -L "$destination" ]]; then
      echo "${destination} copy failed."
      continue
    fi
  done

  echo "}" | sudo tee -a $ALLRC > /dev/null
  echo "run : 'source $ALLRC'"
}

profile_setup
