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

I decided to move my Server from Strato to netcup. Therefore, I have to setup a fresh Gentoo as Root-Server. 
I will note some points and give hints to some interesting articles and manuals.

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

## ZFS Snapshots

We use `zfs-auto-snapshot` from portage to create automated snapshots.
To enable automated snapshots you have to set an auto-snapshot parameter as stated in the installation output:

{% highlight bash %}
zfs set com.sun:auto-snapshot=true rpool/HOME
zfs set com.sun:auto-snapshot=true rpool/HOME/root
zfs set com.sun:auto-snapshot=true rpool/ROOT/gentoo
{% endhighlight bash %}

This will create snapshots every hour, day and week (depends on your setting). Here you can see an example output:
{% highlight bash %}
HOST / # zfs list -r -t snapshot -o name,creation
NAME                                                    CREATION
rpool/HOME@zfs-auto-snap_hourly-2018-07-11-1538         Wed Jul 11 15:38 2018
rpool/HOME/root@zfs-auto-snap_hourly-2018-07-11-1538    Wed Jul 11 15:38 2018
rpool/ROOT/gentoo@zfs-auto-snap_hourly-2018-07-11-1538  Wed Jul 11 15:38 2018
HOST / # 
{% endhighlight bash %}


# For Security Improvements
- portsentry
- chkrootkit
- fail2ban
- and many more

[Gentoo Security](https://wiki.gentoo.org/wiki/Security_Handbook/)


# Links
[Fearedbliss: Installing Gentoo Linux On ZFS (wiki)](https://wiki.gentoo.org/wiki/User:Fearedbliss/Installing_Gentoo_Linux_On_ZFS)
[Fearedbliss: Github-Page](https://github.com/fearedbliss/bliss-initramfs)
