---
layout: post
title: Deleting from collection with LINQ to SQL
categories:
- technology
tags:
- csharp
- linq to sql
---
I ran into an subtle bug today.  Let's say we have a shopping cart page that displays order details and allows the user to remove items from the order.  We retrieve the items in the order with the following:

``` csharp
var items = DataContext.Orders.Single(o => o.Id == orderId).Items;
```
 
To remove an item from the order, we have the following:
 
``` csharp
var itemToDelete = DataContext.Items.Single(i => i.Id == itemId);
DataContext.Items.DeleteOnSubmit(itemToDelete);
DataContext.SubmitChanges();
```

It's run-of-the-mill as far as LINQ to SQL goes.  However, we ran into the issue in which an item was still being listed even after it had been deleted.  It turned out that this was caused by how we handled deleting the item. Because we delete the item directly from the database without updating the collection that contains it,  LINQ to SQL presumably doesn't know that the collection has been modified and doesn't re-fetch it from the database, resulting in the collection being out-of-date.

To fix this issue, we can fetch the items directly from the items table:

``` csharp
var items = DataContext.Items.Where(i => i.OrderId == orderId);
```

Alternatively, we can remove the item from the collection prior to deleting it.

``` csharp
var itemToDelete = DataContext.Items.Single(i => i.Id == itemId);
DataContext.DataContext.Orders.Single(o => o.Id == orderId).Items.Remove(itemToDelete);
DataContext.Items.DeleteOnSubmit(itemToDelete);
DataContext.SubmitChanges();
```
