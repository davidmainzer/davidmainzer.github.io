---
layout: page
---

Run in your TAG folder ...

{% highlight bash %}
{% for tag in site.tags %}
  echo $'---\nlayout: tag_index\ntag: {{ tag[0] }} \n---' > '{{ tag[0] }}.md' &{% endfor %}

{% for tag in articles.tags %}
  echo $'---\nlayout: tag_index\ntag: {{ tag[0] }} \n---' > '{{ tag[0] }}.md' &{% endfor %}


{% endhighlight %}
