---
layout: post
title: How to grant permissions to the Application Pool Identity for IIS 7.5
categories:
- technology
tags:
- app pool identity
- iis 7.5
- permission
status: publish
type: post
published: true
meta:
  aktt_notify_twitter: 'no'
  _edit_last: '1'
  _syntaxhighlighter_encoded: '1'
---
Up to IIS 7 (Windows Vista and Windows Server 2008), the default app pool identity is NetworkService 7. In IIS 7.5 (Windows 7 and Windows Server 2008 R2) the app pool identity is changed to something called ApplicationPoolIdentity.

Let's say you set up a virtual directory or application that uses this app pool. You'll need to grant access permission on the physical path to ApplicationPoolIdentity. However, you'd find that there is no such user account. According to [an IIS Team blog](http://blogs.iis.net/webdevelopertips/archive/2009/10/02/tip-98-did-you-know-the-default-application-pool-identity-in-iis-7-5-windows-7-changed-from-networkservice-to-apppoolidentity.aspx), the user account associated with ApplicationPoolIdentity is actually `IIS AppPool\<App pool name>`. The intention is to further reinforce app pool isolation through the use of a separate user account for each app pool.

To grant permission to ApplicationPoolIdentity:

* Open the IIS Manager
* Right-click on the desired virtual directory or application and select Edit Permission. Alternatively, you could have used Windows Explorer to browse to the physical path and open its Properties panel.
* On the Security tab, select Edit, then Add
* If the location is set to the domain, select Locations and change it to the local machine
* In the textbox, enter `IIS AppPool\[Site Name]` for example, `IIS AppPool\Default Web Site`


<img title="select-1" src="http://www.yentran.org/blog/wp-content/uploads/2011/09/select-1-300x159.png" width="300" height="159" />

* Select Check Names and a valid user account name should appear

<img title="select-2" src="http://www.yentran.org/blog/wp-content/uploads/2011/09/select-2-300x159.png" width="300" height="159" />

* Select the desired permissions; for example, Read &amp; Execute
