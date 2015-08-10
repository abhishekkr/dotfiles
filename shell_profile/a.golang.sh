#profile for golang

export GOPATH=$HOME/.go/site
export GO_HOME=$HOME/.go
export GOOS=linux
export GOARCH=amd64

[ -s $GOPATH ] && mkdir -p $GOPATH

alias gofmt-fix="gofmt -l -w -s"

alias gorun="go run"
alias gobld="go build"
go_clr(){
  go run "$@"
}
go_help(){
  echo 'Go Docs are available at http://localhost:9090'
  godoc -http=:9090
}

goenv_on_at(){
  _AT_DIR="$1"
  if [ $# -eq 0 ]; then
    _GOPATH_VALUE="${_AT_DIR}/.goenv"
  else
    cd $1 ; _GOPATH_VALUE="${_AT_DIR}/.goenv" ; cd -
  fi
  if [ ! -d $_GOPATH_VALUE ]; then
    mkdir -p "${_GOPATH_VALUE}/site"
  fi
  export _OLD_GOPATH=$GOPATH
  export _OLD_PATH=$PATH
  export GOPATH=$_GOPATH_VALUE/site
  export PATH=$PATH:$GOPATH/bin

  echo "your new GOPATH is at $GOPATH"
}

alias goenv_home="goenv_on_at \$HOME"
alias goenv_on="goenv_on_at \$PWD"
alias goenv_off="export GOPATH=\$_OLD_GOPATH ; export PATH=\$_OLD_PATH ; unset _OLD_PATH ; unset _OLD_GOPATH"

go_get_pkg(){
  if [[ "$1" == "help" ]]; then
    echo "go_get_pkg handles your Golang Project dependencies."
    echo "* Create new dependency list or install from existing:"
    echo "  $ go_get_pkg"
    echo "* Install from existing with updated dependencies"
    echo "  $ GO_GET_UPDATE=true go_get_pkg"
    echo "* Install from existing with re-prepared binaries (required on new Golang update or local changed dependency code)"
    echo "  $ GO_GET_RENEW=true go_get_pkg"
    echo "* Install from existing with updated dependencies (re-prepared binaries even if no updates)"
    echo "  $ GO_GET_RENEW=true GO_GET_UPDATE=true go_get_pkg"
    return
  fi
  if [[ $# -eq 0 ]]; then
    PKG_LISTS="$PWD/go-get-pkg.txt"
    if [ ! -f "$PWD/go-get-pkg.txt" ]; then
      touch "$PKG_LISTS"
      echo "Created GoLang Package empty list $PWD/go-get-pkg.txt"
      echo "Start adding package paths as separate lines." && return 0
    fi
  else
    PKG_LISTS=($@)
  fi
  for pkg_list in $PKG_LISTS; do
    cat $pkg_list | while read pkg_path; do
        echo "fetching golag package: go get ${pkg_path}";
        pkg_import_path=$(echo $pkg_path | awk '{print $NF}')
        if [[ ! -z $GO_GET_RENEW ]]; then
          rm -rf "${GOPATH}/pkg/${GOOS}_${GOARCH}/${pkg_import_path}"
          echo "cleaning old pkg for ${pkg_import_path}"
        fi
        if [[ -z $GO_GET_UPDATE ]]; then
          echo $pkg_path | xargs go get
        else
          echo $pkg_path | xargs go get -u
        fi
    done
  done
}

goenv_dup(){
  if [ $# -ne 1 -o ! -d $1 ]; then
    echo "Duplicate Source GoPath to current.\nSYNTAX: goenv_dup <src_env>"
    return 1
  fi
  goenv_on
  cp -rudan $1/* $GOPATH/
}

goenv_alpha(){
  _TMP_PWD=$PWD
  if [ $# -ne 2 ]; then
    echo "Provide Alpha changes usable as any other go package."
    echo "Just the import path changes to 'alpha/<project-name>'"
    echo "SYNTAX: goenv_alpha <path-to-project-dir-with-alpha-changes> <go-get-import-path-for-it>"
    return 1
  fi
  _REPO_DIR=$1
  _REPO_URL=$2

  cd $_REPO_DIR
  _PKG_PARENT_NAME=$(dirname $PWD)
  _PKG_NAME=$(basename $PWD)

  _PKG_NAME_IN_REPO=$(basename $_REPO_URL)
  if [ $_PKG_NAME_IN_REPO != $_PKG_NAME ]; then
    echo "Path for creating alpha doesn't match the import 'url' for it."
    return 1
  fi

  `go build -work . 2> /tmp/$_PKG_NAME`
  _BUILD_PATH=`cat /tmp/$_PKG_NAME | sed 's/WORK=//'`
  if [ ! -d $_BUILD_PATH ]; then
    echo "An error occured while building, it's recorded at /tmp/$_PKG_NAME"
    return 1
  fi
  rm -f /tmp/$_PKG_NAME

  _CURRENT_OBJECT_PATH="${GOPATH}/pkg/${GOOS}_${GOARCH}"
  _CURRENT_OBJECT="${_CURRENT_OBJECT_PATH}/${_REPO_URL}.a"
  _NEW_OBJECT="${_BUILD_PATH}/_${_PKG_PARENT_NAME}/${_PKG_NAME}.a"

  echo "Do you wanna backup current object? If yes enter a filename for it: "
  read GO_ALPHA_BACKUP
  if [ ! -z $GO_ALPHA_BACKUP ]; then
    mv $_CURRENT_OBJECT "${_CURRENT_OBJECT_PATH}/${_REPO_URL}/${GO_ALPHA_BACKUP}.backup"
  fi
  mv $_NEW_OBJECT $_CURRENT_OBJECT

  cd $_TMP_PWD
  echo "\nAlpha changes have been updated at ${_CURRENT_OBJECT}."
}

goenv_alpha_undo(){
  _TMP_PWD=$PWD
  if [ $# -ne 2 ]; then
    echo "Provide Alpha changes usable as any other go package."
    echo "Just the import path changes to 'alpha/<project-name>'"
    echo "SYNTAX: goenv_alpha <path-to-project-dir-with-alpha-changes> <go-get-import-path-for-it>"
    return 1
  fi
  _REPO_DIR=$1
  _REPO_URL=$2

  cd $_REPO_DIR
  _PKG_PARENT_NAME=$(dirname $PWD)
  _PKG_NAME=$(basename $PWD)

  _PKG_NAME_IN_REPO=$(basename $_REPO_URL)
  if [ $_PKG_NAME_IN_REPO != $_PKG_NAME ]; then
    echo "Path for creating alpha doesn't match the import 'url' for it."
    return 1
  fi

  _CURRENT_OBJECT_PATH="${GOPATH}/pkg/${GOOS}_${GOARCH}"
  _CURRENT_OBJECT="${_CURRENT_OBJECT_PATH}/${_REPO_URL}.a"
  _BACKUP_OBJECT="${_BUILD_PATH}/_${_PKG_PARENT_NAME}/${_PKG_NAME}.a"

  echo "Available package files are:"
  ls -1 $_CURRENT_OBJECT_PATH/$_REPO_URL | grep $_PKG_NAME | grep -v grep
  echo "Enter your backup filename for it: "
  read GO_ALPHA_BACKUP
  if [ -z $GO_ALPHA_BACKUP ]; then
    echo "\nNo Backup file was entered." ; return 1
  fi
  mv "${_CURRENT_OBJECT_PATH}/${_REPO_URL}/${GO_ALPHA_BACKUP}" $_CURRENT_OBJECT

  cd $_TMP_PWD
  echo "\nAlpha changes have been reverted with the provided backup file."
}

go_reget(){
  if [ $# -ne 1 ]; then
    echo "Cleans up source of Go Pkg from current GOPATH and re-(go get) it."
    echo "It moves it to /tmp/go/ path, if wanna undo something/anything."
    echo "SYNTAX: go_reget <path-provided-go-get>"
    return 1
  fi
  _REPO_URL=$1
  _PKG_OBJECT_PATH="${GOPATH}/pkg/${GOOS}_${GOARCH}/${_REPO_URL}.a"
  _PKG_PATH="${GOPATH}/pkg/${GOOS}_${GOARCH}/${_REPO_URL}"
  _SRC_PATH="${GOPATH}/src/${_REPO_URL}"
  _TMP_PARENT_PATH="/tmp/go/"$(dirname $_REPO_URL)

  rm -rf $_TMP_PARENT_PATH
  mkdir -p $_TMP_PARENT_PATH/pkg
  mkdir -p $_TMP_PARENT_PATH/src
  mv -f $_PKG_OBJECT_PATH $_TMP_PARENT_PATH/pkg
  mv -f $_PKG_PATH $_TMP_PARENT_PATH/pkg
  mv -f $_SRC_PATH $_TMP_PARENT_PATH/src

  go get $_REPO_URL
  echo "$_REPO_URL as been re-'go get'-ed"
}

goenv_rm(){
  if [ $# -ne 1 ]; then
    echo "Removes current given go-get path from GOPATH"
    echo "SYNTAX: goenv_rm <path-provided-go-get>"
    return 1
  fi
  _REPO_URL=$1
  rm -rf "${GOPATH}/src/${_REPO_URL}"
}

goenv_link(){
  if [ $# -ne 2 ]; then
    echo "Links up current dir to it's go-get location in GOPATH"
    echo "SYNTAX: goenv_linkme <local-repo-path> <path-provided-go-get>"
    return 1
  fi
  _REPO_DIR=$1
  _REPO_URL=$2

  _TMP_PWD=$PWD
  cd $_REPO_DIR

  if [ -d "${GOPATH}/src/${_REPO_URL}" ]; then
    echo "$_REPO_URL already exists at GOPATH $GOPATH"
    go get "${_REPO_URL}"
    return 1
  fi
  _REPO_BASEDIR=$(dirname "${GOPATH}/src/${_REPO_URL}")
  if [ ! -d "${_REPO_BASEDIR}" ]; then
    mkdir -p "${_REPO_BASEDIR}/src"
  fi

  ln -sf "${PWD}" "${GOPATH}/src/${_REPO_URL}"
  go get "${_REPO_URL}"

  cd $_TMP_PWD
}

alias goenv_linkme="goenv_link \$PWD"

goenv_unlink(){
  _LINK_PATH="${GOPATH}/src/${_REPO_URL}"
  if [ -L $_LINK_PATH ]; then
    rm -f $_LINK_PATH
  else
    echo "${_LINK_PATH} is not a Link."
    return 1
  fi
}

goenv_mylinks(){
  if [ -d "${GOPATH}/src/github.com" ]; then
    ls -l ${GOPATH}/src/github.com/*/ | grep '^l' | awk '{print $9,$10,$11}'
  fi
}

go_try_main(){
  _GO_TRY_FILENAME="go-try"
  if [[ $# -gt 0 ]]; then
    _GO_TRY_FILENAME="$1"
  fi
  _GO_TRY_FILE_COUNT=`ls $_GO_TRY_FILENAME* | wc -l`
  _GO_TRY_FILENAME="./${_GO_TRY_FILENAME}-${_GO_TRY_FILE_COUNT}.go"
  cat >> "${_GO_TRY_FILENAME}" << GOTRYEOF
package main

import (
  "fmt"
)

func main(){
  fmt.Println("It's a sample test file to quickly try out any Golang confusion.")

  // start here

  fmt.Println("If you don't need it anymore, just delete it.")
}

GOTRYEOF
  $EDITOR "${_GO_TRY_FILENAME}" 3>&1 1>&2 2>&3
}
