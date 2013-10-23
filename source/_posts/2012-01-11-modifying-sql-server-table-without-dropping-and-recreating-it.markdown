---
layout: post
title: Modifying SQL Server table without dropping and recreating it
categories:
- technology
tags:
- sql server
- tip
status: publish
type: post
published: true
meta:
  aktt_notify_twitter: 'no'
  _edit_last: '1'
---
The SQL Server Designer is a nice visual tool for making modifications to a table. However, when you save the changes, SQL Server actually drops the entire table and then recreates it (if there are data in the table, they would be retained). This happens even if the changes made do not actually require that the table be re-created. This is presumably so that SQL Server can accommodate all possible types of modification.

However, oftentimes it's not possible to drop a table. This can happen if the table has relationships with other tables. You could drop the relationships first, but it may be more trouble than it's worth when you're just making changes to a column.

The solution is quite simple--just use SQL instead of the Designer. For instance, to add an int column to a table, you could use the alter table command:
<pre>alter table [table name] add [column name] int null</pre>
The added column must be nullable if there are existing data, because there are no values in the column when it is added. To make the column non-nullable, first provide a value in the column for all data rows then do the following:
<pre>alter table [table name] alter column [column name] int not null</pre>
