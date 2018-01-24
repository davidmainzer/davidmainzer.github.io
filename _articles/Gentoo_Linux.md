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

### eix -- A Set Of Utilities For Searching

If you want to know if a package (program) is available you should use `eix` [(wiki)](https://wiki.gentoo.org/wiki/Eix)!

#### Installation
{% highlight bash %}
emerge -av app-portage/eix
{% endhighlight bash %}

#### Keep eix Up-To-Date
{% highlight bash %}
eix-sync
{% endhighlight bash %}

#### Searching With eix
To search for a package containing *foo* keyword: 

{% highlight bash %}
eix foo
{% endhighlight bash %}

To search for an installed package containing *foo* keyword:
{% highlight bash %}
eix -I foo
{% endhighlight bash %}

## Update Your Gentoo System
The following lines will update your Gentoo System. The first step is to create binary packages (with config files) before performing update steps to keep a backup of the current installed package version.

{% highlight bash %}
# update your package database
eix -uc
# create binary package for each package which will be updated later
quickpkg --include-config=y $(eix -uc --only-names) 
# update all packages
emerge @world -uvaDN --autounmask-write --with-bdeps=y
# rebuild packages if need
emerge -va @preserved-rebuild @module-rebuild 
revdep-rebuild -v -- --ask
{% endhighlight bash %}

Maybe you want to remove unused binary packages from time to time. I prefer `eclean` because I have `app-portage/gentoolkit` installed already.

### Cleanup with eclean
`eclean` is part of `app-portage/gentoolkit`
{% highlight bash %}
eclean packages
{% endhighlight bash %}

### Cleanup with qpkg
`qpkg` is part of `app-portage/portage-utils`
{% highlight bash %}
qpkg -c
{% endhighlight bash %}

## Chroot Into Your Gentoo System

Mount all devices and folder (Gentoo is located under `/repair/`:
{% highlight bash %}
mount --rbind /dev /repair/dev
mount --make-rslave /repair/dev
mount -t proc /proc /repair/proc
mount --rbind /sys /repair/sys
mount --make-rslave /repair/sys
mount --rbind /tmp /repair/tmp
{% endhighlight bash %}

chroot into Gentoo:
{% highlight bash %}
chroot /repair /bin/bash
env-update
source /etc/profile
export PS1="(chroot) $PS1"
{% endhighlight bash %}

## Cleanup Gentoo System

cleanup source directory (`distfiles`)

{% highlight bash %}
eclean -p distfiles
{% endhighlight bash %}

cleanup binary files from system

{% highlight bash %}
eclean packages
{% endhighlight bash %}

## Usefull Links
* [Gentoo's official website](https://www.gentoo.org/ "Gentoo's official website")
* [Gentoo's official Wiki page](https://wiki.gentoo.org/wiki/Main_Page "Gentoo's official Wiki page")
* [Gentoo's official package page](https://packages.gentoo.org/ "Gentoo's official package page")
* [Gentoo's Overlay Search Page](http://gpo.zugaina.org/ "Gentoo's Overlay Search Page")
