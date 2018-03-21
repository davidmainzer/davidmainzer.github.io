---
layout: post
title: "Linux Find in Files"
date: 2018-03-09 10:57:00
share: true
tags: 
- Linux
categories:
description: This article describes how to search in files.
---

## Linux search in files for a given string

{% highlight bash %}
find . | xargs grep 'my search string' -sl 
{% endhighlight bash %}
