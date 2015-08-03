---
layout: page
title: Tags
permalink: /tags/
redirect_from: /tag/
---


<ul>
{% assign sorted_tags = site.tags | sort  %}
{% for tag  in sorted_tags %}

<li><a href="/tags/{{ tag | first }}">{{ tag | first }} ({{tag | last | size }})</a></li>

{% endfor %}

</ul>
