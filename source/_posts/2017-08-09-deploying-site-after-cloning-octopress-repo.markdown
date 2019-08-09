---
layout: post
title: "Deploying site after cloning Octopress repo"
comments: true
categories:
- technology
---
Octopress instructions are for setting up a new repo; i.e. by running `rake setup_github_pages`.  It doesn’t work if you’ve cloned an existing repo.

You have to manually set up a git repository in the `_deploy` directory which should track the master branch of the repo on GitHub.

```
# create new deploy dir
rm -rf _deploy
mkdir _deploy
cd _deploy
# initialize empty git repo
git init
git remote add origin git@github.com:your_login/your_repo.github.io.git
# make origin default remote
git config branch.master.remote origin
# track the master branch
git checkout --track origin/master
# pull contents
git pull
# view logs (should show automatically generated commit messages "Site updated at 2017-09-28 etc.")
git log

# Generate content (into the public dir)
rake generate
# Deploy generated content (copying from public dir into deploy dir then commit)
rake deploy
```