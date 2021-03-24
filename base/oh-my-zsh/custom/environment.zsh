#!/usr/bin/env bash

# XDG directories
export XDG_CONFIG_HOME="$HOME/.config"
export  XDG_CACHE_HOME="$HOME/.cache"
export   XDG_DATA_HOME="$HOME/.local/share"

#export PATH="$PATH:./node_modules/.bin:$(ruby -e 'puts Gem.user_dir')/bin"
export _PATHS=( "$HOME/.local/bin" )
for P in "${_PATHS[@]}"
do
  if [[ "$PATH" != *"$P"* ]]; then
    export PATH="$PATH:$P"
  fi
done

# Generated by /usr/bin/select-editor
export EDITOR=$(hash vim 2>/dev/null && echo '/usr/bin/vim' || echo '/usr/bin/vi')

# terraform configuration
if hash terraform 2>/dev/null
then
  export TF_PLUGIN_CACHE_DIR="${HOME}/.cache/terraform-plugin-cache"
fi

# nodejs's NPM tool configuration
if hash npm 2>/dev/null
then
  export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
  export NPM_CONFIG_DEVDIR="$XDG_CACHE_HOME/node-gyp"
  export PATH="$PATH:$HOME/.local/lib/nodejs/bin"
fi

# GO
## Don't overrwrite an already configured GOPATH
if hash go 2>/dev/null && [ -z "${GOPATH+1}" ]
then
  export GOPATH="$HOME/.local/lib/go"
  export GO111MODULE=on
  export PATH="$PATH:$GOPATH/bin"
fi

if hash aws 2>/dev/null
then
  # Set up aws bash completion
  complete -C "$HOME/.local/bin/aws_completer" aws
  export AWS_CONFIG_FILE="$XDG_CONFIG_HOME/aws/config"
  export AWS_SHARED_CREDENTIALS_FILE="$XDG_CONFIG_HOME/aws/credentials"
fi

if hash ruby 2>/dev/null
then
  #export GEM_HOME=$(ruby -e 'puts Gem.user_dir')
  export GEM_HOME="$HOME/.local/lib/gem/ruby/$(ruby -e 'puts RUBY_VERSION')"
  export PATH="$PATH:$GEM_HOME/bin"
fi

if hash rbenv 2>/dev/null
then
  export RBENV_ROOT="$HOME/.local/lib/rbenv"
fi

hash ansible 2>/dev/null && export     ANSIBLE_CONFIG="$XDG_CONFIG_HOME/ansible/config.ini"
hash docker  2>/dev/null && export      DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"
hash gpg     2>/dev/null && export          GNUPGHOME="$XDG_CONFIG_HOME/gnupg"
hash psql    2>/dev/null && export         PGPASSFILE="$XDG_CONFIG_HOME/psql/pgpass"
hash psql    2>/dev/null && export             PSQLRC="$XDG_CONFIG_HOME/psql/psqlrc"

if hash tfenv 2>/dev/null && hash terraform 2>/dev/null
then
  complete -o nospace -C "$HOME/.local/lib/tfenv/versions/$(tfenv version-name)/terraform" terraform
  complete -o nospace -C "$HOME/.local/lib/tfenv/versions/$(tfenv version-name)/terraform" terragrunt
fi

# less
## Less history file and key file
export LESSHISTFILE="$XDG_CACHE_HOME/less_history"
export LESSKEY="$XDG_CONFIG_HOME/less/keyfile.bin"

if hash doctl 2>/dev/null
then
  source <(doctl completion zsh)
fi

# Source completions for the dots utility
if hash dots 2>/dev/null
then
  source "$HOME/.local/lib/dots/contrib/bash_completion"
fi

# Include environment configurations from DATA_HOME
if [ -d "$XDG_DATA_HOME/environment.d" ]
then
  for f in "$XDG_DATA_HOME/environment.d/"*; do source "$f"; done
fi
