---
layout: post
title: "Angular in Jekyll/Octopress"
comments: true
categories:
- technology
---
Have a problem with Angular scope variable binding not working on a Jekyll or Octopress (which uses Jekyll) page?  It so happens that Jekyll's Liquid Template uses the same {{ foo }} syntax as Angular and would attempt to process the markup before Angular can get to it.  To get around the problem, you can surround Angular markup with <code>&#123;% raw %&#125;</code> and <code>&#123;% endraw %&#125;</code> tags.  Alternatively, you can also forgo from using this syntax altogether and use Angular's `ng-bind` directive to bind a variable to a DOM element.

