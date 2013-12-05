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
  if [ $# -ne 1 ]; then
    echo "Provide Alpha changes usable as any other go package."
    echo "Just the import path changes to 'alpha/<project-name>'"
    echo "SYNTAX: goenv_alpha <path-to-project-dir-with-alpha-changes>"
    return 1
  fi
  PKG_PATH=$1
  PKG_NAME=`echo $PKG_PATH | sed 's/.*\///g'`
  GOPATH_SRC_PATH="${GOPATH}/src/alpha/${PKG_NAME}"
  GOPATH_PKG_PATH="${GOPATH}/pkg/alpha/${PKG_NAME}"
  mkdir -p $GOPATH_PKG_PATH
  cp -rudan $PKG_PATH $GOPATH_SRC_PATH
  cd $GOPATH_SRC_PATH
  go build
  cd $_TMP_PWD
}

go_reget(){
  GOPATH_PKG_PATH="${GOPATH}/src/$1"
  if [ $# -ne 1 -o -d $GOPATH_PKG_PATH ]; then
    echo "Cleans up source of Go Pkg from current GOPATH and re-(go get) it."
    echo "It moves it to an announced path, if wanna undo something/anything."
    echo "SYNTAX: go_reget <path-provided-go-get>"
    return 1
  fi
  TMP_GOPKG_PATH="/tmp/golang-packages/${GOPATH_PKG_PATH}"
  mkdir -p $TMP_GOPKG_PATH
  mv $GOPATH_PKG_PATH $TMP_GOPKG_PATH
}
