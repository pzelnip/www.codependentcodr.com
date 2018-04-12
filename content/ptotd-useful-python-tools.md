Title: Useful Python Tools
Date: 2012-05-18 16:23
tags: ptotd,pythonTipOfTheDay,python,nose,metrics,quality
cover: static/imgs/python-logo-inkscape.svg

I often stumble across and use a number of useful tools for creating Python code.  Thought I'd barf out a blog post
documenting a few of them so that my future self will be able to find this info again if need be. :)

# coverage.py

(<http://nedbatchelder.com/code/coverage/>)

Coverage.py is a Python code coverage tool and is useful for finding out how well your unit tests cover your code.
I've often had it find big deficiencies in my unit test coverage.  Common usage:

```shell
coverage run somemodule_test.py
coverage report -m
```

Will spit out a coverage report for the tests in `somemodule_test.py`.  Used in this way, `coverage.py` isn't particularly
handy, but combined with a good unit test runner (see below) it becomes very handy.

# Nose

(<http://readthedocs.org/docs/nose/en/latest/>)

Is nicer testing for Python.  Nose is an extremely handy unittest runner that has some perks over the standard Python
`unittest` module.  Continuing from the last tool, nose also integrates very nicely with `coverage.py`.  I commonly use
it to produce some nice HTML pages summarzing test coverage for my project:

```shell
nosetests --with-coverage --cover-inclusive --cover-html --cover-erase
```

produces a "cover" directory containing an index.html with some nice pretty HTML reports telling me how well my unit
tests cover my codebase.

# pymetrics

(<http://sourceforge.net/projects/pymetrics/>)

`pymetrics` is a handy tool for spitting out some well, metrics, about your code.  Ex:

```shell
pymetrics somemodule.py
```

Spits out a bunch of numbers about `somemodule.py` including trivial things like how many methods have docstrings, to
more interesting things like the McCabe [cyclomatic complexity](http://en.wikipedia.org/wiki/Cyclomatic_complexity) of
each method/function within the module.  Handy.

# cloc

(<http://cloc.sourceforge.net/>)

Is a simple "lines of code" counter that happens to support Python.  In the top directory of a project a:

```shell
cloc .
```

will give you summary output for your project like:

```pre
-------------------------------------------------------------
Language  files          blank       comment           code
-------------------------------------------------------------
Python       31           3454          9215          14775
-------------------------------------------------------------
SUM:         31           3454          9215          14775
-------------------------------------------------------------
```

While LOC is generally a meaningless statistic, it can be handy for getting a "ballpark" idea of how big a project is.

(Note: this post originally appeared on my blogspot blog at: <http://codependentcodr.blogspot.ca/2012/05/useful-python-tools.html>)
