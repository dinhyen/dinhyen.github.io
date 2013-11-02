---
layout: post
title: Fixing Windows Media Center No Tuner Available Error With HDHomeRun Prime
comments: true
categories: 
---
I have the HDHomeRun Prime network tuner.  Recently, after a Verizon FiOS tech rebooted the ONT to fix a network issue, I got the dreaded `Viewing or Listening Conflict. No tuner available to satisfy the current request` error when trying to view Live TV in Windows Media Center.  When I tried Settings > Windows Media Center setup, I got the error:

> Tuner Not found. The TV signal cannot be configured because a TV tuner was not detected. If you have a tuner, ensure it is installed correctly.  To find out how to watch TV on your PC, visit http://www.windows.com/pctv.


Since I was able to view cable TV using the Quick TV application, the tuners seemed to be working properly. I tried upgrading the SiliconDust software, re-installing PlayReady for WMC, rebooting the router, turning off the Windows Firewall, none of which made any difference.  I opened the Services panel and verified that the Windows Medica Center Receiver Service and the HDHomeRun Service are started.

All this resulted in lost time and furthered the belief that MS just can't seem to make simple tasks as effortless as Apple.  Finally I figured it out -- I had to turn on Network Discovery.  I'm not sure why it was turned off in the first place, but it had to be running for WMC to detect the tuners.

Simply open Windows Explorer and select the Network tab in the sidebar.  You should see the HDHomerun Live DRIxxxx devices under the Media Devices section.  If you don't, Windows will ask if you want to turn on Network Discovery.  Do this.  If you're lucky, once you'll have done this WMC will immediately detect the tuner and you're done. Otherwise, you can turn on Network Discovery in the Network and Sharing Center > Advanced sharing settings.