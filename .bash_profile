#PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin/:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
#export PATH
# Chef Stuff
CHEF_ORGNAME=techops-dev
CHEF_DOMAIN=fos.pri
export CHEF_ORGNAME
export CHEF_DOMAIN
# kubernetes stuff
export KUBERNETES_PROVIDER=vagrant
# Misc stuff
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
#export VAGRANT_SERVER_URL=https://vagrantcloud.dgs.io
#export PATH="/opt/chefdk/embedded/bin:$PATH"
#export PATH="/opt/chefdk/bin:$PATH"

# golang stuff
export GOROOT=/usr/local/go
export GOPATH=$HOME/GitHub/Dev/golang/workspace

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

# Brew bash completion
if [ -f `brew --prefix`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion
fi

if [ -f `brew --prefix`/etc/bash_completion.d/git-prompt.sh ]; then
  . `brew --prefix`/etc/bash_completion.d/git-prompt.sh
fi

# Show git branch in console
GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWCOLORHINTS=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWUPSTREAM="auto"

PS1='\[\033[32m\]\u@\h\[\033[00m\]:\[\033[34m\]\w\[\033[31m\]$(__git_ps1)\[\033[00m\]\$ '

# ChefDK system ruby setup
eval "$(chef shell-init bash)"

# docker-machine quick start.  dockify will start the default docker-machine if it isn't running. attachd will attach it to your current shell.

alias dockify='. "/Applications/Docker/Docker Quickstart Terminal.app/Contents/Resources/Scripts/start.sh"'
alias attachd="attachd"

function attachd
{
eval "$(docker-machine env default)"
echo "Docker machine attached"
}
