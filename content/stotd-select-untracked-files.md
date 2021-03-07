Title: Shell Tip Of the Day - Selecting untracked files
Date: 2018-06-01 20:34
Modified: 2018-06-01 20:34
Category: Posts
tags: bash,shell,shellTipOfTheDay,git
cover: static/imgs/logos/Gnu-bash-logo-crunch.png
summary: Shell Tip Of the Day - Selecting untracked files

Today's tip of the day is a follow up from something I learned at
[this year's Polyglot UnConference]({static}/polyglotconf-2018.md) -- how
to use ```select``` with the Bash shell for interactive goodness.

At Polyglot I saw an example that looked like this:

```bash
select x in * ; do stat $x; done
```

Try this (go to a terminal and in the bash shell type it verbatim).  Go ahead, I'll wait.

Did that?  Cool, so as you saw the ```select``` keyword is this way of interactively selecting
items from a glob with bash.  In that above example, it allowed you to ```stat``` a file you
select.

Today I found a practical application of this: interactively deleting untracked files from a
checked out Git repo.

My scenario: I was working on a future blog post and had created a handful of image files in
the current directory.  This isn't uncommon: I'll often get a single image that I want to use
for something like the
[OpenGraph](http://ogp.me/)
summary image for a post, and then I edit it via
[ImageMagick](https://www.imagemagick.org/)
to resize it, change a background to transparent, etc, and then I run it through
[Crunch](https://github.com/chrissimpkins/Crunch)
to shrink it down.

Today I found that after getting the final image I wanted, a `git status` showed a number of
untracked files I didn't care about:

```shell
$ git status
On branch codependentcodr/ch202/vscode-python-debugging-unit-tests-tasks
Untracked files:
  (use "git add <file>..." to include in what will be committed)

        content/python-and-vs-code-part1.md
        content/static/imgs/vscode141.png
        content/static/imgs/vscodeAndPython.png
        content/static/imgs/vscodelogo-crunch.png
        content/static/imgs/vscodelogo.png

nothing added to commit but untracked files present (use "git add" to track)
```

The only file I wanted from `content/static/imgs` was `vscodeAndPython.png`, all the other stuff in
`content/static/imgs` was junk that could be deleted.  I could manually delete
each one, typing the full filename each time, or I could save some keystrokes by
using `select` and a little command-line fu:

```bash
select x in git status --porcelain | tr -d \?\?; do rm $x ; done
```

Explanation: `git status --porcelain` just spits out the filenames from a `git status`
(no header/footer, extra stuff), and `tr -d \?\?` removes the leading `??` that's
prepended to any filename that is untracked.  The `select` iterates over each file
matched by this command in an interactive way, and then the `do rm $x` removes whatever
file I select.  This allowed me to interactively delete files that were untracked:

```shell
$ select x in `git status --porcelain | tr -d \?\?`; do rm $x ; done
1) content/python-and-vs-code-part1.md        4) content/static/imgs/vscodelogo-crunch.png
2) content/static/imgs/vscode141.png          5) content/static/imgs/vscodelogo.png
3) content/static/imgs/vscodeAndPython.png
#? 2
#? 4
#? 5
$ git status
On branch codependentcodr/ch202/vscode-python-debugging-unit-tests-tasks
Untracked files:
  (use "git add <file>..." to include in what will be committed)

        content/python-and-vs-code-part1.md
        content/static/imgs/vscodeAndPython.png

nothing added to commit but untracked files present (use "git add" to track)
```

I thought this was pretty cool, next time you find yourself wanting to choose from
a number of files on the command line, think about
[`select`](http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_09_06.html). 😄

Ok: I realize I could've just added the md file & the image I wanted to git and then
deleted all untracked files, but would that have been as interesting as this blog
post?  I think not.
