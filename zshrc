#!/bin/zsh

# Aliases
alias vim="nvim"
alias aurora="arch -x86_64 aurora"

export PROJECTS=~/projects

web-ui-up() {
   cd $PROJECTS/app/service/web/web-ui
   docker-compose up -d web-proxy
   switch-java 11
   npm i
   lein refresh
   tmuxp load amp-web-ui
}

nuke-m2() {
   rm -rf ~/.m2
   cd $PROJECTS/app/services/web/web-ui
   lein monolith clear-fingerprints
   lein refresh
}

restart-all() {
   echo Restarting all docker containers
   (cd $PROJECTS/app/util/docker && docker compose down && docker compose up -d --force-recreate)
   (cd $PROJECTS/app/service/web/web-ui && docker compose restart web-proxy)
}

# Path
path+=($PROJECTS'/app/bin')
path+=('/root/.local/bin')
export PATH

# Specify default editor. Possible values: vim, nano, ed etc.
export EDITOR=vim

# Prompt
PROMPT='%F{51}%1d%f $'

# Enable autocomplete
autoload -Uz compinit && compinit

# Allow switching between java versions
switch-java() {
  export JAVA_HOME=$(/usr/libexec/java_home -v $1)
  java -version
}
switch-java 11 2> /dev/null

# Fix performance issues with lein
export GODEBUG=asyncpreemptoff=1

export VAULT_ADDR="https://vault.amperity.top:8200"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/spencerwolf/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/spencerwolf/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/spencerwolf/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/spencerwolf/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

