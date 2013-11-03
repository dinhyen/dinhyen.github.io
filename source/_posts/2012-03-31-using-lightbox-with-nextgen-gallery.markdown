---
layout: post
title: Using Lightbox with NextGen gallery
categories:
- technology
tags:
- plugin
- tip
- wordpress
---
In my former Wordpress blog, I used the excellent [NextGen plugin](http://wordpress.org/extend/plugins/nextgen-gallery/) to manage images in galleries.  When embedded in a post, the gallery is rendered as thumbnails, whose full-size version  is shown as an overlay when clicked.  I also like to embed inline images so that I can include a caption.  Inline images, however, are still directly linked and not shown as an overlay.  When viewed, it requires an additional click or two to go back to the post.

To make sure that inline images are opened on the same page, I use the [Slimbox plugin](http://wordpress.org/extend/plugins/slimbox/).  This works well, except that now when gallery thumbnails are clicked, two full-sized versions are shown, one by NextGen's built-in effect and one by Slimbox.

To solve this problem, I opened NextGen's options page and locate the Effects tab.  By default, the JavaScript Thumbnail effect is set to Shutter.  I changed it to None (or Lightbox) to ensure that only Slimbox handles the effect (Slimbox is a clone of Lightbox).  The only drawback of not using the Shutter effect is that you can't use Ajax pagination with the gallery if pagination is turned on (as of NextGen 1.9.3).
<img title="nextgen-slimbox" src="https://dl.dropboxusercontent.com/u/52804626/images/nextgen-slimbox.png" width="800" height="578" />
