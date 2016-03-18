
##################### cookbook ###########################

## generate a new cookbook skeleton
cookbook-nu(){
  local COOKBOOK_NAME="$1"
  chef generate cookbook "${COOKBOOK_NAME}"
}

## generate $cookbook/.chef/... structure for vendor-ized shalreable structure
dot-chef(){
  mkdir -p .chef/{cookbooks,nodes,roles,data_bags}
}

##################### Berkshelf ##########################
berks-vendor(){
  local VENDOR_DIR="${PWD}/.chef/cookbooks"
  if [[ ! -d "$VENDOR_DIR" ]]; then
    echo "ERROR: No '.chef/cookbooks' present, creating."
    mkdir .chef/cookbooks
  fi
  berks vendor "${VENDOR_DIR}"
}

##################### chef-spec ##########################
alias chef-exec="chef exec"
alias chef-spec="chef exec rspec spec"

##################### kitchen ############################
kitchen-exec(){
  local _KITCHEN_CMD="$@"
  kitchen exec -c "$_KITCHEN_CMD ; echo"
}
kitchen-test(){
  kitchen test -c
}
alias kitchen-recreate="kitchen destroy && kitchen converge"
alias kitchen-reverify="kitchen destroy && kitchen converge && kitchen verify"
alias kitchen-create="kitchen create"
alias kitchen-converge="kitchen converge"
alias kitchen-destroy="kitchen destroy"
alias kitchen-verify="kitchen verify"
