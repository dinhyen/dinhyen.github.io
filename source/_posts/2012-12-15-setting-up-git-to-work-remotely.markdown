---
layout: post
title: Setting up Git to work remotely
categories:
- technology
tags:
- git
status: publish
type: post
published: true
meta:
  _edit_last: '1'
  _syntaxhighlighter_encoded: '1'
---
At home I use a MacBook to connect via VPN to the office. I'd have access to the intranet but not shell access to my workstation. Since I usually work on the same project at home and at the office, I need to keep my work synchronized. One way to do that is with a Git remote branch.

At the office, I'd create a local branch for the story I'd like to work on:

<pre>
git checkout master
git branch story_1
git checkout story_1
</pre>

The last 2 steps can be replaced with the shortcut:

<pre>
git checkout -b story_1
</pre>

In the local branch, create a remote branch with the same name:

<pre>
git push origin story_1
</pre>

Alternatively, I could specify a different name for the remote branch:

<pre>
git push origin story_1:cool_feature_1
</pre>

To set up the local branch (i.e., the tracking branch) to track changes in the remote branch:

<pre>
git checkout story_1
git branch -u origin/story_1
</pre>

Alternatively, I could use a more verbose syntax:

<pre>
git branch --set-upstream story_1 origin/story_1
</pre>

If there's an existing remote branch and I want to create a new tracking branch with the same name:

<pre>
git checkout --track origin/story_1
</pre>

Inside a tracking branch, Git knows which server and branch to push to and pull from, so I can simply do `git pull` instead of `git pull origin story_1`.<sup>&dagger;</sup>

Now that the remote branch is setup, I can create a tracking branch on the laptop as above.

Helpful references: [http://git-scm.com/book/en/Git-Branching-Remote-Branches](http://git-scm.com/book/en/Git-Branching-Remote-Branches)

<hr>
<sup>&dagger;</sup> The behavior of "git push" actually depends on the push.default setting in .gitconfig and whether the tracking branch has the same name as the remote branch. The git-config man page gives the following information on push.default:


> <b>push.default</b> Defines the action git push should take if no refspec is given on the command line, no refspec is configured in the remote, and no refspec is implied by any of the options given on the command line. Possible values are:

> nothing - do not push anything.

> matching - push all branches having the same name in both ends. This is for those who prepare all the branches into a publishable shape and then push them out with a single command. It is not appropriate for pushing into a repository shared by multiple users, since locally stalled branches will attempt a non-fast forward push if other users updated the branch. This is currently the default, but Git 2.0 will change the default to simple.

> upstream - push the current branch to its upstream branch. With this, git push will update the same remote ref as the one which is merged by git pull, making push and pull symmetrical. See "branch.<name>.merge" for how to configure the upstream branch.

> simple - like upstream, but refuses to push if the upstream branch's name is different from the local one. This is the safest option and is well-suited for beginners. It will become the default in Git 2.0.

> current - push the current branch to a branch of the same name.

If the tracking branch has the same name as the remote branch, `git push` will suffice.  If it has a different name and push.default is, for example, "simple", I'd have to specify the refspec: `git push origin HEAD:story_1`.