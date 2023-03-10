#!/bin/bash

echo "deb [trusted=yes] file:///dvd1 bullseye main contrib">/etc/apt/sources.list

apt update

apt install locales
dpkg-reconfigure locales

# choose

apt install \
linux-image-amd64 systemd-sysv systemd-sysv ntfs-3g psmisc \
man nano less git neovim \
wireless-tools net-tools resolvconf iputils-ping iputils-arping wget curl netcat \
apache2 vsftpd ssh \
live-boot live-boot-initramfs-tools
