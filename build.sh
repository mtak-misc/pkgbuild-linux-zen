#!/bin/sh
USERID=$1

#pacman -Syu --noconfirm base-devel sudo schedtool
pacman -Syu --noconfirm base-devel sudo git schedtool
pacman --disable-sandbox --noconfirm -U *.pkg.tar.zst
useradd builder  -u $USERID -m -G wheel && echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
su builder -c "gpg --keyserver hkps://ubuntu.com --recv-key 83BC8889351B5DEBBB68416EB8AC08600F108CDF"
su builder -c "gpg --keyserver hkps://ubuntu.com --recv-key 647F28654894E3BD457199BE38DBBDC86092693E"
su builder -c "gpg --keyserver hkps://ubuntu.com --recv-key ABAF11C65A2970B130ABE3C479BE3E4300411886"
cd ./linux-zen ; su builder -c "yes '' | MAKEFLAGS=\"-j $(nproc)\" makepkg --noconfirm -sc"
