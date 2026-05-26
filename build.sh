#!/bin/sh
USERID=$1

#pacman -Syu --noconfirm base-devel sudo schedtool
pacman -Syu --noconfirm base-devel sudo git schedtool
pacman --disable-sandbox --noconfirm -U *.pkg.tar.zst
useradd builder  -u $USERID -m -G wheel && echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
su builder -c "gpg --keyserver hkps://ubuntu.com --recv-key 19802F8B0D70FC30"
su builder -c "gpg --keyserver hkps://ubuntu.com --recv-key 38DBBDC86092693E"
su builder -c "gpg --keyserver hkps://ubuntu.com --recv-key B8AC08600F108CDF"
cd ./linux-zen ; su builder -c "yes '' | MAKEFLAGS=\"-j $(nproc)\" makepkg --noconfirm --skippgpcheck -sc"
