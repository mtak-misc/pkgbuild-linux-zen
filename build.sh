#!/bin/sh
USERID=$1

#pacman -Syu --noconfirm base-devel sudo schedtool
pacman -Syu --noconfirm base-devel sudo git schedtool pacman-contrib
pacman --disable-sandbox --noconfirm -U *.pkg.tar.zst
sed -i \
  's|^  https://cdn\.kernel\.org/pub/linux/kernel/v${pkgver%%\.\*}\.x/${_srcname}\.tar\.{xz,sign}$|  "$_srcname::git+https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git#tag=v${pkgver%.*}"|' \
  ./linux-zen/PKGBUILD
sed -i \
  "s/^b2sums=('0d6e9ff535af085190da7df50887b20f395cd4d6befb7158c9993bf77fe92459a9982877ce944ca522192daa5a54c952c3d368def04b579796ba7109a972453b'$/b2sums=('SKIP'/" \
  ./linux-zen/PKGBUILD
sed -i \
  "s/^sha256sums=('37198c93727be247c9fb5309bb86cd5e496c61e5322cd8c4eca9476bb0b5883f'$/sha256sums=('SKIP'/" \
  ./linux-zen/PKGBUILD
updpkgsums ./linux-zen/PKGBUILD
cat ./linux-zen/PKGBUILD

useradd builder  -u $USERID -m -G wheel && echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
su builder -c "gpg --recv-keys B8AC08600F108CDF"
su builder -c "gpg --recv-keys 38DBBDC86092693E"
cd ./linux-zen ; su builder -c "yes '' | MAKEFLAGS=\"-j $(nproc)\" makepkg --noconfirm -sc"
