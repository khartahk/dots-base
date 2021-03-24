#########
# Tools #
#########
alias se='ls | grep'

alias aws='envchain ${AWS_PROFILE:-NULL} aws'
alias doctl='envchain ${AWS_PROFILE:-NULL} doctl'
alias env='envchain ${AWS_PROFILE:-NULL} env'

alias config='/usr/bin/git --git-dir=$HOME/.local/etc/.git/ --work-tree=$HOME/.local/etc/'
compdef _git config=git

# https://www.calazan.com/docker-cleanup-commands/ 
## Kill all running containers. 
alias dockerkillall='docker kill $(docker ps -q)'

## Delete all stopped containers. 
alias dockercleanc='printf "\n>>> Deleting stopped containers\n\n" && docker rm $(docker ps -a -q)'

## Delete all untagged images. 
alias dockercleani='printf "\n>>> Deleting untagged images\n\n" && docker rmi $(docker images -q -f dangling=true)'

## Delete all stopped containers and untagged images. 
alias dockerclean='dockercleanc || true && dockercleani'

alias dockerd='dockerkillall && dockerclean'

function dc_trace_cmd() {
  local parent=`docker inspect -f '{{ .Parent }}' $1` 2>/dev/null
  declare -i level=$2
  echo ${level}: `docker inspect -f '{{ .ContainerConfig.Cmd }}' $1 2>/dev/null`
  level=level+1
  if [ "${parent}" != "" ]; then
    echo ${level}: $parent
    dc_trace_cmd $parent $level
  fi
}

function git-fetch-all(){
  git branch -r | grep -v '\->' | while read remote; do git branch --track "${remote#origin/}" "$remote"; done
  git fetch --all
  git pull --all
}

function ebb () {
  if [[ ! -z "${1}" ]] && [[ "${1}" = "deploy" ]]; then
    eval "eb deploy ${@:2} --label \"manual-${$(git rev-parse HEAD):0:7}\""
  else
    eval "eb $@"
  fi
}

alias ebl="eb list"
alias ebp="eb printenv ${@}"
alias ebs="eb setenv -e ${@}"

function tgp {
  terragrunt plan "$@" | landscape
}

function tga {
  terragrunt apply "$@" | landscape
}

function tgi {
  terragrunt init "$@" | landscape
}

function tgd {
  terragrunt destroy "$@" | landscape
}

urlencode() {
    # urlencode <string>

    old_lc_collate=$LC_COLLATE
    LC_COLLATE=C

    local length="${#1}"
    for (( i = 0; i < length; i++ )); do
        local c="${1:$i:1}"
        case $c in
            [a-zA-Z0-9.~_-]) printf '%s' "$c" ;;
            *) printf '%%%02X' "'$c" ;;
        esac
    done

    LC_COLLATE=$old_lc_collate
}

urldecode() {
    # urldecode <string>

    local url_encoded="${1//+/ }"
    printf '%b' "${url_encoded//%/\\x}"
}
