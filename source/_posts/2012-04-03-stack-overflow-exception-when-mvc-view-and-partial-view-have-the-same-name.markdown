---
layout: post
title: Stack overflow exception when MVC View and Partial View have the same name
categories:
- technology
tags:
- asp.net mvc
---
This scenario is probably unusual but it did happen to me. I had a view named Foo.aspx and partial view named Foo.ascx. The view rendered the partial as follows:

``` csharp
<% Html.RenderPartial("Foo"); %>
```

When attempting to load the view, ASP.NET spins for a while then eventually throws a stack overflow exception. Apparently when executing the above statement, MVC searches for files named "Foo", including the view itself. It must have attempted to render the view and gone into a recursive loop.

The quick fix is to give the partial view some other name, or explicitly provide its location in the render statement:

``` csharp
<% Html.RenderPartial("~/Views/Home/Foo.ascx"); %>
```
