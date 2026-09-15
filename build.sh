#!/bin/sh
USERID=$1

#pacman -Syu --noconfirm base-devel sudo schedtool
pacman -Syu --noconfirm base-devel sudo git schedtool
#pacman --disable-sandbox --noconfirm -U *.pkg.tar.zst
pacman -S --noconfirm clang21 lld21 llvm21

#sed -i \
#  's|^  https://cdn\.kernel\.org/pub/linux/kernel/v${pkgver%%\.\*}\.x/${_srcname}\.tar\.{xz,sign}$|  "$_srcname::git+https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git?signed#tag=v${pkgver%.*}"|' \
#  ./linux-zen/PKGBUILD
#sed  -i "/'SKIP')$/b; /'SKIP'/d" ./linux-zen/PKGBUILD
#grep -oP "(?<=')[a-f0-9]{64}(?=')" ./linux-zen/PKGBUILD | awk '{print "sed -i \x27s/"$1"/SKIP/g\x27 ./linux-zen/PKGBUILD"}' | bash
#grep -oP "(?<=')[a-f0-9]{128}(?=')" ./linux-zen/PKGBUILD | awk '{print "sed -i \x27s/"$1"/SKIP/g\x27 ./linux-zen/PKGBUILD"}' | bash

useradd builder  -u $USERID -m -G wheel && echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
su builder -c "gpg --recv-keys B8AC08600F108CDF"
su builder -c "gpg --recv-keys 38DBBDC86092693E"
cd ./linux-zen ; su builder -c "yes '' | MAKEFLAGS=\"-j $(nproc)\" makepkg --noconfirm -sc"
