#!/bin/zsh

# Aliases
alias vim="nvim"
alias aurora="arch -x86_64 aurora"

export PROJECTS=~/projects

vtoken-reg() {
   vault login -method=github token="$1"
   cp ~/.vault-token ~/.vault-copy
}

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
   docker logs docker-linkerd-1 &> ~/Downloads/linkerd-logs.txt
   echo Logs written to ~/Downloads/linkerd-logs.txt
   docker inspect --format='' docker-linkerd-1 | jq -r ".[0].State.Health"
   (cd $PROJECTS/app/util/docker && docker compose down && docker compose up -d --force-recreate)
   (cd $PROJECTS/app/service/web/web-ui && docker compose down && docker compose up -d --force-recreate)
   docker inspect --format='' docker-linkerd-1 | jq -r ".[0].State.Health"
}

print-wipe() {
   rm $PROJECTS/app/.lein-monolith-fingerprints
   lein refresh
}

bbr() {
   rlwrap bb
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

jira-bulk-root () {
 if [[ -z "$1" || "$1" =~ '^(-h)|(--help)$' ]]; then;
   printf "\n  Root all tickets matching the query <jql> to ticket <root ticket>"
   printf "\n  • Usage:   jira-bulk-root <root-ticket> <jql>"
   printf "\n  • Example: jira-bulk-root MAX-0000 'text ~ \"glow task failed\" and project = ops and created >= \"-7d\" and text ~ johnnywas and statuscategory != done'\n\n"
 elif [ -z "$2" ]; then;
   printf "\n  Please include a JQL query string for the tickets to root\n\n"
 else
   jira ls -q $2 -t table
   printf "Going to link all of the above tickets, saying that they are 'Caused by' ticket  '$1'\n"
   printf "%s" "Press <Enter> to continue…"
   read ans
   for ticket in $(jira ls -q $2 | rg '^.*?(?=:)' -o --pcre2); do;
     jira issuelink $ticket "1 Problem/Incident" $1
   done
 fi
}

vtoken() {
    cp ~/.vault-copy ~/.vault-token
    TOKEN=`vault token create -field=token`
    export VAULT_TOKEN=$TOKEN
    echo $VAULT_TOKEN | pbcopy
}
