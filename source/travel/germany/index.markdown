---
layout: page
title: Germany
published: true
---
<ul>
  {% for place in site.travel.germany %}
    <li><a href="{{ root_url }}/travel/germany/{{ place.url }}">{{ place.name }}</a></li>
  {% endfor %}
</ul>