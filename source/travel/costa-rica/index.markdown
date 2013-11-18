---
layout: page
title: Costa Rica
date: 2013-10-22 14:59
comments: true
sharing: true
footer: true
---
<ul>
  {% for place in site.travel.costa-rica %}
    <li><a href="{{ root_url }}/blog/{{ place.url }}">{{ place.name }}</a></li>
  {% endfor %}
</ul>