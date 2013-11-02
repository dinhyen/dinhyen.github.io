---
layout: post
title: ! 'Wix: Executing custom action before starting Windows service'
categories:
- technology
tags:
- wix
---
I've been trying to get a Wix installer to work. This particular scenario is pretty simple. I want to configure the database via a custom action, then start a Windows service which then queries the database before starting.  This would seem like a commonplace scenario. However, Wix documentations are sparse and I've been wrangling with this for some time.  I finally found a solution.  While I loathe to reference a StackOverflow answer, as a favor to my future self I'm going to do so anyways.

The following defines the component that installs and starts the service and creates a feature that references it.

``` xml
<ComponentGroup Id='b_SyncSvcComps' Directory='b_SyncInstallDir'>
  <Component Id='b_SyncSvc'>
    <File Id='b_SyncExe' Name='MyService.exe' Source='$(var.syncSrcDir)\MyService.exe' DiskId='1' KeyPath='yes' />
    <ServiceInstall Id='b_InstallSyncSvc' Type='ownProcess' Name='MyService' DisplayName='My Service' Description='My Service' Start='auto' Account='[SERVICEACCOUNT]' Password='[SERVICEPASSWORD]' ErrorControl='normal' />
    <ServiceControl Id='b_StartSyncSvc' Start='install' Stop='both' Remove='uninstall' Name='MyService' Wait='yes' />
  </Component>
</ComponentGroup>

<Feature Id='b_ConnectedModeFeature' Title='Connected Mode Features' Level='1'>
  <ComponentGroupRef Id='b_SyncSvcComps' />
</Feature>
```

The following snippet in Product.wxs actually installs the feature:

``` xml
<Feature Id='b_Features' Title='[ProductName]' Level='1'>
  <FeatureRef Id='b_ConnectedModeFeature' />
</Feature>
```

This is the initial version of the custom action that I want to run.

``` xml
<CustomAction Id="DbBatchCmd" Directory='B_DBINSTALLDIR' Execute="immediate" Impersonate="yes" Return="check" ExeCommand="[SystemFolder]\cmd /c &quot;&quot;setup_database.cmd&quot; &quot;[b_WebServer]&quot; &quot;[b_DbServer]&quot;&quot;" />
```

The following snippet in Product.wxs runs the custom action.  Here it is run after InstallFinalize, the last possible step in the installation's sequence of events.  The condition ensures that it is only run if the product isn't already installed.

``` xml
<InstallExecuteSequence>
  <Custom Action="DbBatchCmd" After="InstallFinalize">NOT Installed</Custom>
</InstallExecuteSequence>
```

According to the above, the installer tries to start the service before it runs the custom action to configure the database.  Of course, since the service requires the database to be set up, it balks.

Among others, I tried running the custom action earlier using the `Before="StartServices"` and `After="InstallFiles"` attributes. The latter makes sense because the installer needs to copy files to the file system before it can execute the script.  When inspected with Orca, the MSI has the correct InstallExecuteSequence:
<pre>
...
InstallFiles              4000
DbBatchCmd  NOT Installed 4001
InstallServices VersionNT 5800
StartServices VersionNT   5900
...
InstallFinalize           6600
</pre>

However, the installer never executes the custom action.  It always tries to start the service and almost immediately fails. In fact, the custom action only runs when it's set to `After="InstallFinalize"` as above.

One of the key things was provided by the helpful if somewhat verbose Windows installer log, which is created when you start the installer as follows:

<pre>
msiexec /i myinstaller.msi /l*v myinstaller.log
</pre>

Someday, Microsoft will have consistent command-line arguments.  The log has this to say about the service:

<pre>
MSI (s) (3C:A8) [17:10:02:607]: Note: 1: 2262 2: Error 3: -2147287038 
Info 1721.There is a problem with this Windows Installer package. A program required for this install to complete could not be run. Contact your support personnel or package vendor. Action: DbBatchCmd, location: C:\inetpub\wwwroot\MyApp\Database\, command: C:\Windows\SysWOW64\\cmd /c ""setup_database.cmd" "my_webserver" "my_dbserver"" 
Action ended 17:10:02: ShipBatchCmd. Return value 1.
</pre>

This is followed by entries for InstallServices and StartServices.  So the installer does try to run the custom action but fails.

The [answer](http://stackoverflow.com/questions/778210/wix-trying-to-figure-out-install-sequences) is provided by Rob Mensching, who created Wix.  According to him, `After="InstallFiles"` is correct. However, the execution needs to be "deferred" until the files are actually copied to the file system.  Below is the corrected XML.

``` xml
<CustomAction Id="DbBatchCmd" Directory='B_DBINSTALLDIR' Execute="deferred" ExeCommand="[SystemFolder]\cmd /c &quot;&quot;setup_database.cmd&quot; &quot;[b_WebServer]&quot; &quot;[b_DbServer]&quot;&quot;" />

<InstallExecuteSequence>
  <Custom Action="DbBatchCmd" After="InstallFiles">NOT Installed</Custom>
</InstallExecuteSequence>
```