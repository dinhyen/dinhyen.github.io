---
layout: page
title: The Netherlands
comments: true
sharing: true
footer: true
---
<ul>
  {% for place in site.travel.netherlands %}
    <li><a href="{{ root_url }}/travel/netherlands/{{ place.url }}">{{ place.name }}</a></li>
  {% endfor %}
</ul>