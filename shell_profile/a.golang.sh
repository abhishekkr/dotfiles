#profile for golang

export GOPATH=$HOME/.go/site
export GO_HOME=$HOME/.go
export GOOS=linux
export GOARCH=amd64

[ -s $GOPATH ] && mkdir -p $GOPATH

alias gofmt-fix="gofmt -l -w -s"

go_clr(){
  go run "$@"
}
go_help(){
  echo 'Go Docs are available at http://localhost:9090'
  godoc -http=:9090
}

goenv_on(){
  if [ ! -d ./.goenv ]; then
    mkdir -p ./.goenv/site
  fi
  _OLD_GOPATH=$GOPATH
  _OLD_PATH=$PATH
  GOPATH=$PWD/.goenv/site
  PATH=$PATH:$GOPATH/bin
}
goenv_off="GOPATH=$_OLD_GOPATH ; PATH=$_OLD_PATH"

go_get_pkg(){
  if [ $# -eq 0 ]; then
    if [ -f "$PWD/go-get-pkg.txt" ]; then
      PKG_LISTS="$PWD/go-get-pkg.txt"
    else
      touch "$PWD/go-get-pkg.txt"
      echo "Created GoLang Package empty list $PWD/go-get-pkg.txt"
      echo "Start adding package paths as separate lines." && return 0
    fi
  else
    PKG_LISTS=($@)
  fi
  for pkg_list in $PKG_LISTS; do
    cat $pkg_list | while read pkg_path; do
        echo "fetching golag package: go get ${pkg_path}";
        echo $pkg_path | xargs go get
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
  echo "${_CURRENT_OBJECT_PATH}/${_REPO_URL}/${GO_ALPHA_BACKUP}.backup"
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
  GOPATH_PKG_PATH="${GOPATH}/src/$1"
  echo "Reget to "$GOPATH_PKG_PATH
  if [ $# -ne 1 -o ! -d $GOPATH_PKG_PATH ]; then
    echo "Cleans up source of Go Pkg from current GOPATH and re-(go get) it."
    echo "It moves it to an announced path, if wanna undo something/anything."
    echo "SYNTAX: go_reget <path-provided-go-get>"
    return 1
  fi
  TMP_GOPKG_PATH="/tmp/golang-packages/${GOPATH_PKG_PATH}"
  mkdir -p $TMP_GOPKG_PATH
  mv $GOPATH_PKG_PATH $TMP_GOPKG_PATH
  go get "$1"
}
