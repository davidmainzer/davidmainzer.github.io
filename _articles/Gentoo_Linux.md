---
layout: post
title:  "Gentoo Linux"
date:   2018-01-16 18:50:00
share: true
toc: true
comments: false
tags:
 - Gentoo
 - Article
---

I will add more information related to Gentoo Linux from time to time. 

Since my employer uses Ubuntu as the operating system, I only have a Gentoo Linux running on my private server.

## Table of Content
* TOC
{:toc}

## Usefull Tools

### Eix -- a set of utilities for searching

If you want to know if a package (program) is available you should use `eix` [(wiki)](https://wiki.gentoo.org/wiki/Eix)!

#### Installation
```
emerge -av app-portage/eix
```
#### Keep eix up-to-date
```
eix-sync
```
#### Searching with eix
To search for a package containing *foo* keyword: 

```
eix foo
```

To search for an installed package containing *foo* keyword:
```
eix -I foo
```

## Chroot into your Gentoo System

Mount all devices and folder (Gentoo is located under `/repair/`:
```
mount --rbind /dev /repair/dev
mount --make-rslave /repair/dev
mount -t proc /proc /repair/proc
mount --rbind /sys /repair/sys
mount --make-rslave /repair/sys
mount --rbind /tmp /repair/tmp
```

chroot into Gentoo:
```
chroot /repair /bin/bash
env-update
source /etc/profile
export PS1="(chroot) $PS1"
```

## Cleanup Gentoo System

cleanup source directory (`distfiles`)
```
eclean -p distfiles
```
cleanup binary files from system
```
eclean packages
```

## Usefull Links
* [Gentoo's official website](https://www.gentoo.org/ "Gentoo's official website")
* [Gentoo's official Wiki page](https://wiki.gentoo.org/wiki/Main_Page "Gentoo's official Wiki page")
* [Gentoo's Overlay Search Page](http://gpo.zugaina.org/ "Gentoo's Overlay Search Page")
