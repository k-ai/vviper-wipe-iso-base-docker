#!/bin/sh

SRC_ROOT=`pwd`
SYSROOT=`realpath work/rootfs`

build_python() {
	cd ${SRC_ROOT}/work/python

	./configure --prefix=${SYSROOT} LDFLAGS="--sysroot=${SYSROOT}" CFLAGS="--sysroot=${SYSROOT}" --enable-optimizations
	make install

	cd ${SRC_ROOT}
}

install_picotui() {
	cd ${SRC_ROOT}/work/picotui
	# No setuptools, cannot install
	cp -Rfp picotui ../rootfs/lib/python3.6/site-packages
	cd ${SRC_ROOT}
}

install_psutil() {
	cd ${SRC_ROOT}/work/psutil
	../rootfs/bin/python3.6 setup.py install
	cd ${SRC_ROOT}
}

# NCURSES actually screws the console :(
# build_ncurses() {
# 	cd ${SRC_ROOT}/work/ncurses
# 	./configure --prefix=${SYSROOT}
# 	make
# 	make install
#
# 	cd ${SRC_ROOT}
# }

fix_glibc() {
	# TODO: Copy only needed libraries.
	cp -Rf ${SRC_ROOT}/work/glibc/glibc_prepared/* ${SYSROOT}
}

fix_rootfs() {
	cp -Rfp ${SRC_ROOT}/rootfs_merge/* ${SYSROOT}
}

# 1. Fix GLIBC
fix_glibc

# 2. Fix rootfs scripts
fix_rootfs

# 3. Build & install ncurses
# build_ncurses

# 3. Build & Install Python
build_python

# 4. Install picotui
install_picotui

# 5. Install psutil
install_psutil
