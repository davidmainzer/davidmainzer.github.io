---
layout: post
title:  "Gentoo Linux"
date:   2018-01-16 18:50:00
share: true
comments: false
tags:
 - Gentoo
 - Article
---

I will add more information related to Gentoo Linux from time to time. 

Since my employer uses Ubuntu as the operating system, I only have a Gentoo Linux running on my private server.

<h2>Usefull Tools</h2>

<h3>Eix -- a set of utilities for searching</h3>

If you want to know if a package (program) is available you should use `eix` [(wiki)](https://wiki.gentoo.org/wiki/Eix)!

<h4>Installation</h4>
```
emerge --ask app-portage/eix
```
<h4>Keep eix up-to-date</h4>
```
eix-sync
```
<h4>Searching with eix</h4>
To search for a package containing *foo* keyword: 

```
eix foo
```

To search for an installed package containing *foo* keyword:
```
eix -I foo
```

<h2>Usefull Links</h2>
* [Gentoo's official website](https://www.gentoo.org/ "Gentoo's official website")
* [Gentoo's official Wiki page](https://wiki.gentoo.org/wiki/Main_Page "Gentoo's official Wiki page")
* [Gentoo's Overlay Search Page](http://gpo.zugaina.org/ "Gentoo's Overlay Search Page")
