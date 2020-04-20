Title: Python manage.py pytest or Making Django Use Pytest
Date: 2020-04-18 18:51
Modified: 2020-04-19 16:54
Category: Posts
tags: python,testing,pytest,unittest,django
cover: static/imgs/default_page_imagev2.jpg
summary: How to make Django's manage.py use Pytest instead of the default test runner
status: published

Edit: For those who prefer visual content, I've recorded this as a video on Youtube
which you can find at: <https://youtu.be/toKW2YLnGFQ>

Ok, so I've had to convert some Django projects to use Pytest as the test runner
rather than the built in one that Django uses.  This is actually pretty
straightforward, and I even [recorded a Youtube
video](https://www.youtube.com/watch?v=7it7JFPInX0) showing the process.

That's all fine and good, but one of the complaints I've heard from
Django-ista's (is that a term?  Djangoites?  Django Devotees?) is that it means
now the good old normal `python manage.py test` no longer works (well, I suppose
technically it still works, but doesn't use Pytest).

So challenge accepted, as one can certainly create [custom manage.py
commands](https://docs.djangoproject.com/en/2.2/howto/custom-management-commands/)
in Django, so lets create a custom management command to run our unit tests with
Pytest instead of the default built-in runner.

## Python Manage.py pytest

So first challenge is "how do we run pytest from Python?" as normally you run
Pytest as a command line tool.  As it turns out there's [docs on how to do this
on Pytest's site](https://docs.pytest.org/en/latest/usage.html#calling-pytest-from-python-code).

The trick is to `import pytest` and then call `pytest.main()` passing in the
same command line arguments you'd give to Pytest in the terminal to that
function.  As an example:

```python
pytest.main(['--lf'])
```

Would be the same thing as doing `pytest --lf` on the command-line.  Easy peasy.
So started a basic custom management command in a file called `pytest.py` and
put it into my Django project's `management/commands` directory.

```python
import pytest
from django.core.management.base import BaseCommand


class Command(BaseCommand):
    help = "Runs tests with Pytest"

    def handle(self, *args, **options):
        pytest.main()
```

This works, in that now I can do `python manage.py pytest` and it'll run Pytest
as if I just ran the `pytest` executable in the current directory.

Cool, but how do I start passing arguments?  Normally in a custom Django
management command you define a `add_arguments` function and use the `argparse`
module to define the expected arguments for your custom command.  In this case
though, I essentially want the interface to Pytest, which would be non-trivial
to recreate by hand (there's a lot of options on that Pytest executable).

But, with argparse, there is a way to essentially say "accept any arguments",
and that's the `argparse.REMAINDER` value for the `nargs`
parameter ([docs](https://docs.python.org/3/library/argparse.html#nargs)).

> `argparse.REMAINDER`. All the remaining command-line arguments are gathered
> into a list. This is commonly useful for command line utilities that dispatch
> to other command line utilities

Perfect, that's exactly what I want.  Adding to our management command is straighforward:

```python
import argparse

import pytest
from django.core.management.base import BaseCommand


class Command(BaseCommand):
    help = "Runs tests with Pytest"

    def add_arguments(self, parser):
        parser.add_argument("args", nargs=argparse.REMAINDER)

    def handle(self, *args, **options):
        pytest.main(list(args))

```

Now whatever arguments we pass to our `manage.py pytest` command will be passed
directly through to the `pytest.main` function.  Exactly what I want, and super
concise.

## But That's Still Different

At this point it worked, but I could still hear those nagging voices saying,
"yeah but `manage.py pytest` is not the same as `manage.py test`".  Fine, as it
turns out though you can override any of the built-in manage.py commands.

The trick is to just create a custom management command with the name of the
command you want to override, and make sure your app is the last one in Django's
`INSTALLED_APPS` setting.  So in our case we could just rename our
`management/pytest.py` file to `management/test.py` and it'd work.  But I kinda
liked having both (ie both `manage.py pytest` and `manage.py test` being
effectively an alias to it).  So I created a `management/test.py` file and put
in the following:

```python
# Override the built in Django manage.py test with pytest
from djangotest.management.commands.pytest import Command
```

Yup, that's it, 1 line of code.  Now doing a `python manage.py test` runs Pytest
as the test runner.

Did this all on a test project, source is up on Github at:
<https://github.com/pzelnip/djangotest>

Or if you just want to see the management commands, they're at:
<https://github.com/pzelnip/djangotest/tree/master/djangotest/management/commands>
