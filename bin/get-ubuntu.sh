#!/bin/bash -ex

rootfs=/tmp/bionic

mount -o remount,suid,dev /tmp
[[ -d $rootfs ]] || \
  debootstrap --variant=buildd --arch=amd64 bionic $rootfs http://archive.ubuntu.com/ubuntu

cat >$rootfs/root/setup.sh <<END
#!/bin/bash
sed -i '/main$/ s/$/ universe/' /etc/apt/sources.list
apt update
apt install -y curl vim checkinstall git bash-completion
END

systemd-nspawn -D $rootfs /bin/bash /root/setup.sh

cat >$rootfs/root/build-ly.sh <<END
#!/bin/bash -ex

apt install -y libpam0g-dev libxcb1-dev
git clone https://github.com/cylgom/ly
cd ly
git checkout v0.5.0
make github
make
checkinstall -y --pkgversion=0.5.0 make install
END

cat >$rootfs/root/build-wayland.sh <<'END'
#!/bin/bash -ex

mkdir -p sway-src
cd sway-src

apt install -y \
 build-essential cmake ninja-build \
 libegl1-mesa-dev libgles2-mesa-dev libdrm-dev libgbm-dev libinput-dev \
 libxkbcommon-dev libudev-dev libpixman-1-dev libsystemd-dev libcap-dev \
 libxcb1-dev libxcb-composite0-dev libxcb-xfixes0-dev \
 libxcb-image0-dev libxcb-render-util0-dev libx11-xcb-dev libxcb-icccm4-dev \
 freerdp2-dev libwinpr2-dev libpng-dev libavutil-dev libavcodec-dev \
 libavformat-dev

(
[[ -d meson ]] || git clone https://github.com/mesonbuild/meson
cd meson
git fetch
git checkout 0.54.0
)

(
apt install -y libffi-dev libexpat-dev libxml2-dev
[[ -d wayland-1.18.0 ]] || {
  curl -LO https://wayland.freedesktop.org/releases/wayland-1.18.0.tar.xz
  tar -xvf wayland-1.18.0.tar.xz
}
cd wayland-1.18.0
./configure --disable-documentation
make
checkinstall -y --pkgversion=1.18.0 make install
)

(
[[ -d wayland-protocols-1.20 ]] || {
  curl -LO https://wayland.freedesktop.org/releases/wayland-protocols-1.20.tar.xz
  tar -xvf wayland-protocols-1.20.tar.xz
}
cd wayland-protocols-1.20
./configure
make
checkinstall -y --pkgversion=1.20 make install
)

build_with_meson()
{
  url=$1
  name=$2
  tag=$3
  [ -d $name ] || git clone $url/$name
  (
  cd $name
  git fetch
  git checkout $tag
  ../meson/meson.py build
  ninja -C build
  checkinstall -y --pkgversion=${tag#*-} ninja -C build install
  )
}

apt install -y libpciaccess-dev libcairo-dev
build_with_meson https://gitlab.freedesktop.org/mesa drm libdrm-2.4.101

(
[[ -d json-c ]] || git clone https://github.com/json-c/json-c.git
cd json-c
git fetch
git checkout json-c-0.14-20200419
mkdir -p BUILD
cd BUILD
cmake -DENABLE_THREADING=Yes ..
make
checkinstall -y --pkgname=json-c --pkgversion=0.14 make install
)

(
[[ -d scdoc ]] || git clone https://git.sr.ht/~sircmpwn/scdoc
cd scdoc
git fetch
git checkout 1.10.1
make PREFIX=/usr/local
checkinstall -y --pkgversion=1.10.1 make PREFIX=/usr/local install
)

apt install -y libpango1.0-dev libgdk-pixbuf2.0-dev

for comp in wlroots-0.10.0 sway-1.4 swaybg-1.0 swaylock-1.5 swayidle-1.6; do
  name=${comp%-*}
  ver=${comp#*-}
  build_with_meson https://github.com/swaywm $name $ver
done

END

chmod +x $rootfs/root/*.sh
