#!/bin/sh
set -e

# Location of current script (sibling to .zshenv, .zshrc, .zshlogin)
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
# Escape the slashes in the above variable, suitable for sed-replacement
ESCAPED_DIR=${DIR//\//\\\/}
echo "$ESCAPED_DIR"

echo "Copying .zshenv file to home directory and updating"
cp -a $DIR/.zshenv_template $HOME/.zshenv
sed -i -e "s/<<ZDOTDIR>>/$ESCAPED_DIR/" $HOME/.zshenv

echo "Ready to start a new zsh"
