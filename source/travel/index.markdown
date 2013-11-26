---
layout: page
title: Travel
comments: true
sharing: true
footer: true
---
<ul>
  <li><a href="{{ root_url }}/travel/austria">Austria</a>
    <ul>
      {% for place in site.travel.austria %}
        <li><a href="{{ root_url }}/travel/austria/{{ place.url }}">{{ place.name }}</a></li>
      {% endfor %}
    </ul>
  </li>
  <li><a href="{{ root_url }}/travel/canada">Canada</a>
    <ul>
      {% for place in site.travel.canada %}
        <li><a href="{{ root_url }}/travel/canada/{{ place.url }}">{{ place.name }}</a></li>
      {% endfor %}
      <li><a href="{{ root_url }}/blog/2011/07/05/quebec-1-july">Qu&eacute;bec</a></li>
    </ul>
  </li>
  <li><a href="{{ root_url }}/travel/costa-rica">Costa Rica</a>
    <ul>
      {% for place in site.travel.costa-rica %}
        <li><a href="{{ root_url }}/blog/{{ place.url }}">{{ place.name }}</a></li>
      {% endfor %}
    </ul>
  </li>
  <li><a href="{{ root_url }}/travel/czech-republic">Czech Republic</a>
    <ul>
      {% for place in site.travel.czech-republic %}
        <li><a href="{{ root_url }}/travel/czech-republic/{{ place.url }}">{{ place.name }}</a></li>
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
  <li><a href="{{ root_url }}/travel/germany">Germany</a>
    <ul>
      {% for place in site.travel.germany %}
        <li><a href="{{ root_url }}/travel/germany/{{ place.url }}">{{ place.name }}</a></li>
      {% endfor %}
    </ul>
  </li>
  <li><a href="{{ root_url }}/travel/monaco">Monaco</a>
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
  <li><a href="{{ root_url }}/travel/uk">UK</a>
    <ul>
      {% for place in site.travel.uk %}
        <li><a href="{{ root_url }}/travel/uk/{{ place.url }}">{{ place.name }}</a></li>
      {% endfor %}
    </ul>
  </li>
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