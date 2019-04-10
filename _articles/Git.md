---
layout: article
title:  "GIT"
date:   2019-04-10 09:49:00
share: true
comments: false
description: I will share some information about GIT.
tags:
 - GIT
---

*I will add more information related to GIT from time to time.*


# GIT Log

## Alias for log using pretty formatting
git config --global alias.lol "log --pretty=format:'%C(yellow)%h %Cred%ad %Cblue%an%Cgreen%d %Creset%s' --date=local --graph"
git config --global alias.lol20 "log --pretty=format:'%C(yellow)%h %Cred%ad %Cblue%an%Cgreen%d %Creset%s' --date=local --graph -20"
git config --global alias.lola "log --pretty=format:'%C(yellow)%h %Cred%ad %Cblue%an%Cgreen%d %Creset%s' --date=local --graph --all"
git config --global alias.lola20 "log --pretty=format:'%C(yellow)%h %Cred%ad %Cblue%an%Cgreen%d %Creset%s' --date=local --graph --all -20"


# How to Remove Complete GIT History

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