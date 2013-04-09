# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	source /etc/bashrc
fi

# Source custom definitions
if [ -f /etc/profile.d/a.git.sh ]; then
	source /etc/profile.d/a.git.sh
fi
if [ -f /etc/profile.d/a.project.sh ]; then
	source /etc/profile.d/a.project.sh
fi
if [ -f /etc/profile.d/a.ruby.sh ]; then
	source /etc/profile.d/a.ruby.sh
fi
if [ -f /etc/profile.d/a.golang.sh ]; then
	source /etc/profile.d/a.golang.sh
fi
if [ -f /etc/profile.d/a.mobile.sh ]; then
	source /etc/profile.d/a.mobile.sh
fi
if [ -f /etc/profile.d/a.python.sh ]; then
	source /etc/profile.d/a.python.sh
fi
if [ -f /etc/profile.d/a.cli.sh ]; then
	source /etc/profile.d/a.cli.sh
fi
if [ -f /etc/profile.d/a.media.sh ]; then
	source /etc/profile.d/a.media.sh
fi

# User specific aliases and functions
alias reloadbash='. ~/.bash_profile'

# User specific environment and startup programs
alias grep='grep --color'

PATH=$PATH:/etc/profile.d/bin:$HOME/bin
export PATH
