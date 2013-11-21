---
layout: page
title: USA
published: true
---
<ul>
  <li><a href="{{ root_url }}/travel/usa">USA</a>
    <ul>
      {% for state in site.travel.usa %}
        <li><a href="{{ root_url }}/travel/usa/{{ state.url }}">{{ state.name }}</a>
          <ul>
            {% for place in state.places %}
              <li><a href="{{ root_url }}/travel/usa/{{ state.url }}/{{ place.url }}">{{ place.name }}</a></li>
            {% endfor %}
          </ul>
        </li>
      {% endfor %}
    </ul>
  </li>
</ul>