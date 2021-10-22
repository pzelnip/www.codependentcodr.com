Title: Python Tip of the Day - contextlib.contextmanager
Date: 2021-10-21 19:52
Modified: 2021-10-21 19:52
Category: Posts
tags: python,pythonTipOfTheDay,contextmanager,testing
cover: static/imgs/python-logo-master-v3-TM.png
summary: How to use contextlib.contextmanager to combine context managers into one
status: published

So recently at work I had a test that did a fair bit of patching out of some
dependent functions/classes.  The test looked something like:

```python
from unittest.mock import patch

def test_patching_a_lot():
    with patch("path.to.module.somefunction"
    ), patch("path.to.another.function"), patch(
        "some.third.party.function"
    ), patch("you.get.the.idea"), patch(
        "perhaps.there.shouldnt.be.so.much.patching"
    ), patch(
        "but.thats.a.topic.for.another.time"
    ):
        ... tbe body of the test ...
```

You might say "holy cow Adam, six patch calls is an awful lot", but that's a topic
for another time.  I was stuck with this test as written.  The thing is though,
I looked further on in the same test module and found another test with the
exact same set of patch calls.  And I discovered both of these tests because I
was about to have to add another test for the functionality I was adding, which would
also have to do the same set of patching.

Ok, Software Engineering 101, the DRY (or "Don't Repeat Yourself" principle): if
you have the same set of lines repeated many (usually 3 or more) times, it's
time to factor those lines out to a function so that if those lines need to
change, you only make the change in one place, not many.  But the problem here
is that these are context managers, so if I factored them out to a function,
then the patching wouldn't be in effect in the test.  Example:

```python
from unittest.mock import patch

def helper():
    with patch("path.to.module.somefunction"
    ), patch("path.to.another.function"), patch(
        "some.third.party.function"
    ), patch("you.get.the.idea"), patch(
        "perhaps.there.shouldnt.be.so.much.patching"
    ), patch(
        "but.thats.a.topic.for.another.time"
    ):
        return

def test_patching_a_lot():
    helper()
    ... tbe body of the test, but at this point, the context managers are no longer in effect ...
```

And that's where
[`contextlib.contextmanager` from the standard library](https://docs.python.org/3/library/contextlib.html#contextlib.contextmanager)
comes to the rescue.  With this
gem from the standard library, you can decorate a function with the `@contextmanager` decorator,
and that function is now a context manager that you can use in a `with` clause:

```python
from contextlib import contextmanager
from unittest.mock import patch

@contextmanager
def helper():
    with patch("path.to.module.somefunction"
    ), patch("path.to.another.function"), patch(
        "some.third.party.function"
    ), patch("you.get.the.idea"), patch(
        "perhaps.there.shouldnt.be.so.much.patching"
    ), patch(
        "but.thats.a.topic.for.another.time"
    ):
        yield

def test_patching_a_lot():
    with helper():
        ... tbe body of the test, and all context managers in helper are in effect ...
```

Super handy, and very concise.  With this I was able to factor out all that
gross patching to a single function.
