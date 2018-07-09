---
layout: article
title:  "Gentoo Linux as Mail-Server"
date:   2018-07-09 08:00:00
share: true
toc: true
comments: false
tags:
 - Gentoo
 - Article
---

I used a very good and detailed guide created by [Thomas Leister](https://thomas-leister.de/mailserver-debian-stretch/).
Since I have a Gentoo Linux running I want to explain within this article how you can use this guide for Gentoo Linux.

Dovecot
Postfix
MySQL
Rspamd
Postfix-Admin



# Requirements 
We will use a single drive called 
`/dev/sda`

# Goal
Server:
-	Root-Filesystem ZFS

# Partitioning

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

To enable gentoo to load ZFS during boot we need to add some modules (server is virtualized) to our Initramfs. Therefore, we have to edit
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


## For Security Improvements
- portsentry
- chkrootkit
- fail2ban
- and many more

[Gentoo Security](https://wiki.gentoo.org/wiki/Security_Handbook/)


# Links

https://thomas-leister.de/mailserver-debian-stretch/
