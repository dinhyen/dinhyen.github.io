---
layout: page
title: "travel"
date: 2013-10-22 14:59
comments: true
sharing: true
footer: true
---
<ul>
  <li><a href="{{ root_url }}/travel/canada">Canada</a>
    <ul>
      {% for place in site.travel.canada %}
        <li><a href="{{ root_url }}/blog/{{ place.url }}">{{ place.name }}</a></li>
      {% endfor %}
    </ul>
  </li>
  <li><a href="{{ root_url }}/travel/costa-rica">Costa Rica</a>
    <ul>
      {% for place in site.travel.costa-rica %}
        <li><a href="{{ root_url }}/blog/{{ place.url }}">{{ place.name }}</a></li>
      {% endfor %}
    </ul>
  </li>

  <li><a href="{{ root_url }}/travel/france">France</a>
    <ul>
      {% for place in site.travel.france %}
        <li><a href="{{ root_url }}/travel/france/{{ place.url }}">{{ place.name }}</a></li>
      {% endfor %}
    </ul>
  </li>

  <li><a href="{{ root_url }}/travel/netherlands">The Netherlands</a>
    <ul>
      {% for place in site.travel.netherlands %}
        <li><a href="{{ root_url }}/travel/netherlands/{{ place.url }}">{{ place.name }}</a></li>
      {% endfor %}
    </ul>
  </li>

  <li><a href="{{ root_url }}/travel/peru">Peru</a>
    <ul>
      {% for place in site.travel.peru %}
        <li><a href="{{ root_url }}/blog/{{ place.url }}">{{ place.name }}</a></li>
      {% endfor %}
    </ul>
  </li>

</ul>