#!/usr/bin/env zsh

USER=vscode

echo "Configuring opencode storage ..."
sudo mkdir -p /opencode-storage
sudo chown -R ${USER} /opencode-storage

echo "install opencode ..."
npm install -g --allow-scripts=@opencode/cli @opencode/cli

echo "install apm ..."
curl -sSL https://aka.ms/apm-unix | sh
