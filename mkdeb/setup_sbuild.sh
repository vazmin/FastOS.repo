#!/bin/bash
if [ $# != 2 ]; then
    echo "Please use: setup_build.sh [dist] [arch]"
    exit 1
fi

dist="$1"
arch="$2"
if ubuntu-distro-info --all | grep -Fqx "$dist"; then
    disttype="ubuntu"
else
    disttype="debian"
fi

# Determine base apt repository URL based on type of distribution.
case "$disttype" in
    ubuntu)
        url=http://archive.ubuntu.com/ubuntu
        ;;
    debian)
        url=http://deb.debian.org/debian
        ;;
    *)
        echo "Unknown distribution $disttype"
        exit 1
esac

# if [[ ${arch} == arm* ]] ; then
#     chroot_dir=/srv/chroot/${dist}-${arch}-sbuild
#     mkdir -p ${chroot_dir}
#     debootstrap --foreign --no-check-gpg --include=fakeroot,build-essential \
#             --arch=${arch} ${dist} ${chroot_dir} ${url}
#     cp /usr/bin/qemu-arm-static ${chroot_dir}/usr/bin/
#     chroot ${chroot_dir} ./debootstrap/debootstrap --second-stage
#     sbuild-createchroot --arch=${arch} --make-sbuild-tarball=/var/lib/sbuild/${dist}-${arch}.tar.gz --foreign --setup-only \
#         ${dist} ${chroot_dir} ${url}
# else
    sbuild-createchroot \
        --arch=${arch} --make-sbuild-tarball=/var/lib/sbuild/${dist}-${arch}.tar.gz \
        ${dist} `mktemp -d` ${url}
# fi

# Ubuntu has the main and ports repositories on different URLs, so we need to
# properly set up /etc/apt/sources.list to make cross compilation work.
if [ "$disttype" = "ubuntu" ]; then
    cat <<__END__ | schroot -c source:${dist}-${arch}-sbuild -d / -- tee /etc/apt/sources.list
deb [arch=amd64,i386] http://archive.ubuntu.com/ubuntu ${dist} main universe
deb [arch=amd64,i386] http://archive.ubuntu.com/ubuntu ${dist}-updates main universe
deb [arch=armhf,arm64] http://ports.ubuntu.com ${dist} main universe
deb [arch=armhf,arm64] http://ports.ubuntu.com ${dist}-updates main universe
__END__
fi