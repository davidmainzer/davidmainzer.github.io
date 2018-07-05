---
layout: article
title:  "Gentoo Linux as Server"
date:   2018-07-05 08:50:00
share: true
toc: true
comments: false
tags:
 - Gentoo
 - Article
---

I decided to move my Server from Strato to netcup. Therefore, I have to setup a fresh Gentoo as Root-Server. I will note some points and give hints to some interesting articles and manuals. 

Server-Setup:
-	Filesystem ZFS




sda1 grub
sda2 boot
sda3 rootfs -- ZFS


{% highlight bash %}
zfs list
{% endhighlight bash %}

| NAME | MOUNTPOINT |
|---|---|
| rpool   | none 
| rpool/GENTOO    | none |
| rpool/GENTOO/build-dir   | /var/tmp/portage |
| rpool/GENTOO/distfiles | /usr/portage/distfiles |
| rpool/GENTOO/packages | /usr/portage/packages |
| rpool/GENTOO/portage | /usr/portage |
| rpool/HOME | /home |
| rpool/HOME/root | /root |
| rpool/ROOT         | none |
| rpool/ROOT/gentoo  | / |
| rpool/swap         | - |


## Initramfs

To enable gentoo to load ZFS during boot we need to add some modules to our Initramfs. There we have to edit
`/opt/bliss-initramfs/pkg/hooks/Addon.py`:

{% highlight bash %}
class Addon(Hook):
  # A list of kernel modules to include in the initramfs
  # Format: "module1", "module2", "module3", ...
  _files = [
    # Uncomment the module below if you have encryption support built as a module, rather than built into the kernel:
    #"dm-crypt",

    # Add your modules below
    #"i915",
    #"nouveau",
    "virtio"
    "virtio_scsi"
    "virtio_ring"
    "virtio_pci"
  ]
{% endhighlight bash %}


# Links
[(wiki)](https://wiki.gentoo.org/wiki/User:Fearedbliss/Installing_Gentoo_Linux_On_ZFS)
[(wiki)](https://github.com/fearedbliss/bliss-initramfs)






