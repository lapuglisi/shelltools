#!/bin/sh

chroot="/mnt/gentoo";

mount --types proc /proc ${chroot}/proc
mount --rbind /sys ${chroot}/sys
mount --make-rslave ${chroot}/sys
mount --rbind /dev ${chroot}/dev
mount --make-rslave ${chroot}/dev
mount --bind /run ${chroot}/run
mount --make-slave ${chroot}/run

chroot ${chroot} /bin/bash;
