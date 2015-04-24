---
layout: post
title: "Copying files in Hudson"
date: 2014-04-15 20:05
comments: true
categories:
- technology
---
Copying files somewhere is pretty standard procedure when deploying an app.  Interestingly I've never had to copy files directly in Hudson.  Until now I've only deployed .NET apps in Hudson and used MSBuild's Copy task to copy the files to a share folder.  Now that I want to deploy Angular and other client apps in Hudson, I'd have to copy the files manually.

My initial attempt was to add a new Execute Shell build step to run `xcopy`.  Since Hudson executes the command through the Bourne shell, which interprets any backslash in the path as the escape character, I'd have to escape the backslash itself.  Why Windows has to be different from everyone else is a major source of annoyance if you have to move back and forth between Windows and *nix.
```
xcopy c:\\source\\app\\* \\\\server\\share\\app
```
This worked, but in order for xcopy to copy subdirectories, refrain from prompting everytime it needs to overwrite a file and take other actions necessary for unsupervised execution, I needed to specify additional parameters.
```
xcopy c:\\source\\app\\* \\\\server\\share /c /k /e /r /y /exclude:c:\\source\\xcopy_exclude.txt
```
Unfortunately this was when xcopy blows up with the "invalid number of parameters" error.  It probably had to do with the shell not passing the parameters to xcopy.  No dice if I put the command in a batch file then executing it.  Ditto when I tried `robocopy`, which prints a nicer error message but is functionally the same as xcopy.  As a note, you could test all of this in a Bourne shell rather than invoking Hudson every time.

It occurred to me to use something that's native to the shell, rather than trying to get it to play nice with xcopy.  You'd still have to deal with the backslash in the share:
```
cp -r /c/source/app/* \\\\server\\share
```

This worked!  Also for things like "rm -rf".  We're done, right?  Well, this mixmatching of different command-line styles seems unwieldy.  After I experimented further, it turned out that I had made an error from the start.  In addition to the Execute Shell build step, there's another type called Execute Windows Batch Command.  This build step allows you to run commands in a Windows shell.  Thus you can run execute xcopy, or anything else, as you would in the command prompt without needing to escape backslash.

I'd also like to be able to specify the share folder at run time so the project can be deployed to different servers.  In my initial attempt, I created a drop-down list parameter for the server name.  Then I figured to use the following xcopy command which incorporates the SERVER parameter.
```
xcopy c:\source\app\* \\%SERVER%\app
```
The %SERVER% syntax is used to reference an environment variable in Windows.  This approach turned out to be an abject failure.  It turned out that entire share has to be specified as an environment variable; e.g., %SHARE% should point to \\server\app.  Then I could issue commands such as:
```
del /s /q %SHARE%\*
xcopy c:\source\app\* %SHARE%
```