---
layout: post
title: Auto property with private setter
categories:
- technology
tags:
- c#
- tip
status: publish
type: post
published: true
meta:
  aktt_notify_twitter: 'no'
  _edit_last: '1'
  _syntaxhighlighter_encoded: '1'
---
Sometimes I'd like to only allow a property to be set in the constructor. Something like this:
``` csharp
private Foo _foo;
public Foo Foo
{
	get { return _foo; }
}

public Bar(Foo foo)
{
	_foo = foo;
}
```

This neat little pattern lets you do the same with fewer members (and lines of code):
``` csharp
public Foo { get; private set; }

public Bar(Foo foo)
{
	Foo = foo;
}
```
