---
layout: page
title: Iceland
comments: true
sharing: true
footer: true
---
<ul>
  {% for place in site.travel.iceland %}
    <li><a href="{{ root_url }}/travel/iceland/{{ place.url }}">{{ place.name }}</a></li>
  {% endfor %}
</ul>