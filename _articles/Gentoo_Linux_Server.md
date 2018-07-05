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

https://wiki.gentoo.org/wiki/User:Fearedbliss/Installing_Gentoo_Linux_On_ZFS

sda1 grub
sda2 boot
sda3 rootfs -- ZFS

https://github.com/fearedbliss/bliss-initramfs





/opt/bliss-initramfs/pkg/hooks/Addon.py

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
