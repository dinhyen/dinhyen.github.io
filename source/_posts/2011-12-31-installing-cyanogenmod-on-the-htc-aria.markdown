---
layout: post
title: Upgrading the HTC Aria with Android Gingerbread and CyanogenMod
categories:
- technology
tags:
- android
- cyanogenmod
- gingerbread
- mod
- upgrade
status: publish
type: post
published: true
meta:
  _edit_last: '1'
  aktt_notify_twitter: 'no'
---
I have an HTC Aria which runs now-ancient Android 2.1. This phone is far from being the latest and greatest, to put it mildly, but I like its small form factor. After putting up with it for a year, I have had enough and decided to upgrade it to Gingerbread.  This is how I did it. As this is my first attempt, no doubt there are different and better ways to do things. Kudos should go to the developer and enthusiast community for making all of this possible.
### Root the phone
Avoid the hassle of dealing with Windows USB drivers. Download and run the custom Linux image with pre-configured utilities as described in <a href="http://forum.xda-developers.com/showpost.php?p=7449486&amp;postcount=1">this post</a>.  Follow the instructions in the post to root the phone and install the ClockworkMod recovery image.
### Backup application data
Backup is always a good idea, especially before making such a radical change to the phone.  Now that I have root access, there are a few options. The Mybackup Root app from the Android Market lets you backup data including contacts, SMS, call log, calendar, dictionary, music playlists, etc.  You can also use it to backup applications (APKs) and application data. The backups are saved to the phone's SD card.  In my case, I mount the phone as USB storage and copy the backup to a computer just to be on the safe side. The backups are found on the SD card under /rerware.
### Download CyanogenMod
I decide to go with CyanogenMod, a very popular mod with support for a wide range of Android devices, including the Aria.  The current version of CyanogenMod as of this writing, version 7, is based on Android Gingerbread.

<a href="http://download.CyanogenMod.com">Download</a> CyanogenMod. Select the latest stable build or, if you're feeling adventurous, a nightly build. For the Aria, select the Liberty on the device list. Copy the CyanogenMod zip file to the phone's root directory.
### Reboot into recovery mode
First turn off phone (taking out the battery is the quickest way). Boot into recovery mode by holding down Volume Down and Power buttons.  Once phone boots, the screen should show HBOOT. Use the Volume buttons to scroll and the Power button to select "recovery" to put the phone in recovery mode.
### Backup (again)
In case some thing goes wrong, I'd like to be able to go back to the way things were.  ClockworkMod recovery provides a powerful backup utility called nandroid, which lets you backup the entire content of the phone's SD card (NAND flash -- NANDroid, get it? :-))  To use nandroid, select "nandroid" in recovery mode and follow the on-screen instructions. I also copy the backups from the SD card to a computer for good measure (after rebooting and mounting the phone as USB mass storage).
### Install CyanogenMod
This step is based on instructions provided in <a href="http://forum.xda-developers.com/showthread.php?t=956223">this post</a>.  In recovery mode, wipe the phone in preparation for the new OS by selecting the following:

* Wipe cache partition
* Wipe data/factory reset
* Clear Dalvik cache (under Advanced)

To install the mod, again in recovery mode:

* Select "install zip from SD card"
* Select "choose zip from SD card" and locate the zip file you copied earlier on the SD card
* Wait for the install to complete
* Go back a couple of levels and select "reboot system now"

You should see the CyanogenMod skateboarding Android logo while the phone reboots. Once your phone comes up, it will be sporting the sleek interface of Android Gingerbread! Here's a screenshot as proof:
<img title="htc-aria-after" src="http://www.yentran.org/blog/wp-content/uploads/2011/12/htc-aria-after.png" width="320" height="480" />

### Install the Google Apps package
It's highly recommended that you also install the <a href="http://goo-inside.me/gapps">Google Apps package</a> . This package contains useful apps which for certain reasons the CyanogenMod team is not able to bundle with the mod. These include the Android Market, Gmail, Facebook, Google Maps, YouTube, etc.

There are a few ways to install the package, the simplest of which is to follow the same steps to install CyanogenMod using ClockworkMod recovery. In my case, I was only able to successfully install the latest app package; the older packages just did not work.

The installation actually takes place once the phone is rebooted. Android Market is automatically installed first, then it's used to install the other apps. <a href="http://www.youtube.com/watch?v=DHgZNnHdrSA">This video</a> shows the process step by step. In my case, I have to install just the Android Market, then install other apps from there; otherwise the apps would crash when launched.
### Restore backups
If you've made backups using Mybackup Root, you can reinstall the app then use it to restore your data.
