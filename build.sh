#!/bin/sh
#pacman -Syu --noconfirm base-devel sudo schedtool
pacman -Syu --noconfirm base-devel sudo git schedtool
pacman --noconfirm -U llvm-git*.pkg.tar.zst llvm-libs-git*.pkg.tar.zst
useradd builder  -u $USERID -m -G wheel && echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
su builder -c "gpg --keyserver hkps://keys.openpgp.org --recv-key 19802F8B0D70FC30"
cd /workspace/linux-zen/trunk ; su builder -c "yes '' | MAKEFLAGS=\"-j $(nproc)\" makepkg --noconfirm -sc"
