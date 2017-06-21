FROM        ubuntu:xenial

#TODO: Upgrade to this version:
ENV         IMG_VERSION 20-Jan-2017

# Install dependencies for minimal linux live and qemu, git...
# see http://minimal.linux-bg.org/
RUN  DEBIAN_FRONTEND=noninteractive \
     && apt-get update\
     && apt-get install -y \
       wget build-essential bc syslinux-utils genisoimage busybox-static \
       libncurses5-dev git tree realpath pkg-config time gawk file cpio python

RUN  git clone https://github.com/ivandavidov/minimal/ \
     && cd minimal \
     && git checkout ${IMG_VERSION} \
     && mkdir -p /minimal/output

VOLUME /minimal/output
WORKDIR /minimal/src

# Fixing scripts of base image
RUN  set -e \
     && sed -i \
        "s/^\(.*09_generate_rootfs.sh\)/time sh 09_pre_generate_rootfs.sh\n\1\ntime sh 09_post_generate_rootfs.sh/g" \
        build_minimal_linux_live.sh \
     && sed -i \
        "s/^\(.*02_build_kernel.sh\)/time sh 02_pre_build_kernel.sh\n\1/g" \
        build_minimal_linux_live.sh \
     && sed -i \
        "s/^\(.*12_generate_iso.sh\)/time sh\ntime sh 12_pre_generate_iso.sh\n\1/g" \
        build_minimal_linux_live.sh \
     && sed -i \
        "s/^\(find\s\.\s|\scpio\s-R\sroot:root\s-H\snewc\s-o\s\).*/\1 > ..\/rootfs.cpio/g" \
        10_pack_rootfs.sh \
     && sed -i \
        "s/^\(rm\s-f\srootfs.cpio.gz\).*/rm -Rf rootfs.cpio/g" \
        10_pack_rootfs.sh \
     && sed -i \
        "s/\(COPY_SOURCE_ROOTFS=\).*/\1false/g" \
        .config \
     && csplit -f "temp" build_minimal_linux_live.sh "/sh 12_pre_generate_iso/" \
     && mv temp00 prepare_minimal_linux_live.sh \
     && mv temp01 build_minimal_linux_live.sh \
     && chmod +x ./*_minimal_linux_live.sh

# Append post script now - to cache result of prepare.
COPY rootfs_merge /minimal/src/rootfs_merge
COPY kernel_patches /minimal/src/kernel_patches
COPY ./02_pre_build_kernel.sh ./09_pre_generate_rootfs.sh ./09_post_generate_rootfs.sh /minimal/src/
RUN  ./prepare_minimal_linux_live.sh

# Fixing scripts of last step
RUN  set -e \
     && sed -i \
        "s/\(COPY_SOURCE_ISO=\).*/\1false/g" \
        .config \
     && sed -i \
        "s/\(OVERLAY_TYPE=\).*/#\1/g" \
        .config \
     && sed -i \
        "s/\(\$(id\s-u)\)/1/g" \
        12_generate_iso.sh

# Cleanup
RUN  set -e \
     && find . -type f -maxdepth 1 -name "*.sh" ! -name "build_minimal_*.sh" ! -name "12_*.sh" -delete \
     && rm -f *.txt README Makefile \
     && rm -Rf source \
     && rm -Rf rootfs_merge \
     && rm -Rf kernel_patches \
     && rm -Rf minimal_*

# Cleanup for kernel directory
RUN set -e \
    # Cleanup for kernel
    && mv work/kernel/kernel_installed work/ \
    && rm -Rf work/kernel \
    && mkdir -p work/kernel \
    && mv work/kernel_installed work/kernel/ \
    ######################
    # Cleanup for the rest of work
    && find work/ -type d -maxdepth 1 \
       ! -name "syslinux" \
       ! -name "kernel"  \
       ! -name "work"  \
       -exec rm -Rf {} \;


# Finally, Append my scripts over it.
COPY ./startup.sh ./12_pre_generate_iso.sh /minimal/src/

# config env
CMD ./startup.sh
