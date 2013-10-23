---
layout: post
title: Intermittent, temporary freezing on MacBook with OCZ Vertex 3
categories:
- technology
tags: []
status: publish
type: post
published: true
meta:
  _edit_last: '1'
  _wp_old_slug: intermittent-temporary-freezing-on-os-x-with-ocz-vertex-3
---
I recently upgraded the hard drive on my MacBook Pro running Snow Leopard to a 120GB OCZ Vertex 3 SSD.  As advertised, the boot up and application start times are dramatically reduced.  The SSD is everything I had hoped for. Well, almost.  There has been a persistent and quite annoying issue.  At random intervals, the computer would be come unresponsive.  I could move the mouse or type on the keyboard, but nothing woud happen.  When I hovered over the menu bar, I got the spinning "beachball".  The lag would last anywhere from 5-10 seconds.  Then all of a sudden all the actions I had performed in the interim would be executed in rapid succession, as if the computer had been jerked awake.  This was most noticeable during a streaming video, which would pause when one of these episodes hit.  The problem made the computer borderline unusable.

I'm happy to report that a firmware update for the Vertex 3 appeared to solve this problem.  I had firmware version 2.15, while the most current version was 2.25.   To upgrade the firmware, I followed the instructions for using the OCZ Bootable Toolbox on the OCZ forum. I had to use the [PC instructions](http://www.ocztechnologyforum.com/forum/showthread.php?105168-NEW!!-OCZ-Bootable-Toolbox-PC-Edition-%28REBUILD%29), since the Mac instructions are not applicable to my pre-2009 MacBook.  For me, the steps were to install the custom ISO disk image on a USB drive, then boot the PC from the USB drive.  The Vertex 3 had to be connected to an internal SATA port, as the OCZ Toolbox was not able to detect it if mounted in a USB enclosure.  This required me to open up the PC, a minor inconvenience.  The PC should also have an Internet connection. Overall, the process was painless and took under 5 minutes.

The MacBook has been humming along so far without a hiccup.
