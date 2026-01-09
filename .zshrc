#!/bin/bash
echo "Loading your '.bash_profile'..."

#export PATH=/Library/Frameworks/Python.framework/Versions/2.7/bin/:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH
sourced_pathmunge () {
        if ! echo $PATH | /usr/bin/egrep -q "(^|:)$1($|:)" ; then
           if [ "$2" = "after" ] ; then
              PATH=$PATH:$1
           else
              PATH=$1:$PATH
           fi
        fi
}
# Maybe just place the above function as a script into usr/sbin...  meh..
# sourced_pathmunge '/Library/Frameworks/Python.framework/Versions/2.7/bin/' after

# Misc stuff
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
export HISTSIZE=10000
export HISTFILESIZE=10000
# VirtualEnvWrapper
export WORKON_HOME=~/Envs
# If credstash exists, export some stuff. Otherwise say it needs to be installed.
if [ -x "$(command -v credstash)" ]; then
    export DATADOG_API_KEY=$(credstash get datadog_api_key)
    export DATADOG_APP_KEY=$(credstash get datadog_terraform_app_key)
    export TF_VAR_pagerduty_token=$(credstash get pagerduty_terraform_api_key)
else
    echo -e "[WARN] cannot find credstash, skipping some environment setup steps..."
fi

# Aliases
alias ll='ls -alh'
alias ga='git add'
alias gp='git push'
alias gl='git log'
alias gs='git status'
alias gd='git diff'
alias gm='git commit -m'
alias gcm='git commit -m'
alias gma='git commit -am'
alias gb='git branch'
alias gc='git checkout'
alias gra='git remote add'
alias grv='git remote -v'
alias grr='git remote rm'
alias gpu='git pull'
alias gcl='git clone'
alias cd..='cd ..'
alias cd-='cd -'
#ldapsearchusergroups () { ldapsearch -h ldap.aws.cainc.com -p 389 -x -b "dc=aws,dc=cainc,dc=com" "(\&(cn=\*)(memberUid=\$1))" dn | awk -F[=,] "/dn:/ {print \$2}"; }

# for sourceme alias
if ! [ -L ~/.bash_profile ]; then
    ln -s ~/dev/github.com/philax/bash_profile/.bash_profile ~/.bash_profile
fi
alias sourceme='source ~/.bash_profile'

# Start SSH Agent. 'ssh-add' keys if you wish to to preserve passwords during this session
if [ -f ~/.agent.env ] ; then
    . ~/.agent.env > /dev/null
    if ! kill -0 $SSH_AGENT_PID > /dev/null 2>&1; then
        echo "Stale agent file found. Spawning new agent… "
        eval `ssh-agent | tee ~/.agent.env`
        ssh-add
    fi 
else
    echo "Starting ssh-agent"
    eval `ssh-agent | tee ~/.agent.env`
    ssh-add
fi

# Brew bash completion
if [ -f `brew --prefix`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion
fi

if [ -f `brew --prefix`/etc/bash_completion.d/git-prompt.sh ]; then
  . `brew --prefix`/etc/bash_completion.d/git-prompt.sh
fi

# Sublime Linking for cmd line usage
if [ -f '/Applications/Sublime text.app' ]; then
	if [ ! -h '/usr/local/bin/subl' ]; then
		ln -s "/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl" /usr/local/bin/subl
	fi
fi

# AWS CLI Bash AutoCompletion
complete -C '/usr/local/bin/aws_completer' aws

# Show git branch in console
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWCOLORHINTS=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWUPSTREAM="auto"
# source ~/dev/github.com/philax/bash_profile/.git-prompt.sh
# source ~/dev/github.com/philax/bash_profile/.git-completion.zsh
# source ~/dev/github.com/philax/bash_profile/.git-completion.bash

# PROMPT="$(__git_ps1 " \[\033[1;32m\] (%s)\[\033[0m\]")\$"$
# setopt prompt_subst
# autoload -Uz vcs_info
# zstyle ':vcs_info:*' actionformats \
#     '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
# zstyle ':vcs_info:*' formats       \
#     '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{5}]%f '
# zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'

# zstyle ':vcs_info:*' enable git cvs svn

# # or use pre_cmd, see man zshcontrib
# vcs_info_wrapper() {
#   vcs_info
#   if [ -n "$vcs_info_msg_0_" ]; then
#     echo "%{$fg[grey]%}${vcs_info_msg_0_}%{$reset_color%}$del"
#   fi
# }
# RPROMPT=$'$(vcs_info_wrapper)'

# Old example, likely broken. PS1='\[\033[32m\]\u@\h\[\033[00m\]:\[\033[34m\]\w\[\033[31m\]$(__git_ps1)\[\033[00m\]\$ '

# Henning's awesome TRON prompt 2.0.2 with current Git branch and success state of the last command (the syntax coloring here does not do it justice), from https://makandracards.com/makandra/1090-customize-bash-prompt:
# export PS1='`if [ $? = 0 ]; then echo "\[\033[01;32m\]✔"; else echo "\[\033[01;31m\]✘"; fi` \[\033[01;30m\]\h\[\033[01;34m\] \w\[\033[35m\]$(__git_ps1 " %s") \[\033[01;30m\]>\[\033[00m\] ' => ✔ mycomputer ~/projects/platforms master > _


# virtualenvwrapper sourcing
if [ -f '/usr/local/bin/virtualenvwrapper.sh' ]; then
    source /usr/local/bin/virtualenvwrapper.sh
else
    echo "[WARN] Missing virtualenvwrapper. Google me for install steps if you expect this to be there, sorry bro."
fi

# programs to install via brew:
# tfenv reqs you to do the below line first, then unlinking terraform so tfenv can control tf versions
# sudo xcodebuild -license accept
# brew install httpie autoenv python3 cowsay openssl wget wireshark consul jq gpg jsonlint shellcheck watch jp -y
# brew install tfenv -y
# tfenv install 0.9.11
# extended / java programs to install via brew:
# brew tap caskroom/versions
# brew cask install pgadmin4 mysqlworkbench java8 charles brave postman -y # jce-unlimited-strength-policy8 -y
# brew install mysql@5.6 tomcat@8.0 ant@1.9 -y
# # Install java8 even though higher versions of java exist
brew update
# brew install font-fira-code
# make sure to install fira-code on vstudio as well
# brew install jq wget openssl wireshark
# install zsh git prompt stuff, cus I'm sick of fiddling with it
# brew install starship

# brew services list

# echo "Currently installed via 'brew list'..."
# brew list
# echo "-------^ Currently installed via Brew ^-------"

# Java Stuff
# if [ -d '/usr/local/Cellar/tomcat@8.0/8.0.43' ]; then
#     export CATALINA_HOME=/usr/local/Cellar/tomcat@8.0/8.0.43
# else
#     echo "Missing Tomcat8. Run: brew install tomcat@8.0"
# fi
# if [ -d '/Library/Java/JavaVirtualMachines/jdk1.8.0_144.jdk/Contents/Home' ]; then
#     export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_144.jdk/Contents/Home
# else
#     echo "Missing Tomcat8. Run: brew cask install java8 if you want it."
# fi

# MAVEN WHATNOT
# export M2_OPTS=-Xmx1536m
# export M2_HOME=/usr/local/Cellar/maven/3.5.0

export NVM_DIR="$HOME/.nvm"
#[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Setting PATH for Python 3.8
# The original version is saved in .bash_profile.pysave
# Commenting this out, likely out of date in 2026, as 3.8 is ye olde
# PATH="/Library/Frameworks/Python.framework/Versions/3.8/bin:${PATH}"
# export PATH

# Setting up pyenv for easy env swapping
echo "Setting up pyenv for easy env swapping..."
eval "$(pyenv init -)"

# ensure starship, the zsh git prompt stuff, is initialized
eval "$(starship init zsh)"
# starship preset nerd-font-symbols -o ~/.config/starship.toml
starship preset plain-text-symbols -o ~/.config/starship.toml

echo "Sourced. Have a nice day!"

##
# Your previous /Users/plaks/.bash_profile file was backed up as /Users/plaks/.bash_profile.macports-saved_2020-04-24_at_14:07:59
##

# MacPorts Installer addition on 2020-04-24_at_14:07:59: adding an appropriate PATH variable for use with MacPorts.
# probably out of date, commenting this out in 2026.
# export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
# Finished adapting your PATH environment variable for use with MacPorts.

