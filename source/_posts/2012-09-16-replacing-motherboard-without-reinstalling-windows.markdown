---
layout: post
title: Replacing motherboard without reinstalling Windows
categories:
- technology
tags:
- installation
- Windows 7
---
I wanted to upgrade a couple of PCs by replacing the motherboard (by the way, when buying PC components, if there's a [Microcenter](http://microcenter.com/) store nearby, try it first; at the time of this writing their $50 bundle discount for a motherboard-CPU combo cannot be beat, even by much-loved online enthusiast stores).  Afterwards, I found that Windows 7 wouldn't boot.

In my prior experience, Windows would automatically detect the new motherboard and reconfigure itself accordingly.  However, in those cases, I'd always replaced an AMD motherboard with the same.  This time I finally succumbed to Intel's growing CPU superiority and swapped an AMD motherboard for an Intel one. Windows would load drivers, crash, then reboot.  Apparently Windows wasn't able to load the drivers to work with the new motherboard. I ran Startup Repair once without success.  After I ran it the second time, Windows complained that "Startup Repair cannot repair this computer automatically".  I was resigned to reinstalling Windows from scratch.  This isn't actually a horrible thing, since all my data are on a separate partition, but it would mean I'd have to reinstall and configure apps all over again.

Luckily I found [a post](http://www.msigeek.com/2661/add-or-remove-a-driver-from-a-wim-image-using-dism) describing how to use the DISM (Deployment Image Servicing and Management) command-line tool.  This tool, intended for sysadmin use, allows you to load drivers into an existing Windows image or installation.  Our goal is to pre-load the necessary drivers to hopefully allow Windows to run on the new motherboard.  Here are the steps that worked for me.

1. Download drivers for the new motherboard.  I'm using a USB flash drive as a boot/recovery drive so I copied them there, but you could use separate USB flash drive or even a DVD-R. You need the chipset and SATA drivers.  You can ignore the audio, LAN, video, etc. drivers as they are not necessary for Windows to load and can be left till later. Driver packaging depends on the manufacturer.  In my case, for my [Gigabyte motherboard](http://www.gigabyte.com/products/product-page.aspx?pid=3726#dl) the chipset drivers are bundled in a single archive, while for the [Asrock motherboard](http://www.asrock.com/mb/Intel/Z77%20Extreme4/?cat=Download&os=Win7), they're all in separate files. Extract the files (some executables can be extracted) and copy only the appropriate folder for your flavor of Windows. The folder should contain an .INF file and .DLL or .SYS files.
1. Boot from your Windows install/recovery DVD or USB flash drive and select Repair
1. Select Advanced Options
1. Choose the Command Prompt option to get the command line
1. Now determine the drive where Windows is installed. This may not be where you think it is if the drives are remapped, say when you boot from a USB flash drive. The quickest way is just to list the files on drives C:, D:, E:, etc. and figure out which is which.
1. Let's say Windows is installed under C: and the drivers are under D:\mydrivers, use DISM follows:
<pre>
dism /image:C: /add-driver /driver:D:\mydrivers /recurse
</pre>
The `/recurse` option conveniently lets DISM  install all drivers found under the specified folder.
1. Reboot. If Windows successfully boots, congratulations! The next step would be to configure the Ethernet adapter so you can install the rest of the drivers.