---
layout: post
title: "Compiling on Linux using make"
date: 2018-05-30 08:01:00
share: true
tags: 
- Linux
categories:
description: This article gives some hints for compiling on Linux.
---

If you write Makefiles you will use ```include``` from time to time. But if you call ```make``` and your included files are located somewhere on your disk, you need to set the correct search path for make. This can be done via ```--include-dir```:


{% highlight bash %}
make --include-dir=/where/are/my/files...
{% endhighlight bash %}
