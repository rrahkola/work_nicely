###
# ~/.bashrc
# Bash startup environment
# - To use with login shell, insert:
#     if [ -f ~/.bashrc ]; then . ~/.bashrc; fi
#   to the start of ~/.bash_profile or ~/.profile
###


### NVM -- node version manager
export NVM_DIR="$HOME/.nvm"
. "/usr/local/opt/nvm/nvm.sh"

### Groovy installation
export GROOVY_HOME=/usr/local/opt/groovy/libexec

### Terraform version switching
# Source chtf
if [[ -f /usr/local/share/chtf/chtf.sh ]]; then
    source "/usr/local/share/chtf/chtf.sh"
fi
# Default terraform version
chtf 0.10.8

### Python environment switcher
eval "$(pyenv init -)"
source <(kubectl completion bash)


### JVM environment switcher
eval "$(jenv init -)"
