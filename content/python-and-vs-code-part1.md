Title: Python and Visual Studio Code -- Getting Started
Date: 2018-06-01 20:08
Modified: 2018-06-10 20:08
Category: Posts
tags: python,vscode,editors,tools
cover: static/imgs/vscodeAndPython.png
summary: Python is an awesome programming language. VS Code is an awesome editor. With their powers combined...

I'm a pretty big fan of the [Python programming language](https://www.python.org).  It's one
of those tools that strikes that wonderful balance between simplicity & power, where the
initial learning curve isn't super steep, but as you grow with it, it grows with you.

Last fall I found another tool which falls into this category:
[Visual Studio Code](https://code.visualstudio.com).  Initially I started with VS Code as
something to replace Sublime as a plain text editor, but before long I found myself using
VS Code for doing anything related to text editing, including working in Python.  As such,
now that I've learned a few things and feel like I'm fairly proficient with VS Code for
Python development, I thought I'd write up some "getting started" posts on how to get going
writing Python with VS Code.

Of course there are a million "how to set up VS Code for Python development" blog posts
out there, so why one more?  I think one of the things about VS Code vs an IDE (such as
PyCharm or PyDev with Eclipse) is that because it's a plain text editor with so much
customization possibilities everyone sets it up a little different.  In any case, these
posts will outline "what I currently do", but is neither "the one right way" nor even
the way I'll be using VS Code 6 months from now (getting to this point has been a very
iterative evolution of how I use the tool).  As well, I'll be coming at this through a
lens of setting up VS Code for web development in a framework like Django or Flask, as
much of my professional work is in that space.

In any case, let's roll.

# Getting Started With The Python Extension

So the first (somewhat obvious) tip: make sure you have the
[official Python extension from Microsoft](https://marketplace.visualstudio.com/items?itemName=ms-python.python)
installed.  This extension provides much of the foundations & functionality you'll need.

Side note: this extension has an interesting history: it was originally authored by a fellow
named [Don Jayamanne](https://github.com/DonJayamanne) and the story goes that he did such
a great job with the extension that
[Microsoft hired him full-time](https://blogs.msdn.microsoft.com/pythonengineering/2017/11/09/don-jayamanne-joins-microsoft/)
where he now works.  Really cool story about something that was born out of open source to
solve one person's needs, having it catch on, and then leading to the author landing a great
gig as a result of it.

Microsoft has some great docs on setting up this extension, see
[here](https://code.visualstudio.com/docs/python/python-tutorial) and
[here](https://code.visualstudio.com/docs/languages/python).  They're worth reading, but
are a bit overwhelming for just getting started with Python in VS Code, so I'll try and
cover the minimal things for getting up and running.

The first setting I think you should configure is `python.venvPath`.  If like me you use
[`virtualenvwrapper`](https://virtualenvwrapper.readthedocs.io/en/latest/) to manage
your Python virtual environments, then you need to point this setting to the directory
where they're all located (typically `~/.virtualenvs`).  The next setting is
`python.pythonPath` which is the full path to the `python` executable you want to run.
Typically I set this on a per-project basis (ie in the workspace settings for a project
rather than my user settings).

After that, there's a few others I like to set, here's what I currently have in my user
(ie global) settings:

```javascript
  "python.venvPath": "~/.virtualenvs",
  "python.pythonPath": "python3",
```

Note that while I have `python.pythonPath` set here in my user settings that's just to
ensure a sensible (ie not Python 2) default as I do override this in workspace settings for
pretty much every Python project I work on.

For workspace settings, it does depend a bit on the project, but generally this is a pretty
common set of options for me:

```javascript
    "python.pythonPath": "/Users/aparkin/.virtualenvs/some_project/bin/python3",
    "python.linting.pylintArgs": [
        "--load-plugins=pylint_django"
    ],
```

Note that the `pythonPath` is a full path to the Python interpreter in my virtual
environment.  *Big gotcha*: this has to be a full path, you can't use `~` to point to
your home directory as it doesn't get expanded by the plugin.

The `pylintArgs` setting makes sure that the
[`pylint_django` extension](https://pypi.org/project/pylint-django/) is added which is
needed for having Pylint understand some of the Django-isms in projects built with that
framework.  Pylint is
by default turned on in the extension.  Note that the extension supports *many* different
Python linters, and for some projects I do turn on multiple ones, others I just use Pylint.
With this on, you get Pylint warnings and errors in the problems view in VS Code:

![VS Code problems view]({filename}/static/imgs/vsCodePythonProblems-crunch.png)

Each of those are clickable (will take you to the line in the code where the problem is,
and an analysis is applied each time the file is saved.

One gotcha I had here: previously I added the `pylint_django` setting globally, but then
when working on a project that didn't have `pylint_django` installed pylint would silently
fail (you'd see an exception in the output window of the plugin, but I rarely look there),
and I wouldn't get those nice problems in the view.  Now I just add that setting on
a per-project basis, which is a bit of a pain to set up (I have to do it on each project
that uses Django).
