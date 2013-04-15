# this is inspired from loads of otherz and some mine

UNAME=$(uname)

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="cypher" ="gentoo" ="funky"
#ZSH_THEME="clean"
ZSH_THEME="blinks"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how many often would you like to wait before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export PATH=$PATH:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:/usr/bin/core_perl
export PATH=$PATH:$HOME/bin:$HOME/.rvm/bin # Add RVM to PATH for scripting

#
export EDITOR=vim
export CDPATH=$CDPATH:$HOME:$HOME/an0n/dev

# setup dir hashes
hash -d AGIT=$HOME/an0n/dev/abhishekkr/on_github

# use vi mode
bindkey -v

# use home and end in addition to ^e and ^a
bindkey -M viins '^A' vi-beginning-of-line
bindkey -M viins '^E' vi-end-of-line
if [ $UNAME = "Linux" ]; then
  bindkey -M viins '^[OH' vi-beginning-of-line
  bindkey -M viins '^[OF' vi-end-of-line
else
  bindkey -M viins '^[[H' vi-beginning-of-line
  bindkey -M viins '^[[F' vi-end-of-line
fi
# use delete as forward delete
bindkey -M viins '\e[3~' vi-delete-char
# line buffer
bindkey -M viins '^B' push-line-or-edit
# change the '-' for up in history, always kills my command editing.
bindkey -M vicmd '^[OA' vi-up-line-or-history
# change the shortcut for expand alias
bindkey -M viins '^X' _expand_alias

# edit current command in $EDITOR
autoload -U edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

setopt NO_BEEP
# Changing Directories
setopt AUTO_CD
setopt CDABLE_VARS
setopt AUTO_PUSHD

# History
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY
setopt HIST_IGNORE_ALL_DUPS
setopt EXTENDED_HISTORY

setopt EXTENDED_GLOB

for a in `ls /etc/profile.d/*.sh`; do
  source $a
done

# This loads RVM into a shell session.
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
unsetopt auto_name_dirs
unset GREP_OPTIONS

typeset -U path cdpath fpath
