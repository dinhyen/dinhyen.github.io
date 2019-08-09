---
layout: post
title: Modifying .config file in an MSBuild project
categories:
- technology
tags:
- hudson
- msbuild
- xmlpeek
- xmlpoke
---
We use [Hudson](http://hudson-ci.org) to deploy our web application to different environments such as QA, demo and production. We need to customize the web.config, primarily the database connection string, for each environment . Previously we had to maintain multiple copies of the web.config and copy the appropriate one for each deployment destination.  Obviously keeping around different versions of the same file is far from ideal.

As an improvement, we decide to keep a single web.config and modify the connection string on the fly during deployment.  Fortunately, MSBuild provides the tasks to do just this.  XmlPeek reads from and XmlPoke modifies the content of an XML file using XPath syntax.

The XmlPeek and XmlPoke tasks are available with MSBuild 4.0.  Unfortunately we are constrained to using MSBuild 3.5, so we had to add the following references to the MSBuild project.

``` xml
<UsingTask TaskName="Microsoft.Build.Tasks.XmlPeek" AssemblyName="Microsoft.Build.Tasks.v4.0, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"/>
<UsingTask TaskName="Microsoft.Build.Tasks.XmlPoke" AssemblyName="Microsoft.Build.Tasks.v4.0, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a"/>
```

Our connection string is stored in the typical manner in the web.config:
``` xml
<configuration>
  <connectionStrings>
    <add name="MyAppConnectionString" connectionString="Data Source=default;Initial Catalog=default;Integrated Security=SSPI;"
      providerName="System.Data.SqlClient" />
  </connectionStrings>
</configuration>
```

We pass in the new value of the connection string as a project parameter named MyConnectionString, which Hudson turns into an environment variable named `$(MyConnectionString)`.  We make it a project parameter so that it can be modified as needed by IT without help from development.  The connection string has to be URL-encoded; for example, semicolons must be replaced by `%3B` as shown below.

<img src="http://yentran.isamonkey.org/gallery/images/hudson-conn-string.png" title="hudson-conn-string" width="739" height="128" class="aligncenter size-full wp-image-1148" />

The following snippets read and replace the value of the connection string.  The XPath query returns the connection string attribute for any node which has the name attribute of MyAppConnectionString.  Note that the XML namespace must be HTML-encoded. We don't need the value of the existing connection string, but can use it for logging purpose.

``` xml
<PropertyGroup>
	<WebConfig>c:\builds\MyApp\Web.config</WebConfig>
</PropertyGroup>
  
<Target Name="ReadWebConfig">
	<XmlPeek Namespaces="&lt;Namespace Prefix='msb' Uri='http://schemas.microsoft.com/developer/msbuild/2003'/&gt;"
		XmlInputPath="$(WebConfig)"
		Query="//add[@name='MyAppConnectionString']/@connectionString">
	  <Output TaskParameter="Result" ItemName="Peeked" />
	</XmlPeek>
	<Message Text="@(Peeked)" />
</Target>

<Target Name="UpdateWebConfig"  Condition=" '$(MyAppConnectionString)' != '' ">
	<XmlPoke Namespaces="&lt;Namespace Prefix='msb' Uri='http://schemas.microsoft.com/developer/msbuild/2003'/&gt;"
		XmlInputPath="$(WebConfig)"
		Query="//add[@name='MyAppConnectionString']/@connectionString"
		Value="$(MyAppConnectionString)" />
</Target>
```
