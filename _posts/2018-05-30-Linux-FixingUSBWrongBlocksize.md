---
layout: post
title: "Linux Fixing Wrong Block Size on USB drive"
date: 2018-05-30 08:01:00
share: true
tags: 
- Linux
categories:
description: This article describes how to fix wrong block size of a USB drive.
---

You wrote an IMG to your USB drive using dd and now linux displays wrong size?

Fixing block size

{% highlight bash %}
sudo dd if=/dev/zero of=/dev/<id_of_your_device> bs=2048; sync
{% endhighlight bash %}
