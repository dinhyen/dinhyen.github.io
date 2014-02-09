---
layout: post
title: "My Git cheat sheet"
date: 2014-02-07 16:02
comments: true
categories:
- technology
---
There are lots of great Git guides out there.  This is intended simply to be a reference for me during those dark times when I can't remember the syntax for creating a tracking branch.


### Config

```
# These will show up in git log
git config --global user.name "Yen Tran"
git config --global user.email yen@yentran.org
git config --list
```

### Info

```
gitk
git status
git log
git log origin/master
# Show endpoints such as origin
git remote show
# Show origin params
git remote show origin
```

###  Branch (Local)

```
git branch <branch> <sha1_of_commit>
# Ex: git branch foo 7e2785d
```

```
# Delete branch
git branch -d <branch>

# Create branch:
git branch <branch>
git checkout <branch>
# Check out and automatically creates branch
git checkout -b <branch>
# List local branches
git br 
# List remote branches
git branch -r
# List all branches
git branch -a
# Verbose list of local branches and HEAD commit
git branch -v
```

###  Check out a previous check-in

```
git log
#  Locate desired checkin and copy SHA; e.g., f2bc540fc6817b0409571f6e5a562dffa6396017
git checkout <SHA>
# Do stuff, publish, etc.
git checkout master
```

###  Cherry-pick

```
# Source branch
git co 2012-01-01-A
# Get top log entry
git log -1
# Copy first few characters of SHA hash
# Destination branch
git co master
git cherry-pick 96f39d92de93
# Review changes
git diff HEAD~1
```

###  Clone

```
# SSH keys under ~/.ssh
git clone git@donny:repo.git
# Directory is optional; automatically created if not specified
git clone gitolite@donny:repo.git [directory]
```

###  Commit

```
# Also automatically stage and commit
git commit -a -m "commit message here"
# Add to previous commit or Rename a commit message
git commit --amend
# Select reword for the desired commit in the interactive editor
# Edit the message
# Save
git rebase -i master
```

###  Create new repo

```
git init
#  So that subsequent add can ignore files
git add .gitignore
git remote add origin git@donny:repo.git
git remote add origin git@github.com:user/repo.git
# add and commit files (-u option updates local)
git push -u origin master
```

###  Diff

```
# Graphical version
git difftool
git diff <directory>
git difftool HEAD~1
# Diff files that have been staged
git diff --cached
# Diff local changes against repository
git diff origin/master
```

###  Help

```
man git-log
man git-show
# etc.
```

###  Log

```
# Get top 1 log entry
git log -1
# Show history beyond renames
git log --follow file
# Include diffs
git log -p file
```

###  Stage

```
git add <file>...
git add .
# Opposite of add; use when files are renamed, etc.
git rm <file>...
```

###  Stash

```
git stash
git stash list
# Show changes in stash, where 0 is the number of the stashed item as shown by git stash list
git show @{0}
# Drop specified stash where xx is number shown in stash list
git stash drop stash@{xx}
```

###  Drop local changes

```
# Change state of working copy to match repository, if file has not been added to index/staging
git checkout -- <filename>
# Ditto, but if file has been added to index
git reset <filename>
git stash save --keep-index
```

###  Pull

```
git pull origin master
git checkout master
```

###  Rebase: resolve conflict

```
git checkout <branch>
git rebase master
git status
git add <file>
# Fix conflicts
git rebase --continue
```

###  Rebase: interactive

```
git rebase -i origin/master
git rebase -i
# In the text editor, select s or squash on the bottom-most commits to squash them
```

###  Refs

You may get this error when running "git branch -d foo":
warning: deleting branch 'foo' that has been merged to
       'refs/remotes/origin/foo', but not yet merged to HEAD.
Deleted branch foo (was 334730a).
From http://stackoverflow.com/questions/18506456/git-how-to-delete-a-local-ref-branch:
```
# Remove local ref
git update-ref -d refs/remotes/origins/foo
```

###  Ref log

```
git reflog
```

###  Remote

```
# Remove origin
git remote rm origin
git remote add origin git@donny:etagout.git
git remote show origin
```

###  Remote Branch

```
# Create branch. Reference: http://git-scm.com/book/en/Git-Branching-Remote-Branches
git branch <branch>
# Show local branches configured for push/pull, i.e. tracking branches
git remote show origin
git push <remote> <branch>
# Ex: git push origin foo
# or
git push <remote> <local_branch>:<branch>
# Ex: git push origin foo:bar
```

###  Tracking branch

#### Creating a new tracking branch

```
git checkout -b <local_branch> <remote>/<branch> 
# Ex:
#   git checkout -b foo origin/foo
#   git checkout -b bar origin/foo # local branch has a different name
# Alternative:
git checkout --track origin/foo
# Local branch has a different name
git checkout -b bar --track origin/foo
# Within a tracking branch, push and pull automatically knows which server and branch to push to/pull from
git pull
git push
```

#### Setting up tracking information for an existing branch

```
git branch --set-upstream <remote>/<branch> <local_branch>
# or
git branch -u <remote>/<branch> <local_branch>
# Ex:
# git branch -u origin/foo # when within branch foo
# git branch -u origin/foo foo # when not within branch foo
# Pull branch
git pull <remote> <branch>
# Delete branch
git push <remote> :<branch>
```

#### Pruning stale remote branches
```
git remote show origin
    master    tracked
    refs/remotes/origin/fix        stale (use 'git remote prune' to remove)
    refs/remotes/origin/story_5008 stale (use 'git remote prune' to remove)
# Simulate deleting stale branches
git remote prune origin --dry-run
# Actually delete stale branches
git remote prune origin
```

###  Commit

```
# Switch to my branch
git checkout <branch>
git status
# View diff per file
git difftool
# Add all files in to staging area
git add .
git status
# Commit to local repository
git commit
# Switch to master
git checkout master
# Pull down master updates
git pull origin master
git checkout <branch>
# Rewind my branch, pull down master updates, then add my update on top
git rebase master
git checkout master
# Merge my update back to local master
git merge <branch>
# Pull down updates that occurred on canonical repository in the meantime
git pull origin master
# Push local updates to canonical repository
git push origin master
git log
```

### Reset

```
# Changes after specified revision show up as uncommitted
git reset SHA
# Changes after specified revision do not show up
git reset SHA
# Unstage
git reset HEAD <file>
# Jump to 1 commit below HEAD, rolling back previous commit
git reset HEAD~1
# Reset everything to HEAD, overwriting local changes...caution!
git reset --hard HEAD
```

### Show

```
# View diff
git show SHA
# View content of file
git show SHA:file
```

### Filing away local changes

Create a new branch and commit the desired changes to it:

```
git branch <branch>
git checkout <branch>
git add <files>...
git commit
```

Merging origin changes with local changes:

```
git checkout <branch>
git add <file>
git commit
git checkout master
git pull origin master
git checkout <branch>
git rebase master
# Resolve conflicts
git rebase --continue
# Roll back your commit
git reset HEAD~1
```

Better:

```
git checkout <branch>
git stash
git checkout master
git pull origin master
git checkout <branch>
git rebase master
git stash pop
```

### Merging multiple branches
<pre>
Branch 2
|
Branch 1 (committed)
|
master
</pre>

```
git commit
git checkout branch1
git merge branch2
# Pick one commit and stash the other, then edit aggregate comment for both commits from the previous branch1 and branch2 comments
git rebase -i master
git co master
# Merge aggregate commits into master
git merge branch1
# Should see aggregate comment
git log
```
 
### Tag

```
# Check out a tag
git checkout 2011-09-16
# Make sure your local master contains EXACTLY what you want tagged -- "git log" to double check
git checkout master
# Create a tag
git tag -a "tag name"
# This removes the tag from your local master
git tag -d "tag name"
# DANGER - the colon tells git to DELETE something -- without a confirm prompt ! -- here, we're deleting the remote master's tag
git push origin :"tag name"
# This creates the tag on your local master
git tag "tag name"
# This pushes the new tag back onto remote master
git push --tags
# List tags
git tag
# Fetch all tags
git fetch --tags
```