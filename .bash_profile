#export PATH=/Library/Frameworks/Python.framework/Versions/2.7/bin/:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH
# Misc stuff
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
export HISTSIZE=10000
export HISTFILESIZE=10000
# VirtualEnvWrapper
export WORKON_HOME=~/Envs

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
alias sourceme='source ~/dev/github/philax/bash_profile/.bash_profile'

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
source ~/dev/github/philax/bash_profile/.git-prompt.sh


PS1='\[\033[32m\]\u@\h\[\033[00m\]:\[\033[34m\]\w\[\033[31m\]$(__git_ps1)\[\033[00m\]\$ '

# virtualenvwrapper sourcing
source /usr/local/bin/virtualenvwrapper.sh

echo "INFO: If this is the first run, uncomment the top line to export PATH correctly, then continue.
Otherwise, have a nice day!"

# programs to install via brew:
# brew install httpie autoenv python3 cowsay openssl wget wireshark terraform
