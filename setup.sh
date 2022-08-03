#!/bin/bash

# install homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
# the packages for nvim
brew install zsh tmux git git-extras neovim ripgrep fd

# install font
brew tap homebrew/cask-fonts
brew install --cask font-hack-nerd-font
# use brew install
# install nvm
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.7/install.sh | bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh"  ] && . "$NVM_DIR/nvm.sh"

# install stable node
nvm install stable

# install tpm for tmux
git clone https://github.com/gpakosz/.tmux.git
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

ln -fs "$PWD/vimrc" "$HOME/.vimrc"
ln -fs "$PWD/nvim" "$HOME/.config/nvim"
ln -fs "$PWD/.tmux/.tmux.conf" "$HOME/.tmux.conf"

sudo chsh -s $(which zsh)

# install ohmyzsh
sh -c "$(curl -fsSL
https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
