#!/bin/bash

# install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# the packages for nvim
brew install zsh tmux git git-extras neovim ripgrep fd lua-language-server bat git-delta fzf tree-sitter

# install font
brew tap homebrew/cask-fonts
brew install --cask font-hack-nerd-font

# install pynvim for coc
pip3 install pynvim

# install nvm
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.7/install.sh | bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh"  ] && . "$NVM_DIR/nvm.sh"

# install stable node
nvm install stable

# install js development tools
npm -g i jest mermaid

export CONFIG_PATH = "~/.config"

ln -fs "$PWD/.vimrc" "$HOME/.vimrc"
ln -fs "$PWD/nvim" "$CONFIG_PATH/nvim"
ln -fs "$PWD/.tmux.conf" "$HOME/.tmux.conf"
ln -fs "$PWD/alacritty.yml" "$CONFIG_PATH/alacritty"
ln -fs "$PWD/.zshrc" "$HOME/.zshrc"

sudo chsh -s $(which zsh)

# install ohmyzsh
sh -c "$(curl -fsSL
https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

source ~/.zshrc

