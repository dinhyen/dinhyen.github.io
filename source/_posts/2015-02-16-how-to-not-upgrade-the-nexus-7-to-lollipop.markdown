---
layout: post
title: "How to not upgrade the Nexus 7 to Lollipop"
comments: true
categories:
- technology
---
I have a first-generation Nexus 7 tablet made by Asus which ran KitKat 4.4.  When the OTA Lollipop update became available, I couldn't wait to install it.  The latest and greatest Android running on Google hardware seemed to be a match made in heaven; it would be better, prettier and faster, right?  As you can probably guess from the title of this post, the answer was a resounding *no*.  Everything became sluggish, swipes would only registered after a couple of seconds, random things popped open and close.  The tablet was downright unusable.

Rather than splurging for a new tablet, which was probably what Google wanted me to do, I opted to go back to KitKat, since the hardware itself was perfectly fine.  The [process to restore the KitKat system image](https://developers.google.com/android/nexus/images) using the ADB command-line tool that accompanies the Android SDK was quite simple.  I had some difficulty to get my Windows 7 machine to recognize the Nexus 7, until I installed the [Google USB drivers](http://developer.android.com/sdk/win-usb.html).  Alternatively, I could have ran ADB on a Mac, for which USB drivers wouldn't have been necessary.  An important part of the process was to make sure I chose the correct system image.  For a Nexus 7, the KitKat image was "nakasi" 4.4.4 (KTU84P).  The image archive contained a flashing script that I executed after unlocking the bootloader.  The whole thing took about 5 minutes once everything worked.

So with its brain transplanted with a fresh KitKat image, the Nexus was back to its own happy self.  Unfortunately, the good feeling didn't last long.  In short order, Android started notifying me that the 5.0 system update aka Lollipop had *already* been downloaded and ready to install.  There was no way to dismiss the notification or tell it to remind me again in, oh, never.  The helpful notification sat in the system tray and just generally got in the way.  This is by far one of the worst instances of nagware-ism.

To disable the system update notification, I had to root Android.  Fortunately at this point there were a few mature tools that make doing so quite simple.  I used the [Nexus Root Toolkit 2.0.4](http://www.wugfresh.com/nrt).  Since I was on a fresh install of KitKat, all I had to do was to 1) unlock the bootloader, and 2) root.  The toolkit also installs a couple of useful tool such as SuperSU and BusyBox Installer.  The latter lets you grant root privilege on-demand to any app that requests it.

The next step was to turn off the system update notification service.  There are a few apps, the one I used being DisableService.  Once I navigated to the Google System Service node, System Update Service was already disabled.  Hmm, clearly that wasn't it because there was still a big fat notification in the system tray.  It turned out that I had to go to the Google Play Services node.  Lo and behold, there was another System Update Service.  Disabling this one and restarting the device did the trick.

![](http://yentran.isamonkey.org/gallery/nexus-7-kitkat/disable-service.png)