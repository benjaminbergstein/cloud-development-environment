eval `ssh-agent`
ssh-add ~/id_rsa

export GIT_EDITOR="vim"

source secrets.bash

PS1="[\[\033[32m\]\w]\[\033[0m\]\$(__git_ps1)\n\[\033[1;36m\]\u\[\033[32m\]$ \[\033[0m\]"
