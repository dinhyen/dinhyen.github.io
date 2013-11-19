---
layout: page
title: Costa Rica
comments: true
sharing: true
footer: true
---
<ul>
  {% for place in site.travel.costa-rica %}
    <li><a href="{{ root_url }}/blog/{{ place.url }}">{{ place.name }}</a></li>
  {% endfor %}
</ul>