#!/bin/sh

# System initialization sequence:
#
# /init
#  |
#  +--(1) /etc/01_prepare.sh
#  |
#  +--(2) /etc/02_overlay.sh
#          |
#          +-- /etc/03_init.sh (this file)
#               |
#               +-- /sbin/init
#                    |
#                    +--(1) /etc/04_bootscript.sh
#                    |       |
#                    |       +-- udhcpc
#                    |           |
#                    |           +-- /etc/05_rc.udhcp
#                    |
#                    +--(2) /bin/sh (Alt + F1, main console)
#                    |
#                    +--(2) /bin/sh (Alt + F2)
#                    |
#                    +--(2) /bin/sh (Alt + F3)
#                    |
#                    +--(2) /bin/sh (Alt + F4)

# If you have persistent overlay support then you can edit this file and replace
# the default initialization  of the system. For example, you could use this:
#
# exec setsid cttyhach sh
#
# This gives you PID 1 shell inside the initramfs area. Since this is a PID 1
# shell, you can still invoke the original initialization logic by executing
# this command:
#
# exec /sbin/init

# Set up python enviorment
export PYTHONPATH="/lib/python3.6:/lib/python3.6/lib-dynload:/lib/python3.6/site-packages"
export PYTHONHOME="/lib/python3.6"

# Mount mtab
ln -s /proc/self/mounts /etc/mtab

# Use default initialization logic based on configuration in '/etc/inittab'.
exec /sbin/init

echo "(/etc/03_init.sh) - there is a serious bug..."

# Wait until any key has been pressed.
read -n1 -s

