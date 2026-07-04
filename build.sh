#!/bin/sh
USERID=$1

#pacman -Syu --noconfirm base-devel sudo schedtool
pacman -Syu --noconfirm base-devel sudo git schedtool pacman-contrib
pacman --disable-sandbox --noconfirm -U *.pkg.tar.zst
sed -i \
  's|^  https://cdn\.kernel\.org/pub/linux/kernel/v${pkgver%%\.\*}\.x/${_srcname}\.tar\.{xz,sign}$|  "$_srcname::git+https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git?signed#tag=v${pkgver%.*}"|' \
  ./linux-zen/PKGBUILD
updpkgsums ./linux-zen/PKGBUILD

useradd builder  -u $USERID -m -G wheel && echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
su builder -c "gpg --recv-keys B8AC08600F108CDF"
su builder -c "gpg --recv-keys 38DBBDC86092693E"
cd ./linux-zen ; su builder -c "yes '' | MAKEFLAGS=\"-j $(nproc)\" makepkg --noconfirm -sc"
