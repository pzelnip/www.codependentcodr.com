Title: Git Image Diff with iTerm2
Date: 2021-02-14 12:37
Modified: 2021-02-14 12:37
Category: Posts
tags: iterm,iterm2,git,terminal,shell
cover: static/imgs/default_page_imagev2.jpg
summary: iTerm has a imgcat function. Lets use it with Git for image diffing

So iTerm2 has this neat `imgcat` command that allows you to "cat" or
view an image right in the terminal.  It's pretty sweet, but I had an
idea: what if we used that with Git for diffing changed images in a
`git diff`?

This seems like it should be possible, you can replace what git does
when you do a diff of two different binary files.  For example, the
[spaceman-diff package by Zach Holman](https://zachholman.com/posts/command-line-image-diffs/)
does this to do a diff of two images as ascii art.

We want to do the same, but instead of seeing an ASCII art version
of an image, it'd be cool to see the two versions of the image itself
right in the terminal.

## Setting Git Attributes

The first thing is create a file in your home directory called
`~/.config/git/attributes`.  In here you can define a mapping between file types
and what command Git will run when doing a diff of those filetypes.  In my case
I entered the following:

```config
*.png  diff=image
*.jpg  diff=image
*.gif  diff=image
*.jpeg diff=image
```

This tells git that when doing a diff of a file that ends with `png`, `jpg`,
`gif`, or `jpeg` to use the `image` config.

## Set Up The Image Config

Now, in your `~/.gitconfig` file, add the following:

```ini
[diff "image"]
    textconv = imgcat
```

This tells Git to use iTerm's `imgcat` script for converting the binary image
file to text.  This seems weird, but this is actually how iTerms imcat command
works: it converts the binary image into a textual stream that iTerm knows how
to understand and then render as an actual image.

## Put imgcat In Your Path

Next is put iTerm's `imcat` script somewhere on your path.  You can download it
from [here](https://iterm2.com/utilities/imgcat).  Save that somewhere, make sure
you chmod it to be executable (`chmod +x imgcat`), and then throw it into some
directory on your path.  You can confirm it's there by typing `imgcat` into an
iTerm window:

```shell
$ imgcat
Usage: imgcat [-p] filename ...
   or: cat filename | imgcat
```

Note that you have to put this script in your path, you can't just rely on the
version that's inlined into your terminal with iTerm's shell integration.

## Profit

Now when you change an image in a Git repo and do a `git diff` while in iTerm
you'll see a preview of the original image and the changed image.  Example:

![Showing the image diffing]({static}/static/imgs/imgcatDiff.png)

The above image is the original, the 2nd image is what I changed it to.  Note
that because imgcat is iTerm specific, it won't work in other terminals.  If
you do a `git diff` in a different terminal (ex: the integrated terminal in
VS Code) you'll see just the ordinary blank output:

![Image diff in non-iTerm terminal]({static}/static/imgs/imgcatdiffvscode.png)
