#!/bin/bash

# < README >
# This is CentOS7 tmux2.8 install script
# checking reference below and How to use the tmux manual
# reference link : https://edward0im.github.io/technology/2020/09/28/tmux/

echo "[INFO] tmux 2.8 install start"

# Install package
echo "[INFO] tmux preferences package install"
yum install -y gcc kernel-devel make ncurses-devel

# Upgrade libevent-2.1.8
echo "[INFO] Install & update libevent-2.1.8"
curl -LOk https://github.com/libevent/libevent/releases/download/release-2.1.8-stable/libevent-2.1.8-stable.tar.gz
tar -xf libevent-2.1.8-stable.tar.gz
cd libevent-2.1.8-stable
./configure --prefix=/usr/local
make
make install

# DOWNLOAD SOURCES FOR TMUX AND MAKE AND INSTALL
cd ../
echo "[INFO] Download tmux 2.8 file"
curl -LOk https://github.com/tmux/tmux/releases/download/2.8/tmux-2.8.tar.gz
tar -xf tmux-2.8.tar.gz
cd tmux-2.8
LDFLAGS="-L/usr/local/lib -Wl,-rpath=/usr/local/lib" ./configure --prefix=/usr/local
make
make install

# MAKE 'tmux' SYMBOLIC LINK TO '/usr/bin'

ln -s /usr/local/bin/tmux /usr/bin/tmux

echo "[INFO] Tmux 2.8 install complete"
echo "[INFO] Checking tmux version.."
tmux -V
