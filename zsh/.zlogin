###
# Interactive Shell options
###
# enable pushd and popd naturally with cd
setopt autopushd pushdminus pushdsilent pushdtohome
# share history across multiple zsh sessions
setopt SHARE_HISTORY
# append to history
setopt APPEND_HISTORY
# adds commands as they are typed, not at shell exit
setopt INC_APPEND_HISTORY
# expire duplicates first
setopt HIST_EXPIRE_DUPS_FIRST 
# do not store duplications
setopt HIST_IGNORE_DUPS
#ignore duplicates when searching
setopt HIST_FIND_NO_DUPS
# removes blank lines from history
setopt HIST_REDUCE_BLANKS

# enable iTerm2 shell integration
source ${ZDOTDIR}/.iterm2_shell_integration.zsh
