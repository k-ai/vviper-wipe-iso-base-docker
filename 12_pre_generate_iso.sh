#!/bin/sh

echo "Placeholder script"
# Pack rootfs for iso creation.
cd work

# build cpio.xz out of the final rootfs
xz -0 --check=none rootfs.cpio

cd ..
