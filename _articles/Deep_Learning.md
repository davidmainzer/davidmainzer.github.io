---
layout: article
title:  "Information about Deep Learning"
date:   2018-01-16 09:49:00
share: true
comments: false
description: I will share Links and information about the topic machine learning.
tags:
 - DeepLearning
 - AI
---

{% include bibtex.html %}
<bibtex src="{{ site.url }}/bibtex/DeepLearning.bib"></bibtex>

*I will add more information related to AI especially Deep Neural Networks from time to time.*


This is a summary of some of the resources that I have either found useful myself or heard people.

## General Machine Learning

### Classes

* [Coursera's Machine Learning Class](https://www.coursera.org/learn/machine-learning "Coursera's Machine Learning Class") - This Coursera class, taught by Andrew Ng
* [Information Systems and Machine Learning Lab (ISMLL) at University of Hildesheim](https://www.ismll.uni-hildesheim.de/lehre/ml2-17s/script/index_en.html "Information Systems and Machine Learning Lab (ISMLL) at University of Hildesheim")

### Reading

#### Books

* [Machine Learning by Chris Bishop](http://www.springer.com/gb/book/9780387310732)
* [Machine Learning by Kevin Murphy](https://mitpress.mit.edu/books/machine-learning-0)

### Programming

* [SciKitLearn](http://scikit-learn.org/stable/ "SciKitLearn")

<hr>

## Deep Learning

### Reading

* [Neural Networks & Deep Learning](http://neuralnetworksanddeeplearning.com/ "Neural Networks & Deep Learning") by Michael Nielsen
* [Deep Learning Book](http://www.deeplearningbook.org/ "Deep Learning Book") by Ian Goodfellow, Yoshua Bengio and Aaron Courville (2016)

### Programming / Frameworks

* [Keras](https://keras.io/ "Keras")
* [TensorFlow](https://www.tensorflow.org/ "TensorFlow")
* [Theano](http://www.deeplearning.net/software/theano/ "Theano")

<hr>

## Different Machine Learning Tasks

### Classification

Any classification tasks depend upon labeled datasets. 
Labeled datasets are used to transfer human's knowledge to the dataset in order for an artificial network to extract information from this dataset to learn the correlation between labels and data information.
Using labeled datasets is known as *supervised learning*. In the following I provide a list (without any claim to completeness) of some classification tasks:

* Detect faces, identify people in images, recognize facial expressions (angry, joyful)
* Detect differnt types of objects in images (animals, flowers, stop signs, pedestrians, lane markers, traffic lights, ...)
* Recognize gestures
* Detect voices, identify speakers, transcribe speech to text, recognize sentiment in voices
* Classify text as spam (in emails), or fraudulent (in insurance claims); recognize sentiment in text (customer feedback)

#### Some Image-based Classification Publications

* [Time Series Classification from Scratch with Deep Neural Networks: A Strong Baseline](https://arxiv.org/pdf/1611.06455.pdf) [<i class="fa fa-external-link fa-lg"></i> <i class="fa fa-file-pdf-o "></i>](https://arxiv.org/pdf/1611.06455.pdf)
  * <div class="bibtex_display" bibtexkeys="DBLP:journals/corr/WangYO16"></div>
* [Deep Learning using Linear Support Vector Machines](https://arxiv.org/abs/1306.0239)
  * <div class="bibtex_display" bibtexkeys="DBLP:journals/corr/Tang13"></div>
* [ImageNet Classification with Deep Convolutional Neural Networks](https://papers.nips.cc/paper/4824-imagenet-classification-with-deep-convolutional-neural-networks.pdf)
  * https://papers.nips.cc/paper/4824-imagenet-classification-with-deep-convolutional-neural-networks
  * <div class="bibtex_display" bibtexkeys="NIPS2012_4824"></div>


 

#### Some Data-based Classification Publications
* [Quantum support vector machine for big data classification](https://arxiv.org/abs/1307.0471.pdf)
* [Convolutional Neural Networks for Sentence Classification](https://arxiv.org/pdf/1408.5882.pdf)
  * <div class="bibtex_display" bibtexkeys="DBLP:journals/corr/Kim14f"></div>

## Deep Learning -- Some State-of-The-Art Publications

* [DensePose: Dense Human Pose Estimation In The Wild](https://arxiv.org/abs/1802.00434.pdf)
  * [<i class="fa fa-external-link "></i> Project Site](http://densepose.org/ "Project Website")
  * <div class="bibtex_display" bibtexkeys="Guler2018DensePose"></div>
* [One Model to Learn them All](https://arxiv.org/pdf/1706.05137.pdf)
  * <div class="bibtex_display" bibtexkeys="kaiser2017one"></div>
* [Accessorize to a crime: Real and stealthy attacks on state-of-the-art face recognition](https://www.cs.cmu.edu/~sbhagava/papers/face-rec-ccs16.pdf)
  * <div class="bibtex_display" bibtexkeys="sharif2016accessorize"></div>
* Review paper from Yann LeCun, Yoshua Bengio & Geoffrey Hinton
  * <div class="bibtex_display" bibtexkeys="lecun2015deep"></div>
