---
layout: post
title: Visual Studio line number macros
categories:
- technology
tags:
- editor
- line number
- macro
- visual studio
---
In Visual Studio, it's easy enough to turn on and off line numbers.  You'll have to select Tools > Options > Text Editor, expand the language of choice, select General, then toggle Line numbers under the Display section.  This can get tedious if you want to be able to show and hide line numbers at will.  To turn this process into a single click, you can record custom macros to show and hide line numbers.  However, you may not realize that the macros to do just that are already included with Visual Studio. Further, these macros will turn on and off line numbers for a number of editor types, including C#, VB, HTML and plain text.

For easy access, you can put frequently used macros into a custom toolbar. This can be done as follows:


* Create a new toolbar by right-clicking on menu bar and selecting Customize

<img title="macro-4" src="http://yentran.isamonkey.org/gallery/images/macro-41.png" width="535" height="490" />

* Select New and enter a name

<img title="macro-2" src="http://yentran.isamonkey.org/gallery/images/macro-2.png" width="326" height="133" />

* On the newly created toolbar, which is empty at the moment, open the drop-down menu and select Add or Remove Buttons > Customize
* On the Customize dialog, select Add Command
* On the Add Command dialog, select Macros in the Categories pane.  In the Commands pane, select Macros.Samples.Utilities.TurnOnLineNumbers

<img title="macro-3" src="http://yentran.isamonkey.org/gallery/images/macro-3.png" width="585" height="370" />

* Do the same to add the TurnOffLineNumbers macro, or any other useful macro
* Back on the Add Command dialog, select Modify Selection to change the macro's display name to something more readable

<img title="macro-4" src="http://yentran.isamonkey.org/gallery/images/macro-41.png" width="535" height="490" />

* The macros are now added to the new toolbar

<img title="macro-5" src="http://yentran.isamonkey.org/gallery/images/macro-5.png" width="572" height="67" />

If you're interested in viewing or modifying the sample macros that come with Visual Studio, open the Macros editor by selecting Tools > Macros > Macros IDE.  If you've written VBA macros for Excel or Word, this should look familiar. The Samples project contains modules for a number of useful macros.  The line number macros above are defined in the Utilities module.
