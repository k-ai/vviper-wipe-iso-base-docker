#!/bin/bash
set -e

if [ "${JUST_PULL}" != "" ]; then
	echo "Pull Complete."
	exit 0
fi;

OUTPUT_DIR=../output/vviper-iso-${MACHINE_UUID}
OUTPUT=${OUTPUT_DIR}/vviper.iso
mkdir -p ${OUTPUT_DIR}

set -x
source ./build_minimal_linux_live.sh
mv minimal_linux_live.iso ${OUTPUT}
isohybrid ${OUTPUT}
