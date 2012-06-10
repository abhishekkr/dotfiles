# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Source custom definitions
if [ -f $HOME/.profile_git ]; then
	. $HOME/.profile_git
fi
if [ -f $HOME/.profile_abril ]; then
	. $HOME/.profile_abril
fi
if [ -f $HOME/.profile_ruby ]; then
	. $HOME/.profile_ruby
fi
if [ -f $HOME/.profile_golang ]; then
	. $HOME/.profile_golang
fi
if [ -f $HOME/.profile_mobile ]; then
	. $HOME/.profile_mobile
fi
if [ -f $HOME/.profile_python ]; then
	. $HOME/.profile_python
fi
if [ -f $HOME/.profile_cli ]; then
	. $HOME/.profile_cli
fi
if [ -f $HOME/.profile_media ]; then
	. $HOME/.profile_media
fi

# User specific aliases and functions
alias reloadbash='. ~/.bash_profile'

# User specific environment and startup programs
alias grep='grep --color'

PATH=$PATH:$HOME/bin
export PATH

