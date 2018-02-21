---
layout: page
title: Tags 

---

<div class="page-content wc-container">
	<div class="post">
		<h1>Tags</h1>  
		<ul>
			{% for tag in site.tags %}
			<li><a href="{{ '/tag/' | append:tag[0] | relative_url }}">{{ tag[0] }}</a></li>
			{% endfor %}
		</ul>
	</div>
</div>

<div class="page-content wc-container text-center">
{% capture site_tags %}
  [
  {% for tag in site.tags %}
    {"text":"{{ tag[0] }}","size":{{ tag[1].size }}, "url":"{{ site.url }}/tag/{{tag[0]}}"}
  {% unless forloop.last %},{% endunless %}
  {% endfor %}
  ]
{% endcapture %}

{% include tag-cloud.html %}
</div>
