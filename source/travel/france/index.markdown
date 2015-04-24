---
layout: page
title: France
published: true
---
<ul>
  {% for place in site.travel.france %}
    <li><a href="{{ root_url }}/travel/france/{{ place.url }}">{{ place.name }}</a></li>
  {% endfor %}
</ul>