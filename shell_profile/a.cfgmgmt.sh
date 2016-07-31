
##################### cookbook ###########################

## generate a new cookbook skeleton
cookbook-nu(){
  [[ $# -ne 1 ]] && echo "ERROR: No Cookbook name provided." && return
  local COOKBOOK_NAME="$1"
  chef generate cookbook "${COOKBOOK_NAME}"
}
alias ckbk-nu="cookbook-nu"

cookbook-nu-lwrp(){
  [[ $# -lt 1 ]] && echo "ERROR: No LWRP name provided." && return
  local LWRP_NAME="$1"
  local CKBK_PATH="$2"
  [[ -z "$CKBK_PATH" ]] && CKBK_PATH="$PWD"
  chef generate lwrp $CKBK_PATH $LWRP_NAME
}
alias ckbk-nu-lwrp="cookbook-nu-lwrp"

cookbook-nu-recipe(){
  [[ $# -lt 1 ]] && echo "ERROR: No Recipe name provided." && return
  local RECIPE_NAME="$1"
  local CKBK_PATH="$2"
  [[ -z "$CKBK_PATH" ]] && CKBK_PATH="$PWD"
  chef generate recipe $CKBK_PATH $RECIPE_NAME
}
alias ckbk-nu-recipe="cookbook-nu-recipe"

cookbook-nu-template(){
  [[ $# -lt 1 ]] && echo "ERROR: No Template name provided." && return
  local TEMPLATE_NAME="$1"
  local CKBK_PATH="$2"
  [[ -z "$CKBK_PATH" ]] && CKBK_PATH="$PWD"
  chef generate template $CKBK_PATH $TEMPLATE_NAME
}
alias ckbk-nu-template="cookbook-nu-template"

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

##################### knife   ############################
ckbk-supermarket(){
  [[ $# -ne 1 ]] && echo "Usage: ckbk-supermarket <ckbk-name>" && return
  local COOKBOOK_NAME="$1"
  knife cookbook site show ${COOKBOOK_NAME} | grep latest_version
}

##################### kitchen ############################
kitchen-login(){
  local _NODE="$@"
  kitchen login $_NODE
}
kitchen-exec(){
  local _KITCHEN_CMD="$@"
  kitchen exec -c "$_KITCHEN_CMD ; echo"
}
kitchen-node-exec(){
  local _NODE=$1
  local _KITCHEN_CMD="${@:2}"
  kitchen exec $_NODE -c "$_KITCHEN_CMD ; echo"
}
kitchen-test(){
  local _NODE="$@"
  kitchen test $_NODE
}
kitchen-recreate(){
  local _NODE="$@"
  kitchen destroy "$_NODE" && kitchen converge "$_NODE"
}
alias kitchen-reverify="kitchen destroy && kitchen converge && kitchen verify"
alias kitchen-create="kitchen create"
alias kitchen-converge="kitchen converge"
alias kitchen-destroy="kitchen destroy"
alias kitchen-verify="kitchen verify"
alias kitchen-ls="kitchen list"
