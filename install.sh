#!/bin/bash

# Handle the -h option to display help
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
  echo "Usage: $0"
  echo "This script sets up a custom shell prompt that displays the current git branch and status."
  echo "It modifies your ~/.bashrc file to include a PROMPT_COMMAND that updates the prompt dynamically."
  echo "Make sure to run this script in a bash shell."
  echo "For more information, visit https://github.com/bydzen/proshell."
  exit 0
fi

# Check ~/.bashrc exists
if [ ! -f ~/.bashrc ]; then
  echo "Error: ~/.bashrc does not exist. Please create it first."
  exit 1
fi

# Check git is installed
if ! command -v git &> /dev/null; then
  echo "Error: git is not installed. Please install git first."
  exit 1
fi

# Check if PROMPT_COMMAND is already set
if grep -q 'PROMPT_COMMAND=' ~/.bashrc; then
  echo "PROMPT_COMMAND is already set in ~/.bashrc. Please remove it before running this script."
  exit 1
fi

# Add PROMPT_COMMAND to ~/.bashrc
echo "Adding PROMPT_COMMAND to ~/.bashrc..."

# Sleep to ensure the file is ready for writing
sleep 3

# Create the PROMPT_COMMAND block
PROMPT_COMMAND_BLOCK=$(cat <<'EOF'
PROMPT_COMMAND='
EXIT="$?"
BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
[ -z "$BRANCH" ] && BRANCH="no-branch"
GIT_STATUS=$(git status --porcelain 2>/dev/null)
[ -n "$GIT_STATUS" ] && GIT_STATE="*dirty*" || GIT_STATE="clean"

if [ "$EXIT" -ne 0 ]; then
  STATUS_ICON="\[\e[1;31m\] $EXIT\[\e[0m\]"
else
  STATUS_ICON="\[\e[1;32m\]\[\e[0m\]"
fi

PS1="\n\[\e[1;36m\]\u@\h\[\e[2m\] (\@)\[\e[0m\] \[\e[2m\]($GIT_STATE)\[\e[0m\] \[\e[1;33m\] $BRANCH\[\e[0m\] $STATUS_ICON\n\[\e[1;34m\] \w\[\e[0m\] \$ "
'
EOF
)

# Append the PROMPT_COMMAND block to ~/.bashrc
echo "$PROMPT_COMMAND_BLOCK" >> ~/.bashrc

# Source the updated ~/.bashrc
source ~/.bashrc
echo "PROMPT_COMMAND has been successfully added to your shell prompt."
echo "Please restart your terminal or run 'source ~/.bashrc' to apply the changes."
echo "You can now use the new prompt with git branch and status information."
echo "To remove this, simply delete the PROMPT_COMMAND block from ~/.bashrc."
echo "You can also customize the prompt further as needed."
echo "For more information, refer to the documentation at https://github.com/bydzen/proshell."
echo -e "\nInstallation complete."
