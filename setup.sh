#!/bin/bash

# Elevate privileges.
if [ $EUID != 0 ]; then
    su -c "bash $0" "$@"
    exit $?
fi

# Switch release to testing.
sed -i -e 's/ \(stable\|jessie\|wheezy\)/ testing/ig' /etc/apt/sources.list
sed -i -e 's/ main$/ main contrib non-free/ig' /etc/apt/sources.list

# Update the system.
apt-get update
apt-get --download-only dist-upgrade
apt-get dist-upgrade

# Install packages.
apt-get install -y \
sudo vim xorg tmux bash-completion \
wicd-curses curl wget chromium \
pepperflashplugin-nonfree icedtea-plugin \
build-essential git golang ruby \
vlc feh imagemagick \
alsa-base alsa-utils \
libreoffice evince \
xfonts-terminus ttf-freefont ttf-mscorefonts-installer ttf-bitstream-vera ttf-dejavu ttf-liberation

# Add user to sudo group.
adduser "$USER" sudo

# Install Suckless tools.
apt-get install -y lib11-dev libxinerama-dev
make -C sources/dwm/ && make install clean -C sources/dwm/
make -C sources/dmenu/ && make install clean -C sources/dmenu/
make -C sources/slock/ && make install clean -C sources/slock/

# Fix xinit permissions.
chmod u+s /usr/bin/xinit
