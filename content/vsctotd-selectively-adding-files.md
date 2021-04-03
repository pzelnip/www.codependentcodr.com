Title: VS Code Tip Of The Day - Selectively Adding Files To A Git Commit
Date: 2021-04-03 10:26
Modified: 2021-04-03 10:26
Category: Posts
tags: git,vscode
cover: static/imgs/vscode.jpg
summary: Recently I figured out a way to selectively add files to a Git commit.

Small tip: sometimes when working on something I find myself making changes to many
files.  I then only want to include a few of those files in my next Git commit.  To
date I've always just manually done a `git add <file>` in the terminal for each
file I want to add, but this is tedious if there's many of them.

Turns out there's an easy way to do this in VS Code.  If you go to the Source Control
item on the left nav (the icon that looks like a branch), you’ll see a list of all
untracked and modified files.  For example:

![Showing Modified Files in the Source Control View]({static}/static/imgs/source-control-min.png)

In this screenshot you can see I have a number of files that have been modified (the
ones with the "M" beside them) and two new (untracked) files (the ones with the "U"
beside them).

If you want to see what's changed in any of the modified files, clicking the item will
bring up a diff window.  If you then want to include (or "stage") this file for the
next commit, right-click it and pick "Stage Changes":

![Selecting Stage Changes]({static}/static/imgs/stagechanges-min.png)

Repeat for each file you want to include, and then do a `git commit` to complete the
commit.  Alternatively if you're anti-terminal you can click the checkmark on this
same view to complete the commit.
