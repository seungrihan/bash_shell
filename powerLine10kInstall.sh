#/bin/bash
# < README >
#
# You need to install it on CentOS7 Version  
# reference : https://www.ivaylopavlov.com/setting-up-windows-terminal-wsl-and-oh-my-zsh/#.YJTo2LUzaHt

# install package
function install_oh_my_zsh()
{
	yum -y install \
	yum-plugin-priorities \
	epel-release \
	centos-release-scl-rh \
	centos-release-scl \
	http://rpms.famillecollet.com/enterprise/remi-release-7.rpm \
	gcc

	# change repo Option
	sed -i -e "s/\]$/\]\npriority=5/g" /etc/yum.repos.d/epel.repo
	sed -i -e "s/enabled=1/enabled=0/g" /etc/yum.repos.d/epel.repo
	sed -i -e "s/\]$/\]\npriority=10/g" /etc/yum.repos.d/CentOS-SCLo-scl.repo
	sed -i -e "s/\]$/\]\npriority=10/g" /etc/yum.repos.d/CentOS-SCLo-scl-rh.repo
	sed -i -e "s/enabled=1/enabled=0/g" /etc/yum.repos.d/CentOS-SCLo-scl.repo
	sed -i -e "s/enabled=1/enabled=0/g" /etc/yum.repos.d/CentOS-SCLo-scl-rh.repo
	sed -i -e "s/\]$/\]\npriority=10/g" /etc/yum.repos.d/remi-safe.repo
	sed -i -e "s/enabled=1/enabled=0/g" /etc/yum.repos.d/remi-safe.repo

	# zsh install
	yum --enablerepo=epel install -y git zsh
	chsh -s $(which zsh)
	wget http://mirror.ghettoforge.org/distributions/gf/el/7/plus/x86_64/zsh-5.1-1.gf.el7.x86_64.rpm
	rpm -Uvh zsh-5.1-1.gf.el7.x86_64.rpm

	# oh-my-zsh install
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

function oh_my_zsh_setting()
{
	# install Powerlevel10K
	git clone https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/themes/powerlevel10k

	# change Powerlevel10K
	sed -i 's|^ZSH_THEME=.*|ZSH_THEME="powerlevel10k/powerlevel10k"|g' ~/.zshrc

	# ruby25 install
	yum --enablerepo=centos-sclo-rh -y install rh-ruby25 rh-ruby25-ruby-devel
	scl enable rh-ruby25 zsh
	ruby -v
	which ruby


	cat << 'EOF' > /etc/profile.d/rh-ruby25.sh
#!/bin/bash

source /opt/rh/rh-ruby25/enable
export X_SCLS="`scl enable rh-ruby25 'echo $X_SCLS'`"
EOF

	#FZF install
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	sudo ~/.fzf/install

	# Z install
	git clone https://github.com/agkozak/zsh-z $ZSH_CUSTOM/plugins/zsh-z
	source ~/.zshrc
}

function install_colorls()
{
	# /bin/colorls install
	gem install colorls
	source $(dirname $(gem which colorls))/tab_complete.sh
}

function change_powerline10k_option()
{
	#powerlevel10k setting
	/bin/zsh
	p10k configure
}

if [ -z $1 ]; then
    echo "################# Menu ##################"
    echo " $ ./Powerlevel10K.sh [Number]"
    echo "#########################################"
    echo "    1 : Install : oh_my_zsh "
    echo "    2 : Setting : oh_my_zsh"
    echo "    3 : Install : colorls"
    echo "    4 : Setting : change_powerline10k"	
    echo "#########################################"
    exit 0
fi

case "$1" in
	"1" ) install_oh_my_zsh;;
	"2" ) oh_my_zsh_setting;;
	"3" ) install_colorls;;
	"4" ) change_powerline10k_option;;
	*) echo " [INFO] Incorrect Command !!" ;;
esac

