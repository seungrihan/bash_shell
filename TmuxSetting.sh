#!/bin/bash
# reference link : https://edward0im.github.io/technology/2020/09/28/tmux/

 # donwload tmux_conf
wget https://edward0im.github.io/files/200929/tmux_conf
mv ./tmux_conf ~/.tmux.conf

 # checking git package
  
chk_git=(`rpm -qa | grep '^git'| wc -l`)
 
 if [ $chk_git == '1' ]; then
   echo "[INFO] git is installed"
 else [ $chk_git == '0' ]
   echo "[INFO] start git installation !!"
   yum install -y git
 fi

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
git clone https://github.com/powerline/fonts
cd fonts/
present_path=(`pwd`)
$present_path/install.sh

cat << 'EOF' > ~/.bashrcadd

# tmux 
alias tmux='TERM=xterm-256color tmux -2 -u'
alias tl='tmux ls'                    # session list
alias td='tmux detach'                # detatch session
alias tk='tmux kill-session -t '      # kill session
alias t4='tmux -u new-session -d    
tmux split-window -v
tmux split-window -h
tmux select-pane -U
tmux split-window -h
tmux select-pane -L
tmux attach-session -d'

# tmux function for attaching, switching, creating in one command.
function t() {
        if [ -z "$1" ]; then
                tmux
        elif [ -z ${TMUX} ]; then
                tmux attach -t $1
        else 
                tmux switch -t $1
        fi
}
EOF

let isexist=(`cat ~/.bashrc | grep '^# tmux' | wc -l`)

if [ $isexist -ge 1 ]; then
   echo "option is isexisted"
else 
   cat ~/.bashrcadd >> ~/.bashrc
fi

source ~/.bashrc
