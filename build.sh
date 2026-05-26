#!/bin/sh
USERID=$1

#pacman -Syu --noconfirm base-devel sudo schedtool
pacman -Syu --noconfirm base-devel sudo git schedtool
pacman --disable-sandbox --noconfirm -U *.pkg.tar.zst
useradd builder  -u $USERID -m -G wheel && echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
su builder -c "gpg --recv-keys B8AC08600F108CDF"
su builder -c "gpg --recv-keys 38DBBDC86092693E"
cd ./linux-zen ; su builder -c "yes '' | MAKEFLAGS=\"-j $(nproc)\" makepkg --noconfirm -sc"
