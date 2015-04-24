---
layout: page
title: Canada
comments: true
sharing: true
footer: true
---
<ul>
  {% for place in site.travel.canada %}
    <li><a href="{{ root_url }}/travel/canada/{{ place.url }}">{{ place.name }}</a></li>
  {% endfor %}
  <li><a href="{{ root_url }}/blog/2011/07/05/quebec-1-july">Qu&eacute;bec</a></li>
</ul>