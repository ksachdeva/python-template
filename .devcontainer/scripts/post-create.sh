#!/usr/bin/env zsh

USER=vscode
SCRIPTS_DIR=$(realpath $(dirname "$0"))
BASE_DIR=$(dirname "$SCRIPTS_DIR")

echo "changing zshrc theme to ys ..."
sed -i s/^ZSH_THEME=".\+"$/ZSH_THEME=\"ys\"/g ~/.zshrc

echo "Configuring zsh_history..."
sudo mkdir -p /commandhistory
sudo touch /commandhistory/.zsh_history
sudo chown -R ${USER} /commandhistory
echo "autoload -Uz add-zsh-hook; append_history() { fc -W }; add-zsh-hook precmd append_history; export HISTFILE=/commandhistory/.zsh_history" >> /home/${USER}/.zshrc
echo -e "Configuring zsh_history... \033[32;1mdone\033[0m"

bash "$SCRIPTS_DIR"/poe.sh
bash "$SCRIPTS_DIR"/docker-completion.sh
bash "$SCRIPTS_DIR"/uv.sh
bash "$SCRIPTS_DIR"/agents.sh

echo "install pre-commit hooks ..."
uv run pre-commit install
