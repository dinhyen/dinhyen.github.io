---
layout: post
title: ! 'Wix: Batch files.  Yes, really.'
categories:
- technology
tags:
- wix
status: publish
type: post
published: true
meta:
  _edit_last: '1'
  _syntaxhighlighter_encoded: '1'
---
Batch files are the last resort due to its Neanderthal abilities and exasperating syntax.  But if I want to run a bunch of things on bare-boned Windows Server 2003, this seems like the quickest if not only option.

I tried something like this, by creating a property for the system executable cmd.exe, which would execute the batch script via the /c switch. Then I created a custom action that relies on the property.  The batch script and its arguments must be enclosed in quotes. In addition, each argument should be enclosed in quotes in case it contains a space. 

``` xml
<Property Id="CMD">
  <DirectorySearch Id="SysDir" Path="[SystemFolder]" Depth="1">
    <FileSearch Id="CmdExe" Name="cmd.exe"  />
  </DirectorySearch>
</Property>
<CustomAction Id="BatchScript" Property="CMD" Execute="immediate" Impersonate="yes" Return="check" ExeCommand="/c &quot;&quot;[INSTALLDIR]\batch_script.cmd&quot; &quot;my arg1&quot; &quot;my arg2&quot;&quot;" />
```

Since I want to use property values (derived from user inputs) as arguments, the "beauty" of this (and I say so with a straight face) is simply the replacements of raw argument values with property references.

``` xml
<Property Id="b_arg1">my arg1</Property>
<Property Id="b_arg2">my arg2</Property>

<CustomAction Id="BatchScript" Property="CMD" Execute="immediate" Impersonate="yes" Return="check" ExeCommand="/c &quot;&quot;[B_DBINSTALLDIR]\batch_script.cmd&quot; &quot;[b_arg1]&quot; &quot;[b_arg2]&quot;&quot;" />
```

Then I hit a snag.  The batch script needs to call other batch scripts in the same directory.  With this approach, I can't set the working directory because <CustomAction> can have either a Directory attribute or a Property attribute but not both.  Here cmd.exe simply runs under the directory it defaults to, `c:\windows\system32`.

With a slight modification by including the entire command in the ExeCommand attribute, the custom action can use a working directory.

``` xml
<CustomAction Id="BatchScript" Directory='INSTALLDIR' Execute="immediate" Impersonate="yes" Return="check" ExeCommand="[SystemFolder]\cmd /c &quot;&quot;batch_script.cmd&quot; &quot;[b_arg1]&quot; &quot;[b_arg2]&quot;&quot;" />
```

Here's the initial version of the batch script.  The database is configured via sqlcmd with the arguments which are passed to the script.

<pre>
set arg1=%1
set arg2=%2
sqlcmd -E -d database_name -i "sql_script.sql" -v arg1="%arg1%" arg2="%arg2%"
</pre>

However, some of the script arguments are already enclosed in quotes, which must be there because they may contain space.  This means the sqlcmd arguments now have extra quotes. I suppose if I made sure all batch file arguments are enclosed in quotes, I wouldn't need the quotes in the sqlcmd parameters list. Nevertheless, I decide to strip the quotes before forwarding the arguments to sqlcmd.

<pre>
set arg1=%arg1:"=%
set arg2=%arg2:"=%
</pre>
