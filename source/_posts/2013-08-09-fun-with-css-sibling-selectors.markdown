---
layout: post
title: Fun with CSS sibling selectors
categories:
- technology
tags:
- css
---
[View the live example](http://jsfiddle.net/dinhyen/q4FKT/1/)

It seems like I'm always [working on search boxes](/blog/2013/07/02/search-box-using-knockoutjs/ "Search box using KnockoutJS"), but here goes another. My goal here is to display an icon inside the search box. Initially, the search box has a dark background. When clicked, the background changes to white. The icon should changes its color based on whether or not the search box has focus. If we were using a font-based icon such as [Fontawesome](http://fortawesome.github.io/Font-Awesome/), which is awesome by the way, styling the icon would be a simple exercise.  However, we're using an image-based icon, so it's not possible to change its color.

One solution is to use 2 icons, dark and light. We swap them depending on whether the input has focus. If the input is inactive, we show the light icon and hide the dark icon.  If the input is focused, we do the opposite.

To access the icon in the context of the input, we use the CSS sibling selector `~`. Unlike the other CSS sibling selector, `+`, the `~` selector doesn't require that the second element be immediately adjacent to the first.  This is important since we have 2 icons, the second of which wouldn't be adjacent to the input.  We also use the `not()` selector to select the element that lacks the specified class.

``` css
.navbar-search-wrapper input ~ .icon-search.icon-white {
  display: block;
}
.navbar-search-wrapper input:focus ~ .icon-search.icon-white {
  display: none;
}
.navbar-search-wrapper input ~ .icon-search:not(.icon-white) {
  display: none;
}
.navbar-search-wrapper input:focus ~ .icon-search:not(.icon-white) {
  display: block;
}
```
