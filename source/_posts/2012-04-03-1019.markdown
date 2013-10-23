---
layout: post
title: Locating Program Files folder in Visual Studio on 32-bit and x64 environments
categories:
- technology
tags:
- program files
- visual studio
- windows x64
status: publish
type: post
published: true
meta:
  aktt_notify_twitter: 'no'
  _edit_last: '1'
  _syntaxhighlighter_encoded: '1'
---
In my Visual Studio project, I want to run an external executable, SQLMetal, in a build event.  The only problem is that the location of the executable depends on whether the machine runs x64 or 32-bit Windows.  It is found in the `Program Files (x86)` folder on x64 Windows and `Program Files` on 32-bit Windows. I want to be able to build the project without modification in either environment.

The solution is to specify the location of the Program Files dynamically by inserting the following lines in the .csproj file.  You can either open the .csproj file directly in a text editor or, in Visual Studio, unload the project then right-click and select Edit.

``` xml
<PropertyGroup>
   <MyProgramFiles>c:\program files</MyProgramFiles>
</PropertyGroup>
<PropertyGroup Condition="Exists('c:\program files (x86)')">
   <MyProgramFiles>c:\program files (x86)</MyProgramFiles>
</PropertyGroup>
```

The above lines ensure that the `$(MyProgramFiles)` property is set to `c:\program files (x86)`
only if it exists on an x64 machine. Otherwise it uses the initial value of `c:\program files`.

To use the property in a build event:

<pre>
"$(MyProgramFiles)\Microsoft SDKs\Windows\v7.0A\Bin\NETFX 4.0 Tools"\sqlmetal.exe ...
</pre>
