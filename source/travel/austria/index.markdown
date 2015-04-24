---
layout: page
title: Austria
published: true
---
<ul>
  {% for place in site.travel.austria %}
    <li><a href="{{ root_url }}/travel/austria/{{ place.url }}">{{ place.name }}</a></li>
  {% endfor %}
</ul>