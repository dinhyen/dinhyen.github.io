---
layout: post
title: Installing Windows 7 for the ASRock 939Dual-SATA2 motherboard
categories:
- technology
tags:
- driver
- install
- Windows 7
---
The [ASRock 939Dual-SATA2](http://www.asrock.com/mb/overview.asp?Model=939Dual-SATA2) motherboard is a little long in the tooth but still quite capable.  Mine has been running Windows XP Media Center Edition for some time and I decided to upgrade it to Windows 7.  The challenge is that the motherboard's JMicron SATA2 chipset isn't detected automatically at installation.  If you want to install Windows on a SATA hard drive, you will have to load the driver first.  The other problem is that, as of the time of writing, there is no Windows 7 driver for the ULi integrated Ethernet controller due to the age of the hardware.  You would have find another workaround for this issue.
# Installing Windows
Download the drivers for the JMicron SATA2 controller from the [ASRock download site](http://www.ASRock.com/mb/download.asp?Model=939Dual-SATA2&amp;o=XP).  The drivers are for Windows XP but they will work for Windows 7.  Expand the archive and put them on a USB drive.

Pop in the installation DVD.  When the computer starts up, hit F2 to enter set-up.  Make sure that  SATA2 controller is enabled and running in SATA mode instead of IDE mode.  Verify that the SATA hard drive is detected.  Under the Boot menu, select the DVD drive as the primary boot device.  Alternatively, I could have also used a bootable USB drive or copied the files to the IDE hard drive and run the installation from there.  For me, booting from DVD was just simpler.

When the prompt comes up, hit any key to boot from the DVD.

At the screen where the available hard drives and partitions are listed, you will probably not see your SATA hard drive.  Select Load Driver and browse to the Floppy32 (yes, floppy) folder on the USB drive.  A JMicron SATA2 driver should be listed.  Select it and the installer will load the drivers.  After this step you should see the SATA hard drive listed.  I formatted the drive as well, as in my case installation didn't succeed otherwise.

After a couple of reboots, Windows 7 should be good to go.
# Installing the LAN drivers
Windows 7 won't be able to find drivers for the ULi integrated Ethernet controller.  If you have a USB Ethernet adapter or a second Ethernet adapter with which you can use to go online, you could simply tell Windows to update the driver for the ULi controller and it would do so successfully.  I didn't have either option so I had to use another machine to transfer the drivers.

As pointed out on [this forum thread](http://social.technet.microsoft.com/Forums/en/w7itproinstall/thread/865bdb49-3b6a-461c-8aa2-166 586c457c3), you can use the ULi LAN 352 drivers.  These are intended for Windows Vista, but they work fine for Windows 7.  From the other machine, [download](ftp://download.asrock.com/drivers/ULi/LAN/Lan(352).zip) the driver package from the ASRock download site.  The package contains an EXE.  Since you probably won't want to install the drivers on the wrong machine, you can open the EXE file (yes, EXE) with Winrar or another archiver and extract its content to a USB drive.

Back in Windows 7, open the Device Manager and locate the Ethernet device (which shows a yellow exclamation mark).  Select Update Driver, then Browse for Driver.  Browse to the USB drive.  There are 32- and 64-bit flavors of the Vista drivers. Select the appropriate one for your Windows installation.  The device will show up as the ULi M526X Ethernet controller.
