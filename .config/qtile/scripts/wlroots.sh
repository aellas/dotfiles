#!/bin/bash

PREFIX=/opt/wlroots-0.19
BUILD_DIR=~/src
cd $BUILD_DIR
mkdir -p cache

WAYLAND=1.23.1
WAYLAND_PROTOCOLS=1.41
WLROOTS=0.19.0
# SEATD=0.2.0 *
# LIBDRM=2.4.122 *
PIXMAN=0.43.0
# XWAYLAND=22.1.9 ?
# HWDATA=0.364 ?

fetch_source() {
    url=$1
    filename=$2
    if [ -f "cache/$filename" ]; then
        echo "$filename found, skipping download."
    else
        wget -P cache "$url"
    fi
}

export PKG_CONFIG_PATH=$PREFIX/lib/x86_64-linux-gnu/pkgconfig:$PKG_CONFIG_PATH

sudo apt update

# First dependencies

# pixman
VERSION=$(apt-cache policy libpixman-1-dev | awk '/Candidate:/ {split($2,a,"-"); print a[1]}')
if dpkg --compare-versions "$VERSION" lt "$PIXMAN"; then
	tarball="pixman-pixman-$PIXMAN.tar.gz"
	fetch_source "https://gitlab.freedesktop.org/pixman/pixman/-/archive/pixman-$PIXMAN/$tarball" "$tarball"
	tar -xzf "cache/$tarball"
	cd pixman-pixman-$PIXMAN
	rm -rf ./build
	meson setup --clearcache --reconfigure build --prefix=$PREFIX
	ninja -C build && sudo ninja -C build install
	cd ../
else
	sudo apt install libpixman-1-dev
fi

# wayland-server
VERSION=$(apt-cache policy libwayland-dev | awk '/Candidate:/ {split($2,a,"-"); print a[1]}')
if dpkg --compare-versions "$VERSION" lt "$WAYLAND"; then
	tarball="wayland-$WAYLAND.tar.xz"
	fetch_source "https://gitlab.freedesktop.org/wayland/wayland/-/releases/$WAYLAND/downloads/$tarball" "$tarball"
	tar -xJf "cache/$tarball"
	cd wayland-$WAYLAND
	rm -rf ./build
	meson setup --clearcache --reconfigure build \
		--prefix=$PREFIX \
		-Ddocumentation=false \
		-Dc_link_args="-Wl,-rpath,$PREFIX/lib/x86_64-linux-gnu"
	ninja -C build && sudo ninja -C build install
	cd ../
else
	sudo apt install libwayland-dev
fi

# wayland protocols
VERSION=$(apt-cache policy wayland-protocols | awk '/Candidate:/ {split($2,a,"-"); print a[1]}')
if dpkg --compare-versions "$VERSION" lt "$WAYLAND_PROTOCOLS"; then
	tarball="wayland-protocols-$WAYLAND_PROTOCOLS.tar.xz"
	fetch_source "https://gitlab.freedesktop.org/wayland/wayland-protocols/-/releases/$WAYLAND_PROTOCOLS/downloads/$tarball" "$tarball"
	tar -xJf "cache/$tarball"
	cd wayland-protocols-$WAYLAND_PROTOCOLS
	rm -rf ./build
	meson setup --clearcache --reconfigure build --prefix=$PREFIX
	ninja -C build && sudo ninja -C build install
	cd ../

	export PKG_CONFIG_PATH=$PREFIX/share/pkgconfig:$PKG_CONFIG_PATH
else
	sudo apt install wayland-protocols
fi

# finally wlroots
tarball="wlroots-$WLROOTS.tar.gz"
fetch_source "https://gitlab.freedesktop.org/wlroots/wlroots/-/archive/$WLROOTS/$tarball" "$tarball"
tar -xzf "cache/$tarball"
cd wlroots-$WLROOTS
rm -rf ./build
meson setup --clearcache --reconfigure build \
	--prefix=$PREFIX \
	-Dexamples=false \
	-Dxwayland=enabled \
	-Dc_link_args="-Wl,-rpath,$PREFIX/lib/x86_64-linux-gnu"
ninja -C build && sudo ninja -C build install
