---
layout: post
title: AutoMapper doesn't work for mismatched types
categories:
- technology
tags:
- asp.net mvc
- automapper
- c#
- linq to sql
status: publish
type: post
published: true
meta:
  aktt_notify_twitter: 'no'
  _edit_last: '1'
  _syntaxhighlighter_encoded: '1'
  _wp_old_slug: automapper-behavior-for-clashing-properties
---
We're using [AutoMapper](http://automapper.codeplex.com/) in ASP.NET MVC automate the mapping of properties between entity and view model objects.  This is a highly useful tool which helps us avoid the tedium of having to assigning properties manually.  Here's a good [introduction](http://lostechies.com/jimmybogard/2009/01/23/automapper-the-object-object-mapper/) to using AutoMapper.

In one case, I find that the AutoMapper doesn't work for all properties.  One property in particular doesn't get mapped.  If I manually assign a value to it as a test, I would get a ForeignKeyReferenceAlreadyHasValueException.

The entity looks something like this:

``` csharp
class Order
{
	public int CustomerId { get; set; }
	public Person Customer { get; set; }
}
```

The view model is similar, but I pull out just the customer's name into a string since it is all I need. For simplicity I decide to re-use the property name. This seems intuitive and is a common practice for us before we started using the AutoMapper.

``` csharp
class OrderViewModel
{
	public int CustomerId { get; set; }
	public string Customer { get; set; }
}
```

Mapping the view model to the entity is accomplished with a simple statement:

``` csharp
AutoMapper.Mapper.Map<OrderViewModel, Order>(orderViewModel, order);
```

To map things the other way requires a similar statement:

``` csharp
AutoMapper.Mapper.Map<Order, OrderViewModel>(order, orderViewModel);
```

I find that the CustomerId property would not get mapped in either scenario.

It turns out that the problem is caused by using a "recycled" property name. In the entity, Customer is a Person object which is created from the foreign key CustomerId via LINQ to SQL, so Customer and CustomerId are intimately connected. In the view model, CustomerId matches that in the entity, but Customer is of a different type. The conflict causes the AutoMapper to abort mapping either of these properties.

There are a couple of workarounds.  The simplest solution is to rename the Customer property in the view model to something else which doesn't clash, such as CustomerName.  The nice thing about AutoMapper is that by convention you can map properties of an object simply by appending it to the object's property name. So the Person.Name property would get mapped to CustomerName, Person.Phone would get mapped to CustomerPhone and so on.

Alternatively, since I only care about CustomerId, I can simply tell AutoMapper to ignore the Customer property altogether:

``` csharp
// From view model to entity
AutoMapper.Mapper.CreateMap<OrderViewModel, Order>()
                .ForMember(ovm => ovm.Customer, opt => opt.Ignore());
// From entity to view model
AutoMapper.Mapper.CreateMap<Order, OrderViewModel>()
                .ForMember(o => o.Customer, opt => opt.Ignore());
```

These mapping conventions should be declared once, before the mapping operation is performed.
