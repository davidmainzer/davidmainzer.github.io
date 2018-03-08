---
layout: post
title: "Install TensorFlow 1.5 with GPU"
date: 2018-02-05 14:55:00
share: true
tags: 
- Deep Learning
- AI
categories:
description: This article describes how to install TensorFlow 1.5 with GPU support enabled.
---

## TensorFlow

I'm using Anaconda Python and the following command will install/update TensorFlow to version 1.5 using CUDA 9 and cuDNN 7.

{% highlight bash %}
pip install --ignore-installed --upgrade  https://storage.googleapis.com/tensorflow/linux/gpu/tensorflow_gpu-1.5.0rc1-cp36-cp36m-linux_x86_64.whl
# If you have SSL problems use trusted-host flag
pip install --trusted-host storage.googleapis.com --ignore-installed --upgrade  https://storage.googleapis.com/tensorflow/linux/gpu/tensorflow_gpu-1.5.0rc1-cp36-cp36m-linux_x86_64.whl
{% endhighlight bash %}