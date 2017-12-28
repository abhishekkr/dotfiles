
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

## chef-generate special
alias chef-ckbk-nu=cookbook-nu
chef-nu-attr(){
  local ATTRIBUTE_NAME="$1"
  chef generate attribute . "${ATTRIBUTE_NAME}"
}
chef-nu-tmpl(){
  local TEMPLATE_NAME="$1"
  chef generate template . "${TEMPLATE_NAME}"
}
chef-nu-recp(){
  local RECIPE_NAME="$1"
  chef generate recipe . "${RECIPE_NAME}"
}
chef-nu-file(){
  local FILE_NAME="$1"
  chef generate file . "${FILE_NAME}"
}
chef-nu-lwrp(){
  local LWRP_NAME="$1"
  chef generate file . "${LWRP_NAME}"
}
chef-nu-plcy(){
  local POLICYFILE_NAME="$1"
  chef generate file "${POLICYFILE_NAME}"
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

##################### knife ############################

knife-bootstrap(){
  [[ $# -lt 1 ]] && \
    echo "usage: knife-bootstrap <MACHINE_IP> (<MACHINE_SSH_USER> <MACHINE_SSH_KEY> <SERVICE_ENVIRONMENT> <MACHINE_NAME> <KNIFE_RB_LOCATION>)" && \
    echo "" && \
    echo "can set specific env var MACHINE_SSH_USER, MACHINE_SSH_KEY, SERVICE_ENVIRONMENT, MACHINE_NAME, KNIFE_RB_LOCATION externally as well" && \
    return 1

  MACHINE_IP="$1"

  MACHINE_SSH_USER="-x $2"
  MACHINE_SSH_KEY="-i $3"
  SERVICE_ENVIRONMENT="-E $4"
  MACHINE_NAME="--node-name $5"
  KNIFE_RB_LOCATION="-c $6"

  local CHEF_VERSION="12.19.36"

  knife bootstrap ${MACHINE_IP} --bootstrap-version "${CHEF_VERSION}" "${MACHINE_SSH_USER}" "${MACHINE_SSH_KEY}" "${SERVICE_ENVIRONMENT}" -p 22 "${MACHINE_NAME}" --run-list "recipe[base]" --sudo --sudo-preserve-home "${KNIFE_RB_LOCATION}"
}


