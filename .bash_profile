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
source ~/dev/github.com/philax/bash_profile/.git-prompt.sh


PS1='\[\033[32m\]\u@\h\[\033[00m\]:\[\033[34m\]\w\[\033[31m\]$(__git_ps1)\[\033[00m\]\$ '

# virtualenvwrapper sourcing
if [ -f '/usr/local/bin/virtualenvwrapper.sh' ]; then
    source /usr/local/bin/virtualenvwrapper.sh
else
    echo "Missing virtualenvwrapper.  google me for install steps if you expect this to be there, sorry bro."
fi

# programs to install via brew:
# tfenv reqs you to do the below line first, then unlinking terraform so tfenv can control tf versions
# sudo xcodebuild -license accept
# brew install httpie autoenv python3 cowsay openssl wget wireshark consul jq gpg -y
# brew install tfenv -y
# tfenv install 0.9.11
# extended / java programs to install via brew:
# brew tap caskroom/versions
# brew cask install pgadmin4 mysqlworkbench java8 charles brave -y # jce-unlimited-strength-policy8 charles -y
# brew install mysql@5.6 tomcat@8.0 ant@1.9 -y
# # Install java8 even though higher versions of java exist
# 
# brew services list

# Java Stuff
if [ -d '/usr/local/Cellar/tomcat@8.0/8.0.43' ]; then
    export CATALINA_HOME=/usr/local/Cellar/tomcat@8.0/8.0.43
else
    echo "Missing Tomcat8. Run: brew install tomcat@8.0"
fi
if [ -d '/Library/Java/JavaVirtualMachines/jdk1.8.0_144.jdk/Contents/Home' ]; then
    export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_144.jdk/Contents/Home
else
    echo "Missing Tomcat8. Run: brew cask install java8"
fi

# MAVEN WHATNOT
export M2_OPTS=-Xmx1536m
export M2_HOME=/usr/local/Cellar/maven/3.5.0

echo "Sourced. Have a nice day!"

