#!/bin/sh

STATIC_PYTHON_SOURCE_URL=https://www.python.org/ftp/python/3.6.1/Python-3.6.1.tgz
#STATIC_NCURSES_SOURCE_URL=https://ftp.gnu.org/gnu/ncurses/ncurses-6.0.tar.gz
STATIC_PICOTUI_SOURCE_URL=https://github.com/pfalcon/picotui/archive/v0.9.tar.gz
STATIC_PSUTIL_SOURCE_URL=https://github.com/giampaolo/psutil/archive/release-5.2.1.tar.gz

get_picotui() {
	DOWNLOAD_URL=$STATIC_PICOTUI_SOURCE_URL
	ARCHIVE_FILE=${DOWNLOAD_URL##*/}
	EXTRACTED_DIR=picotui-0.9

	cd source || exit 1

	# Downloading package
	# -c option allows the download to resume
	wget -c $DOWNLOAD_URL
	rm -rf $EXTRACTED_DIR
	tar -zxf $ARCHIVE_FILE

	rm -rf ../work/picotui

	# move extracted package to work
	mv $EXTRACTED_DIR ../work/picotui

	cd ..
}

get_psutil() {
	DOWNLOAD_URL=$STATIC_PSUTIL_SOURCE_URL
	ARCHIVE_FILE=${DOWNLOAD_URL##*/}
	EXTRACTED_DIR=psutil-release-5.2.1

	cd source || exit 1

	# Downloading package
	# -c option allows the download to resume
	wget -c $DOWNLOAD_URL
	rm -rf $EXTRACTED_DIR
	tar -zxf $ARCHIVE_FILE

	rm -rf ../work/psutil

	# move extracted package to work
	mv $EXTRACTED_DIR ../work/psutil

	cd ..
}

get_python() {
	DOWNLOAD_URL=$STATIC_PYTHON_SOURCE_URL

	# Grab everything after the last '/' character
	ARCHIVE_FILE=${DOWNLOAD_URL##*/}
	EXTRACTED_DIR=${ARCHIVE_FILE%.*}

	cd source || exit 1

	# Downloading package
	# -c option allows the download to resume
	wget -c $DOWNLOAD_URL
	rm -rf $EXTRACTED_DIR
	tar -zxf $ARCHIVE_FILE

	# Delete folder with previously extracted static python
	rm -rf ../work/python

	# move extracted package to work
	mv $EXTRACTED_DIR ../work/python

	cd ..
}

#get_ncurses() {
#	DOWNLOAD_URL=$STATIC_NCURSES_SOURCE_URL
#
#	# Grab everything after the last '/' character
#	ARCHIVE_FILE=${DOWNLOAD_URL##*/}
#	# Strip .gz and then .tar
#	EXTRACTED_DIR=${ARCHIVE_FILE%.*}
#	EXTRACTED_DIR=${EXTRACTED_DIR%.*}
#
#	cd source || exit 1
#
#	# Downloading package
#	# -c option allows the download to resume
#	wget -c $DOWNLOAD_URL
#	rm -rf $EXTRACTED_DIR
#	tar -zxf $ARCHIVE_FILE
#
#	# Delete folder with previously extracted static python
#	rm -rf ../work/ncurses
#
#	# move extracted package to work
#	mv $EXTRACTED_DIR ../work/ncurses
#
#	# Patch a build file
#	sed -i "65s/.*/preprocessor=\"\$1 -P -DNCURSES_INTERNALS -I..\/include\"/g" ../work/ncurses/ncurses/base/MKlib_gen.sh
#
#	cd ..
#}

# 1. Get ncurses
# get_ncurses

# 2. Get Python
get_python

# 3. get picotui
get_picotui

# 4. get psutil
get_psutil
