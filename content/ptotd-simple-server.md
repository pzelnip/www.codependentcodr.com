Title: Python Tip of the Day - Simple HTTP Server
Date: 2018-04-17 12:46
Modified: 2018-04-17 12:46
Category: Posts
tags: ptotd,pythonTipOfTheDay
cover: static/imgs/python-logo-master-v3-TM.png
summary: Using Python's Simple HTTP Server for fun and profit (and quickly sharing files)

This is kind of an old tip, but back in the days of Python 2 (aka
[Legacy Python](https://pythonbytes.fm/episodes/show/5/legacy-python-vs-python-and-why-words-matter-and-request-s-5-whys-retrospective))
a quick tip for sharing a folder of files was to use the built in
[SimpleHTTPServer module](https://docs.python.org/2/library/simplehttpserver.html)
to quickly host a bunch of files:

```shell
python -m SimpleHTTPServer
```

which spins up a basic http server on port 8000 that by default shows all the files in the directory from
where it is run.  This is a very quick and handy way for sharing files with a coworker as (so long as they
know and can reach your IP address), you just fire up this server, then they can grab files, then you turf
the server.

Python 3 unfortunately (or fortunately, I dunno) renamed the module, leading to moments of confusion (ie
"why doesn't that command not work anymore now that I'm in a virtual environment with Python 3?").  The
equivalent in Python3 is:

```shell
python -m http.server
```

But y'know what, I don't want to have to think about which version of Python I'm running, I just want a
simple command to fire up the server and have it figure out which module to run.  Hence this
[StackOverflow answer]( https://stackoverflow.com/a/46595749/808804), which indicates you can add this
to your `.bashrc` file (or equivalent for your shell):

```shell
alias serve="python -m $(python -c 'import sys; print("http.server" if sys.version_info[:2] > (2,7) else "SimpleHTTPServer")')"
```

Now from any directory a simple `serve` will start up the appropriate simple http server.
