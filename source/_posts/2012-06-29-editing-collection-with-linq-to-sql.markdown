---
layout: post
title: Edit collection with LINQ to SQL
categories:
- technology
tags:
- c#
- linq to sql
status: publish
type: post
published: true
meta:
  aktt_notify_twitter: 'no'
  _edit_last: '1'
  _syntaxhighlighter_encoded: '1'
---
Let's say for a shopping cart we have an Order entity, a Product entity and an OrderDetails entity which serves as a bridge. The OrderDetails entity has OrderId and ProductId fields to associate products with orders. We also have an Order domain object which is passed from the business logic layer to the repository layer.

Since products can be added or removed from an order, we need to manage the order details for each Order.  We can either update OrderDetails directly in the database or via the Order.OrderDetails collection.

### Deleting

When handling deletions, we can determine products removed from the order (i.e., products which are present in the database object but not in the domain object) as follows:
``` csharp
var toDelete = 
	from od in order.OrderDetails
	where !domainOrder.OrderDetails.Any(o => o.ProductId == od.ProductId)
	select od;
```

Deleting the order details directly from the database works: 
``` csharp
DataContext.OrderDetails.DeleteAllOnSubmit(toDelete);
```

However, trying to delete the order details using the Order.OrderDetails collection removes only the relationship between Order and OrderDetails.  This would fail because of the foreign key constraint. 
``` csharp
foreach (var item in toDelete)
     order.OrderDetails.Remove(item)
```

### Adding

When handling additions, we can determine products added to the order (i.e., products which are present in the domain order object but not in the database order object) as follows:

``` csharp
var toAdd = 
	from od in domainOrder.OrderDetails
	where !order.OrderDetails.Any(o => o.ProductId == od.ProductId)
	select new OrderDetails
   		   {
			OrderId = order.Id,
			ProductId = od.ProductId
   		   };
```

Here a different scenario applies.  Adding directly to the database succeeds, but the Order.OrderDetails collection isn't updated to show the added Products.
``` csharp
DataContext.OrderDetails.InsertAllOnSubmit(toAdd);
```

To ensure the Order.OrderDetails collection is also up-to-date, we'd have to add the order details via the collection.
``` csharp
order.OrderDetails.AddRange(toAdd);
```
