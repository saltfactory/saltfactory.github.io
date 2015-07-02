---
layout: page
title: Categories
permalink: /categories/
redirect_from: /category/
---


<ul>
{% assign sorted_categories = site.categories | sort  %}
{% for category  in sorted_categories %}

<li><a href="/categories/{{ category | first }}">{{ category | first }} ({{category | last | size }})</a></li>

{% endfor %}

</ul>
