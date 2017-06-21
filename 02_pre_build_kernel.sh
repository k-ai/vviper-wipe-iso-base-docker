#!/bin/sh

patch_kernel() {
	echo "Applying kernel pataches..."

	cd work/kernel
	# Removes Video mode menu
	patch -p0 < ../../kernel_patches/01_disable_video_menu.diff

	cd ../..
}

patch_kernel
