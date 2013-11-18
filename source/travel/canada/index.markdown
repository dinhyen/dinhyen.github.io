---
layout: page
title: Canada
comments: true
sharing: true
footer: true
---
<ul>
  {% for place in site.travel.canada %}
    <li><a href="{{ root_url }}/blog/{{ place.url }}">{{ place.name }}</a></li>
  {% endfor %}
</ul>