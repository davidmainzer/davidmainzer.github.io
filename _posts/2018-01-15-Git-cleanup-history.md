---
layout: post
title: "How to remove complete GIT history"
date: 2018-01-15 16:25:00
share: true
comments: false
tags: 
- GIT
categories:
description: In this post I show you a step by step guide on how to remove the complete GIT history from your repository. Attention, This cannot be reversed!
---

With these steps you will **remove** the **complete** history from your GIT repository. 

**So please make a backup first!**

{% highlight bash %}
# get last version from your repository and create an orphan branch
# Create a new orphan branch, named <new_branch>, started from <start_point> and switch to it. The first commit made on this new branch will have no parents and it will be the root of a new history totally disconnected from all the other branches and commits.
git checkout --orphan latest_branch
# Add everything to this branch
git add -A
# Commit to this branch
git commit -am "Init"
# Delete master branch
git branch -D master
# Move current branch to master
git branch -m master
# Push everything to your remote
git push -f origin master
{% endhighlight bash %}
