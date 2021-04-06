#!/bin/bash

# < README >
# This is Vim8.2 setting scripts in centos7
# When the script is complete, execute the command below.
# 1st :
# cmd : vim ~/.vimrc
# 2st : shift+:
#BundleInstall

 # make ~/.vim/bundel directory
 
mkdir ~/.vim/bundle -p
cd ~/.vim/bundle
git clone https://github.com/VundleVim/Vundle.vim

 # download .vimrc ( vim-lsp )
 
wget https://edward0im.github.io/files/200917/vimrc2_lsp
present_path=(`pwd`)
mv $present_path/vimrc2_lsp ~/.vimrc

wget https://edward0im.github.io/files/200917/codedark.vim
mkdir ~/.vim/colors -p
mv $present_path/codedark.vim ~/.vim/colors

