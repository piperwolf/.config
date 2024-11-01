#!/bin/zsh

# Aliases
alias vim="nvim"
alias aurora="arch -x86_64 aurora"
alias g="git status"

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
   cd $PROJECTS/app/util/amperity-connector-template
   lein install
   cd $PROJECTS/app
   lein monolith each :parallel 4 :refresh build :report install
   echo "If this breaks, maybe uncomment lein-template in profile.clj"
   echo "Sometimes installing upstream works"
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

upstream-install() {
   lein monolith each :upstream :parallel 4 install
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

initial-install() {
  # CLJ Kondo
  curl -sLO https://raw.githubusercontent.com/clj-kondo/clj-kondo/master/script/install-clj-kondo
  chmod +x install-clj-kondo
  ./install-clj-kondo
  # tmux plugins
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
}

# For some reason this incanatation works `aws-profile DeveloperAccess-SpencerWolf`
aws-profile () {
  export AWS_PROFILE="$1"
  aws sso login
  aws configure list
}

# File Utils

# Function to create a file and any necessary directories
touchm() {
  mkdir -p "$(dirname "$1")" && touch "$1"
}

# Function to copy a file and create any necessary directories
cpm() {
  mkdir -p "$(dirname "$2")" && cp "$1" "$2"
}

# Function to move a file and create any necessary directories
mvm() {
  mkdir -p "$(dirname "$2")" && mv "$1" "$2"
}

# OPENAPI Variables
#
export OPENAI_API_BASE="https://amperity-engineering.openai.azure.com"
export OPENAI_TYPE=azure
export OPENAI_API_VERSION="2024-02-01"
export OPENAI_DEPLOYMENT_NAME="gpt-4o"

ask() {
  [[ -z ${OPENAI_API_KEY} ]] && export OPENAI_API_KEY=$(vault read -field=key az-stage/secret/service/openai/amperity-engineering)
  # Check if there's input from a pipe. If there is, store it in the 'message' variable.
  if [ -p /dev/stdin ]; then
    message_segment=",{\"role\":\"user\",\"content\":$(cat | jq -Rs .)}"
  else
    message_segment=""
  fi

  # Structured message for the assistant
  system_message=$(echo "You are an AI assistant who follows instructions carefully providing consise responses without restating the question. Prefer using lists when appropriate. Use markdown syntax to format responses, only wrapping the response in a code block when necessary." | jq -Rs .)
  user_message=$(echo "$1" | jq -Rs .)

  message_to_assistant="{
    \"messages\": [
      {\"role\":\"system\",\"content\":$system_message},
      {\"role\":\"user\",\"content\":$user_message}
      $message_segment
    ],
    \"max_tokens\": 800,
    \"temperature\": 0.7,
    \"frequency_penalty\": 0,
    \"presence_penalty\": 0,
    \"top_p\": 0.95,
    \"stop\": null
  }"

  # cURL request
  response=$(curl "$OPENAI_API_BASE/openai/deployments/$OPENAI_DEPLOYMENT_NAME/chat/completions?api-version=$OPENAI_API_VERSION" \
    -s \
    -H "Content-Type: application/json" \
    -H "api-key: $OPENAI_API_KEY" \
    --data-binary "$message_to_assistant")

  # Extract the message content with jq and print
  content=$(jq -r '.choices[0].message.content' <<< "$response")
  pbcopy <<< $content
  echo "$content"
}

ui-flake-test() {
  npx shadow-cljs compile ci
  # Run karma tests 50 times to check for flakiness and report the results
  for i in {1..50}; do
      echo "Running tests iteration $i"
      npx karma start --single-run
      if [ $? -ne 0 ]; then
          echo "Tests failed on iteration $i"
      fi
    done
}
