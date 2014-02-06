---
layout: post
title: "Updating SQL Server Primary Key"
date: 2014-11-23 16:34
comments: true
categories:
- technology
---
A requirement recently came up to update the primary key in a SQL Server table while retaining existing data (it's a long story).  I suppose one way to do so would be to drop any existing foreign-key constraint and update all related tables.  Unfortunately, the table in question is the User table, which is related to practically every other table in the schema. Updating a bunch tables manually, without the safety net of relational integrity, would be a bit dodgy (for lack of a better word in American English). Fortunately, there's a less painful approach using the [ON UPDATE CASCADE](http://technet.microsoft.com/en-us/library/ms186973.aspx) clause. 

In a simple example, I have a LineItem table, whose `userId` field references User's `Id` field. Since the existing FK relationship doesn't have ON DELETE CASCADE, I'd have to "alter" the constraint to add it.  But because is no "alter contraint" in T-SQL, I'd have to drop and re-add the constraint.

``` sql
/* drop existing constraint */ 
ALTER TABLE [dbo].[LineItem] DROP CONSTRAINT [FK_LineItem_User] 
GO 

/* add constraint */ 
ALTER TABLE [dbo].[LineItem]  WITH CHECK ADD  CONSTRAINT [FK_LineItem_User] FOREIGN KEY([UserId]) 
REFERENCES [dbo].[User] ([Id]) 
ON UPDATE CASCADE 
GO 

ALTER TABLE [dbo].[LineItem] CHECK CONSTRAINT [FK_LineItem_User] 
GO 
``` 

Then when I update an Id in the User table, the change would be cascaded to LineItem and all other related tables.
