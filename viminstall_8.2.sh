#!/bin/bash

# < README >
# This is Vim8.2 reinsatll scripts in centos7

 # vim install package

yum install -y gcc make ncurses ncurses-devel \
ctags git tcl-devel \
ruby ruby-devel \
lua lua-devel \
luajit luajit-devel \
python python-devel \
perl perl-devel \
perl-ExtUtils-ParseXS \
perl-ExtUtils-XSpp \
perl-ExtUtils-CBuilder \
perl-ExtUtils-Embed

 # remove existing vim installation

yum remove -y vim-enhanced vim-common vim-filesystem

 # download vim source from git

sudo git clone https://github.com/vim/vim.git
cd vim
./configure --with-features=huge \
--enable-multibyte \
--enable-rubyinterp \
--enable-pythoninterp \
--enable-perlinterp \
--enable-luainterp

make
make install

cd src
present_path=(`pwd`)
 
 # add '/usr/bin' symbolic link  
ln -s $present_path/vim /usr/bin/vim

vim -V
