Title: Tip of the Day: Silver Searcher & VS Code
Date: 2018-04-23 10:55
Modified: 2018-04-23 17:30
Category: Posts
tags: vscode,silversearcher,editors
cover: static/imgs/default_page_imagev2.jpg
summary: Tip for opening up all files which match a string in separate VS Code tabs.

Oftentimes when working on a project you'll need to search through the codebase for
a particular string.  Maybe it's looking for occurances of a variable, maybe a particular
include statement, whatever, this "needle in a haystack" is a common thing you do.
For example, I recently had to find all references to a particular string path across
a codebase of 1000's of files to update those files.

One way to approach this is to use your editor's search and click around on search
results opening files and inspecting.  I however, like the command line, so I use
a tool called the [Silver Searcher](https://github.com/ggreer/the_silver_searcher)
for doing this.  The advantage of Silver Searcher is that it's very fast, and very
good at searching codebases.  Think of it as recursive grep on steroids.  Going
back to my problem, say I had to search for the string `/admin/login`.  With
Silver Searcher I'd do something like:

```shell
ag "\/admin\/login"
```

And this will search the current directory & all subdirectories that match that
string (note that this uses basic regex syntax for matching the slash), and display
the references inline.  In my case, all I really wanted was a list of files that
matched, which we can do with the `-l` argument:

```shell
ag "\/admin\/login" -l
```

Which instead of showing the matches, just lists the files that match the query.

Next was to open up each file in my editor of choice
([Visual Studio Code](https://code.visualstudio.com/)).  One could do this by
going to VS Code and use the Quick Open (`⌘+P` on a Mac, `Ctrl+P` on lesser
platforms) and typing the filename to open.  This however, is tedious.

One improvement is to use
[VS Code's integrated terminal](https://code.visualstudio.com/docs/editor/integrated-terminal)
If you open the terminal and do the Silver Search from there, you can then cmd+click
the matched filenames and VS Code is smart enough to open the file up in a new
editor tab.

Better, but it's still kinda tedious to click each file.

In Vim, what you'd do is run a command to generate a buffer with the output of Silver
Searcher, then use the
["Open File Under Cursor" command (`gf`)](http://vim.wikia.com/wiki/Open_file_under_cursor)
in Vim to open up the file in a new buffer.  I wonder if VS Code has something similar.

Doing some searching turned up
[this extension](https://marketplace.visualstudio.com/items?itemName=Fr43nk.seito-openfile)
which does exactly that.  If you have an editor tab open with a list of files, you can
right-click and pick "Open file under cursor" to open that file up.

Ok, so then I could do the search in the terminal, copy the result and paste into a new
editor tab, then use the Open File Under Cursor to open up each.  But that copy pasting
is again, tedious.  As it turns out though, as of
[v1.19 of VS Code](https://code.visualstudio.com/updates/v1_19#_pipe-output-directly-into-vs-code)
you can redirect
output of a command in a integrated terminal window into a new editor tab.  It looks
something like:

```shell
ag "whatever you are searching for" -l | code -
```

This will pipe the output of Silver Searcher into a new editor tab in the current VS
Code window.  Cool, getting better, though that right-clicking and opening each line
is kinda tedious still, can't we just have the results opened instead of going through
this intermediate editor window?

Yes, yes we can:

```shell
ag "whatever you are searching for" -l | xargs code -
```

This matches all files that contain `whatever you are searching for` from the current
directory down, and opens up each in a new VS Code editor tab.  The magic here is the
xargs command which if you haven't already used, stop reading this
blog post now and go [Googling](http://lmgtfy.com/?q=xargs) as it's one of the most powerful
command-line utilities you'll ever see.

Really handy tip and I find myself using it a lot.
