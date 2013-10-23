---
layout: post
title: Using Hudson with Git and MSBuild on Windows
categories:
- technology
tags:
- ci
- git
- hudson
- msbuild
status: publish
type: post
published: true
meta:
  aktt_notify_twitter: 'no'
  _edit_last: '1'
  _syntaxhighlighter_encoded: '1'
---
We use <a href="http://hudson-ci.org/" target="_blank">Hudson</a> as our continuous integration server (although we're thinking about moving to <a href="http://jenkins-ci.org/" target="_blank">Jenkins</a>, but that's a different story). This post describes how we set up Hudson to work with Git and MSBuild on a Windows server.

# Pre-requisites
We use the following software. The listed versions are the latest as of the time of writing, but other combinations should work.

* Java Runtime Environment (JRE) 7
* Apache Tomcat 7.0
* Hudson 2.2.1

# Apache Tomcat
Download and install the <a href="http://tomcat.apache.org/download-70.cgi" target="_blank">Tomcat 7.0 Windows Service Installer</a>. In our case, the server already runs IIS on port 80, so we install Tomcat on a different port.  Remember this port as you will need it to access the Manager and Hudson.

Since Hudson will need to perform tasks that require access to more than one servers, such as deploying to a network share, we create a domain account which would be granted the necessary permissions wherever applicable. Configure Tomcat to run under the domain account as follows:

* From the Start menu, run Configure Tomcat as Admin. Alternatively, you could open the Services console (shortcut: run Service.msc as Admin) and select Properties for the Apache Tomcat 7.0 service.
* Under the Log On tab, enter the credentials for the domain account
<img src="http://www.yentran.org/blog/wp-content/uploads/2012/11/tomcat7user.png" width="416" height="396" />
* Restart Tomcat

You can restart Tomcat by running the command prompt as Admin then type `net start tomcat7` to start or `net stop tomcat7` to stop the service.

Grant Read/Execute permission to the Tomcat account for the web application folders (e.g., webapps\manager, webapps\root) and Full Control for temp folder.

Out of the box, the Manager is not accessible out of security consideration. You'd have to specify the user who's allowed to access the page:

* Open c:\program files (x86)\Tomcat 7.0\conf\tomcat-users.xml
* Enter the credentials for the user and specify the role as "manager-gui" with the following:
`<user username="admin" password="password" roles="manager-gui"/>`


You can access the Manager at http://server:port/manager/html.

# Hudson

## Install Hudson

<a href="http://hudson-ci.org/" target="_blank">Download</a> the latest production .war.

To deploy Hudson:

* Copy .war to the Tomcat webapps folder. The name of the .war will be part of Hudson's URL, so rename hudson-2.1.2.war to hudson.war to shorten the URL. If Hudson is the only app, you can also rename the .war root.war to be able to access Hudson at the root URL.
* Grant the Tomcat account full control to the webapps folder. This is because Tomcat needs to unpack the .war into a folder. After it's deployed, you can reset the permissions for the Tomcat account back to Read &amp; Execute.
* Restart the Tomcat service if necessary.

To upgrade Hudson:

* Stop the Tomcat service
* Remove the old Hudson .war and folder from the webapps folder
* Following the procedure to deploy Hudson
* Your jobs should be saved to the .hudson folder in the user's home directory by default (e.g., c:\Users\TomcatAccount\.hudson on Windows). They should be there when you start Hudson.

To restart Hudson:

* Browse to Tomcat Manager
* Select Reload for the /hudson application

If you've named the .war hudson.war, you can access Hudson at http://server:port/hudson.

## Set up Git

Hudson needs to locate the SSH RSA key files (in the .ssh folder) to use with Git. In order to do so, you need to specify the %HOME% environment variable, if it's not set.

It's convenient to do so in Hudson:

* From the Hudson dashboard, select Manage Hudson
* Select Configure System
* Under the Global properties section, add the HOME environment variable and set it to the home directory of the Tomcat account where the .ssh folder is located.
<img src="http://www.yentran.org/blog/wp-content/uploads/2012/11/git-plugin.png" />

## Set up MSBuild
MSBuild is the Visual Studio build system. To install the MSBuild plugin, which allows you to access MSBuild:

* From the Hudson dashboard, select Manage Hudson
* Select Manage Plugins
* In the Available tab, check MSBuild and select Install

To configure the MSBuild plugin:

* From the Hudson dashboard, select Manage Hudson
* Select Configure System
* Under the MSBuild section, provide the path to the MSBuild executable similar to below.
<img src="http://www.yentran.org/blog/wp-content/uploads/2012/11/msbuild.png" />

## E-mail notification

<img src="http://www.yentran.org/blog/wp-content/uploads/2012/11/email.png" />

## Create a Hudson job

Creating a job in Hudson is pretty straight forward, with just a form to fill out and no XML to fiddle with.
### Name
<img src="http://www.yentran.org/blog/wp-content/uploads/2012/11/create.png" />
### Workspace
The custom workspace is the location where you source code will go after being pulled from version control.

<img src="http://www.yentran.org/blog/wp-content/uploads/2012/11/workspace.png" />
### Source Code Management
The URL of a Git repository is of the form gitaccount@server:gitrepository.git.

<img src="http://www.yentran.org/blog/wp-content/uploads/2012/11/git.png" />

### Build
This can be a multi-step process. You can have as many step as necessary. To add a build step, select an option from the Add build step dropdown.

In our case, we want to allow the user to select a particular Git tag to build. The list of tags is specified as Choice parameter. The selected value will be stored in an environment variable of the same name, $TAG.

<img src="http://www.yentran.org/blog/wp-content/uploads/2012/11/git-tag-param.png" />

To pull down the tag, we execute a series of step to ensure all tags are pulled down, then checkout the selected tag.

<img src="http://www.yentran.org/blog/wp-content/uploads/2012/11/git-tag-checkout.png" />

The final step uses MSBuild to run our build script.

<img src="http://www.yentran.org/blog/wp-content/uploads/2012/11/build.png" />

### Post-build

The Chuck Norris plugin gives us a thumbs up for a successful build.  If the build fails, well let's just say you don't want to make Chuck angry.

<img src="http://www.yentran.org/blog/wp-content/uploads/2012/11/post-build.png" />

## Troubleshooting
**FATAL: One of setGitDir or setWorkTree must be called**

* Try using a different workspace directory for each project
* Try deleting workspace directory

**HTTP Status 500 - java.lang.IllegalStateException: No output folder**

* Grant permission to the Tomcat account for the app you're accessing (e.g., webapps\root)

# References

<a href="http://tomcat.apache.org/tomcat-7.0-doc/manager-howto.html#Configuring_Manager_Application_Access" target="_blank">Configuring Tomcat manager</a>

<a href="http://wiki.hudson-ci.org/display/HUDSON/Tomcat" target="_blank">Install and upgrade guide for Hudson</a>
