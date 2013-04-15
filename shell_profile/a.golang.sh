#profile for golang

export GO_HOME=/home/abhishekkr/ABK/applications/google/go
export GOOS=linux
export GOARCH=amd64

function go_clr(){
  $GO_HOME/bin/6g $@.go
  $GO_HOME/bin/6l $@.6
}
function go_help(){
  echo 'Go Docs are available at http://localhost:9090'
  $GO_HOME/bin/godoc -http=:9090
}
