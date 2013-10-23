---
layout: post
title: Configuring Wifi for the Brother HL-2280DW Laser Printer on Windows
categories:
- technology
tags:
- brother
- installation
- printer
- software
status: publish
type: post
published: true
meta:
  _edit_last: '1'
  aktt_notify_twitter: 'no'
---
With laser printer, scanner, Ethernet and Wifi interface rolled into one, the Brother HL-2280DW is quite a little champ. However, for me, getting the Wifi to work was a bit of a challenge. The installer would die silently after configuring Wifi but without having installed the software. After some trial and error, I was able to successfully install for Ethernet . With the software installed, I was able to configure Wifi afterward. Additionally, I was able to set up a static IP address for the printer which isn't available from the installer. Here are the steps for getting Wifi to work.

* Start the installer from the CD-ROM (double-click on start.exe if it doesn't launch automatically)
* If this is the first installation, select Install MFL-Pro Suite. If you get the Wifi to work on the first attempt, you can stop reading. If not, try installing for either Ethernet or USB then go to the next step.

<img src="https://dl.dropboxusercontent.com/u/52804626/brother-printer/install-start.png" alt="install-start" />

* Once the software is installed either for another interface (Ethernet or USB), start the installer and select Wireless LAN Setup Wizard

<img src="https://dl.dropboxusercontent.com/u/52804626/brother-printer/wireless-install.png" alt="wireless-install" />

* On the Setting Up Wireless screen, I selected No to WPS/AOSS

<img src="https://dl.dropboxusercontent.com/u/52804626/brother-printer/wireless-wps.png" alt="wireless-wps" />

* On Importance Notice, check and select next, assuming you know your Wifi network's settings
* On the second Setting Up Wireless screen, select Temporarily use a USB cable (Recommended)

<img src="https://dl.dropboxusercontent.com/u/52804626/brother-printer/wireless-connect.png" alt="wireless-connect" />

* Once you connect the USB cable, the installer attempts to connect to the printer
* Once it completes, the little USB icon on the task bar should show success messages

<img src="https://dl.dropboxusercontent.com/u/52804626/brother-printer/usb-connected.png" alt="usb-connected" />

* The installer then attempts to search for Wifi networks. If your network is discoverable, it should show up on the list. Otherwise, select Advanced to configure it manually. If you select an existing network, the installer automatically detects Authentication settings. In either case, you have to enter the network key or password. This is a fairly run-of-the-mill process for setting up Wifi.

<img src="https://dl.dropboxusercontent.com/u/52804626/brother-printer/wireless-ssid.png" alt="wireless-ssid" />

* Once you're done configuring Wifi, the installer sends the settings to the printer

<img src="https://dl.dropboxusercontent.com/u/52804626/brother-printer/wireless-submit.png" alt="wireless-submit" />

* Disconnect the USB cable

For various reasons, I want the printer to use a static instead of dynamic IP address. The address has to be configured separately on Windows and on the printer.

### Windows

* Select Start > Devices and Printers

<img src="https://dl.dropboxusercontent.com/u/52804626/brother-printer/control-printers-off.png" alt="control-printers-off" />

* Double click on the printer icon to open the Printer Properties. Notice that the printer may be Offline.

<img src="https://dl.dropboxusercontent.com/u/52804626/brother-printer/printer-offline.png" alt="printer-offline" />

* Double click on Customize your printer

<img src="https://dl.dropboxusercontent.com/u/52804626/brother-printer/printer-properties.png" alt="printer-properties" />

* Click Change Properties and enter the administrator password if prompted
* Select the Ports tab

<img src="https://dl.dropboxusercontent.com/u/52804626/brother-printer/printer-ports.png" alt="printer-ports" />

* Select Configure Port and Enter the desired static IP address

<img src="https://dl.dropboxusercontent.com/u/52804626/brother-printer/port-setings.png" alt="port-setings" />

### Printer

* Select Menu > Network > WLAN, pressing OK after each selection
* (Optional) To see the current settings, select Menu > Machine Info > Network Config  and press Start. The printer will print out the current settings. The dynamic TCP/IP address is most likely different from the one you set in Windows. This means the printer will not be detected.
* To configure a static IP address for the printer, Select Menu > Network > WLAN > TCI/IP
* Select Boot Method > Static
* Select IP ddress. There are two options here, up arrow is Change, down arrow is Exit. Hit up arrow to see the current TCP/IP Address. You edit each field by using the arrow keys then press OK to move to the next field. Make sure the value here matches the IP address in Windows..
* (Optional) Select Subnet Mask and review the value
* (Optional) Select Gateway and review the value
* (Optional) Select Node Name and enter a more human-readable name for the printer, which will appear in the list of connected devices, instead of something like BRW0023945AEBCF
* (Optional) Verify the value under DNS Server
* Back in Windows, the printer should show up as Ready. If not, try turning the printer off and on.

<img src="https://dl.dropboxusercontent.com/u/52804626/brother-printer/printer-ready.png" alt="printer-ready" />
