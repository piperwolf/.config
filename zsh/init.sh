#!/bin/zsh

# Aliases
alias vim="nvim"
alias alias aurora="arch -x86_64 aurora"

# Specify default editor. Possible values: vim, nano, ed etc.
export EDITOR=vim

#Prompt
PROMPT='%F{51}%1d%f $'

# Allow switching between java versions
switch-java() {
  export JAVA_HOME=$(/usr/libexec/java_home -v $1)
  java -version
}
switch-java 1.8 2> /dev/null

