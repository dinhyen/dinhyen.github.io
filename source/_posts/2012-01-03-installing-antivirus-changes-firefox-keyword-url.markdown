---
layout: post
title: Installing antivirus program changes FireFox keyword URL
categories:
- technology
tags:
- firefox
- keyword
- url
- yahoo
status: publish
type: post
published: true
meta:
  aktt_notify_twitter: 'no'
  _edit_last: '1'
  _wp_old_slug: panda-active-scan-changes-firefox-keyword-url
---
I tried out a well-known cloud-based antivirus solution.  It worked well enough, but after I installed it, I noticed that my FireFox searches were now redirected from Google to Yahoo!.  In the FF config screen (which can be opened by typing "about:config" in the location bar), I noticed that the keyword.URL setting had been changed to Yahoo!:

<img title="panda-yahoo-keyword-url" src="http://www.yentran.org/blog/wp-content/uploads/2012/01/panda-yahoo-keyword-url.png" width="1212" height="113" />

This setting dictates which search service is used when the user enters a keyword (i.e., anything that does not resemble a URL like http://yahoo.com).  While Yahoo! search is no doubt capable, this type of unsolicited change is quite annoying, particularly for a product that's intended to detect and remove malware.  I reverted the setting back to Google by changing its value to `http://www.google.com/search?ie=UTF-8&amp;oe=UTF-8&amp;q=`.

Needless to say I wasn't sticking with this product.
