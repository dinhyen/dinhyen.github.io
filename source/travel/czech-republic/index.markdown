---
layout: page
title: Czech Republic
published: true
---
<ul>
  {% for place in site.travel.czech-republic %}
    <li><a href="{{ root_url }}/travel/czech-republic/{{ place.url }}">{{ place.name }}</a></li>
  {% endfor %}
</ul>