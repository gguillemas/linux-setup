#!/bin/bash

echo 'Warning! This script must be run as the regular user of the system.'
read -r -p "Will '$USER' be the main user? [y/N] " response
if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]
then
    echo 'Starting.'
else
		echo 'Exiting.'
    exit
fi

USERNAME="$USER"

su

# Switch release to testing.
sed -i -e 's/ \(stable\|jessie\|wheezy\)/ testing/ig' /etc/apt/sources.list
sed -i -e 's/ main$/ main contrib non-free/ig' /etc/apt/sources.list

# Update the system.
apt-get update
apt-get --download-only dist-upgrade
apt-get dist-upgrade

# Install packages.
apt-get install -y \
# Essential
sudo vim xorg tmux bash-completion \
# Internet
wicd-curses curl wget \
# Plug-ins
pepperflashplugin-nonfree icedtea-plugin \
# Development
git gcc golang ruby python build-essential \
# Media
vlc feh \
# Office
libreoffice evince \
# Fonts
xfonts-terminus ttf-freefont ttf-mscorefonts-installer ttf-bitstream-vera ttf-dejavu ttf-liberation \

# Add user to sudoers.
sed "s/root ALL=(ALL) ALL/&\n$USERNAME ALL=(ALL) ALL/" /etc/sudoers

# Install Suckless tools.
make -C sources/dwm/ && make install clean -C sources/dwm/
make -C sources/dmemu/ && make install clean -C sources/dmenu/
make -C sources/slock/ && make install clean -C sources/slock/