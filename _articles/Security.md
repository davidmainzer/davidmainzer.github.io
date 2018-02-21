---
layout: post
title:  "Security"
date:   2018-02-21 10:08:00
share: true
toc: true
comments: false
tags:
 - Security
 - Article
---

TEST 

{% assign my_min = page.toc_min | default: site.toc_min | default: 1 %}
{% assign my_max = page.toc_max | default: site.toc_max | default: 3 %}

{% include toc.html html=content sanitize=true h_min=my_min h_max=my_max %}

{% include toc.html html=content %}

{% include bibtex.html %}

*I will add more information related to Security issues from time to time.*

{{ toc }}

* TOC
{:toc}

## Security

### Current Security Attacks

<bibtex src="{{ site.url }}/bibtex/2018_-_Security.bib"></bibtex>

* [Official Website of Meltdown and Spectre](https://meltdownattack.com/)
  * Meltdown paper 
    * <div class="bibtex_display" bibtexkeys="Lipp2018meltdown"></div>
  * Spectre paper 
    * <div class="bibtex_display" bibtexkeys="Kocher2018spectre"></div>
  * [Official page with code samples](https://github.com/IAIK/meltdown)
