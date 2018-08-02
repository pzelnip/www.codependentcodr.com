Title: Code Quality Challenge #1 - Test Coverage
Date: 2018-08-01 08:10
Modified: 2018-08-01 08:10
Category: Posts
tags: testing,coverage,cqc,quality
cover: static/imgs/default_page_imagev2.jpg
summary: CQC #1 - Exploring Test Coverage

## The Challenge

Today's challenge is to explore the use of test coverage tools to see if you can find
any shortcomings or holes in your test suite.

You (hopefully) have some unit tests in place on your project.  But do you have
enough tests?  Are there still critical parts of your code that are untested by
an automated test?  How would you know?

If you use Python, the de-facto tool for answering this question is
[Coverage.py](https://coverage.readthedocs.io/en/coverage-4.5.1a/).  And if you're
using [Pytest](https://pytest.org/) to run your tests, then generating a coverage
report is trivial:

```shell
pytest /path/to/your/tests --cov=nameofyourproject --cov-report html:/path/to/where/to/put/the/report
```

This will generate a HTML-based test coverage report which will show you what parts
of your code are and are not covered by your test suite.

So spend 20 minutes today and see if you can bump up your test coverage just a little.
Remember the goal isn't 100%, the goal is to just make an improvement to either how
much coverage you have, or give some insight into how much test coverage you have.

20 minutes, go!

## What I did

On my project at work we already had coverage set up to run as part of our CI pipeline.
The tool itself is run inside a Docker container, the HTML report produced, and then
archived as a build artifact that you can then examine on the build page for a particular
build.

I used this mechanism to see what code was not yet tested.  As it turned out we had
a bunch of code that made use of Python Abstract Base Classes (ABC's) and had some
abstract properties.  The gist:

```python

class Foo(ABC):
    @property
    @abstractmethod
    def someproperty(self):
        pass
```

The problem is that the `pass` statements were being counted by Coverage, even
though by definition those lines cannot be hit by a test (the whole point of an
abstract method is that it can't be called, but rather has to be overridden by a
child class).

The solution, add docstrings:

```python

class Foo(ABC):
    @property
    @abstractmethod
    def someproperty(self):
        """Returns the .....meaningful description here...."""
```

Because a docstring is a valid method body, this works as valid Python code. And
coverage doesn't see a pass statement, so no count towards coverage.  Lastly as
a nice side benefit, now I'm better adhering to Python style guidelines which
generally suggest public methods/properties should have docstrings (tools like
[Pylint](https://www.pylint.org) and
[Pydocstyle](https://github.com/PyCQA/pydocstyle) will actually flag public
methods without docstrings as warnings).  Win win.

Doing this resulted in test coverage increasing around 1%.

## What About You

Did you try the challenge?  How'd it go?  Would love to hear any feedback, comments, or
observations.  And if you have ideas for future challenges, please feel free to suggest
them!
