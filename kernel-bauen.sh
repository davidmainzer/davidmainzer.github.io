#!/bin/bash
mount /boot && \
emerge gentoo-sources -va && \
cp /boot/config /usr/src/linux/.config && \
cd /usr/src/linux && make && make install && make modules_install && \
emerge -v @preserved-rebuild @module-rebuild && revdep-rebuild && \
cd /boot && \
bliss-initramfs
