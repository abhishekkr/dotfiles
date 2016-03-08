
##################### cookbook ###########################

## generate a new cookbook skeleton
cookbook-nu(){
  local COOKBOOK_NAME="$1"
  chef generate cookbook "${COOKBOOK_NAME}"
}

## generate $cookbook/.chef/... structure for vendor-ized shalreable structure
dot-chef(){
  mkdir -p "$PWD/.chef/{cookbooks,nodes,roles,data_bags}"
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
