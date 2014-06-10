---
layout: post
title: A MoCA home network
date: 2014-04-09 13:27
comments: true
categories:
- technology
---
The benefits of a wired home network are many.  I use the [SiliconDust HDHomerun Prime](http://www.silicondust.com/products/hdhomerun/prime) network TV tuners to watch cable TV on any computer in the house without the need for a set-top box.  However, it is quite bandwidth-intensive and even a wireless-N connection just doesn't cut it.  The picture would be plagued with stutters, pause and artifacts and is pretty much unwatchable, especially hockey with its lightning-fast actions.

For wired connectivity without an existing Ethernet network there are three options.  The best option from both cost and performance standpoints is available if the house is wired for a land line with Cat-5/5e/6 wiring, which is invariably the case with a modern construction.  In this case you can just use the existing wiring and swap the existing RJ11 telephone jacks for RJ45 Ethernet jacks.  This requires a bit of manual labor but the results are beautiful and satisfying.  I did this for a previous residence and it worked wonderfully. Unfortunately in my current house the wiring leaves something to be desired.  The phones lines are not wired point-to-point but daisy-chained together; this rules out an Ethernet network. 

The second option is to use the power lines themselves, which hopefully every house comes equipped with. I used a pair of TP-Link AV500 Nano power line adapters.  Installation couldn't be any easier--plug them into the power sockets and they just work. The LAN connection is automatically detected in Windows and OS X.  My tests showed that the connection was able to achieve the the full bandwidth that I am supposed to get. My TV feed no longer stuttered or became corrupted. Unfortunately this solution isn't perfect either.  Under heavy load the adapters had a nasty habit of tripping the circuit breakers.  I couldn't even run the network speed test while Windows Media Center was playing without bringing the power down.  Since the powerline adapters don't play nice with surge protectors I don't really have a way to prevent it from happening.

This leaves the last option, a home network over the coaxial cabling, which like most American household we have plenty of. Each room has one, sometimes two, coaxial outlets. The industry standard for a home network over coaxial cabling is the Multimedia over Coaxial Alliance (MoCA) standard.  It seems to be a relatively young technology as there aren't many products for it. Interestingly this is something I'm already using as a Verizon FiOS subscriber.  Verizon uses MoCA for the Optical Network Terminal (ONT) which converts the optical fiber signal to electric signal. To use the coaxial cabling to carry Ethernet network traffic requires a MoCA network adapter or bridge, which converts between the different signal formats. I have the standard [Actiontec MI424WR router](http://www.actiontec.com/189.html), which has a built-in MoCA adapter.   It would act as one endpoint.  For each additional endpoint, I would need a separate MoCA network adapter. There are only a handful of MoCA network adapters, the most popular of which the [Actiontec ECB2500C](http://www.actiontec.com/251.html).

I wasn't sure about the best way to set up the MoCA network.  The MI424WR router can connect to the ONT via a coaxial or Cat-5, but it has only one coaxial terminal. In my case the MoCA WAN comes into the router via the coaxial connection. At first I wasn't sure whether I could connect to the MoCA LAN using the same coaxial terminal. I thought that I could only connect the router to the MoCA WAN, then would need an additional MoCA adapter for each outgoing connection from the router.  This possible setup is shown in the below figure.  I would need 4 MoCA adapters for extending connectivity to 2 rooms.

![](http://yentran.isamonkey.org/gallery/moca-home-network/moca-bad.png)

Fortunately, this scenario isn't necessary.  It turns out that the router can connect to both MoCA WAN and MoCA LAN through the same coaxial connection. This is because the respective networks operate over different frequency bands and do not interfere with each other. I would only need a MoCA adapter at each receiving end.  Since I can use the router as a MoCA adapter in one room, I'd only need one additional MoCA adapter.

![](http://yentran.isamonkey.org/gallery/moca-home-network/moca-good.png)

Of note, the cable splitter must be MoCA-compatible. Since MoCA operates in the 0.5-1.65 GHz frequence band, the splitter should be rated for at least this range. Fortunately there are many inexpensive options.