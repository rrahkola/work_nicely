###
# .zshrc -- login aliases, functions, options, key bindings, etc.
#
# General notes/legend:
#   - '*' in prefixed comment denotes a dependency on ~/.zshenv
#   - '--' in prefixed comment generally precedes installation command
#   - '$ ...' in prefixed comment gives example usage commands
###

# Location of current script (sibling to .zshenv, .zlogin, and zshfunctions)
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

# Get rid of annoying compinit message
# ZSH_DISABLE_COMPFIX="true"

# plugin configuration
ZSH_POETRY_AUTO_ACTIVATE=0  # automatically activates virtual environments when entering project directories
ZSH_POETRY_AUTO_DEACTIVATE=0  # automatically deactivates virtual environments when entering project directories

# Load antigen ZSH plugin-manager -- `brew install antigen`
source /usr/local/share/antigen/antigen.zsh
antigen use oh-my-zsh
antigen bundles <<EOBUNDLES
    zsh-users/zsh-syntax-highlighting
    zsh-users/zsh-autosuggestions
    zsh-users/zsh-completions
    nvm
    pyenv
    darvid/zsh-poetry
EOBUNDLES
antigen theme romkatv/powerlevel10k
antigen apply

# Source chtf -- `brew tap Yleisradio/terraforms && brew install chtf`
if [[ -f /usr/local/share/chtf/chtf.sh ]]; then
    source "/usr/local/share/chtf/chtf.sh"
    # chtf default version
    chtf 0.10.8
fi

# *jEnv initialization
if command -v jenv 1>/dev/null 2>&1; then
    eval "$(jenv init -)"
fi

###
# Suffix aliases -- open a file with an application
###
alias -s json="jq ."

###
# Standard aliases
###
# Directory history
# $ cd /tmp && cd /usr && cd bin && cd ../pub && dh && cd -3   # navigates back to /tmp
alias dh='dirs -v'
# Color + flags listing
alias dir='ls -FG'
# Get my commits from the current repo
alias my_commits='git log --author="Rauha"'


###
# poetry helpers
###
poetry completions zsh > ${ZDOTDIR}/zshfunctions/_poetry
poetry config virtualenvs.in-project true

###
# zsh functions -- use fpath with autoload
###
fpath+=${ZDOTDIR}/zshfunctions
autoload update_repos
autoload clean_repos
autoload reset_repos
autoload my_recent_commits
autoload _poetry
autoload jwt_parser

# Date functionality
epoch_to_date () { epoch=$(( $1 / 1000 )); date -j -f "%s" "+%F %r" $epoch; }

###
# meetup-automation sync
###
alias get-meetups="aws s3 sync s3://meetup-automation-data ~/nikedev/S3/meetup-automation-data"
alias push-meetups="aws s3 sync ~/nikedev/S3/meetup-automation-data s3://meetup-automation-data"

# Add Visual Studio Code (code)
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

###
# kubectl shortcut & autocompletion
###
source <(kubectl completion zsh)
alias k='kubectl'
complete -F __start_kubectl k

# Powerlevel10k theme -- `antigen theme romkatv/powerlevel10k; antigen apply; p10k configure`
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

