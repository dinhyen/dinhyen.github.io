---
layout: page
title: Peru
comments: true
sharing: true
footer: true
---
<ul>
  {% for place in site.travel.peru %}
    <li><a href="{{ root_url }}/blog/{{ place.url }}">{{ place.name }}</a></li>
  {% endfor %}
</ul>
