Title: Py.test Basics
Date: 2018-04-27 18:51
Modified: 2018-04-28 12:51
Category: Posts
tags: python,testing,pytest,unittest
cover: static/imgs/default_page_imagev2.jpg
summary: Learning some of the basics of Py.test
status: published

So I'm fortunate enough to work for an employer who grants me access to
[Safari Books Online](https://www.safaribooksonline.com/). The other
day I was browsing the site to discover that they now have not only just
books, but also online courses/webinars on a variety of topics.

I stumbled across
[this one](https://www.safaribooksonline.com/live-training/courses/getting-started-with-pythons-pytest/0636920166832/)
on Py.test which is a tool that is increasingly gaining traction in the
world of Python unit-testing, a world which I'm very much interested in.
As such, took the plunge and did the webinar, and thought I'd recap some
of the neat Py.test things that were new to me.  **Disclaimer**: with
the exception of a brief intro a colleague gave me at a previous job,
I've had no experience with Py.test so this is all going to be pretty
basic stuff.

# Running tests

Initially I first heard of Py.test as an alternative test runner.  The built
in `unittest` module can be used for running your unit tests, but many people
(myself included) will use [`nose`](http://nose.readthedocs.io/en/latest/)
as a tool for running their tests.  For example, you might do something like
the following to run your tests:

```shell
$ nosetests
..................................
----------------------------------------------------------------------
Ran 34 tests in 1.440s

OK
```

With Py.test you'd do something like (from within the project's directory):

```shell
$ PYTHONPATH=. pytest
========================================================================== test session starts ===========================================================================
platform darwin -- Python 3.6.2, pytest-3.5.1, py-1.5.3, pluggy-0.6.0
rootdir: /Users/aparkin/temp/sandbox/pytestcourse/block, inifile:
collected 3 items

test_block/test_block.py ...                                                                                                                                       [100%]

======================================================================== 3 passed in 0.02 seconds ========================================================================
```

The output's quite different, but not in a bad way.

# Tests as Functions

The first thing that'll jump out at you about Py.test is that it's encouraged
to write your tests as functions, rather than methods in a class.  In the base
`unittest` module in Python it follows the typical xUnit style pattern of test
organization: you create a class which inherits from some base class
(`unittest.TestCase` in Python's `unittest` module), and then each individual
unit test is a method on that class.  So if you had a class `Dog` you might
write a test class like the following:

```python
class TestDog(unittest.TestCase):
    def test_speak(self):
        dog = Dog()
        result = dog.speak()
        self.assertEqual("bark!", result)
```

Certainly you can still write tests like this with Py.test (ie all old tests
you have will still work just fine with Py.test), but instead you're encouraged
to write your tests as standalone functions.  So the above might look like:

```python
def test_dog_speak():
    dog = Dog()
    result = dog.speak()
    assert "bark!" == result
```

Note as well another key difference: the use of Python's built-in `assert`
statement rather than using the ```assert*()``` methods defined in
`unittest.TestCase` since we're no longer inheriting from that class.

## Sidebar: The assert Gotcha

The assert statement gotcha: in Python the assert statement is a statement,
not a function, so this can trip people up when they pass a second argument
to it.  For example:

```python
assert somecondition, "This gets printed out"
```

will print "This gets printed out" if somecondition is `false`, but
this is not the same as:

```python
assert(somecondition, "This gets printed out")
```

which always evaluates to true because it's treated as passing a 2-value
tuple to the assert statement, and a non-empty tuple is truthy in Python.
This is a *classic* Python gotcha.  Py.test adds some smarts around this, if
we had a test like:

```python
def test_assert_with_tuple():
    assert (False == True, "Should be false")
```

Then we'd get output like:

```shell
========================================================================== test session starts ===========================================================================
platform darwin -- Python 3.6.2, pytest-3.5.1, py-1.5.3, pluggy-0.6.0
rootdir: /Users/aparkin/temp/sandbox/pytestcourse/Integer, inifile:
collected 15 items

test/test_integr.py .............                                                                                                                               [100%]

============================================================================ warnings summary ============================================================================
test/test_integr.py:119
  assertion is always true, perhaps remove parentheses?

-- Docs: http://doc.pytest.org/en/latest/warnings.html
================================================================== 12 passed, 1 warnings in 0.11 seconds =================================================================
```

Note how Py.test warns us that we might be doing something dumb.

# Testing Raised Exceptions

A common thing to do in unit tests is test if a particular exception is
raised under certain circumstances.  You can certainly do this in vanilla
`unittest`:

```python
class TestFoo(unittest.TestCase):
    def test_foo_throws_value_error_when_given_negative_number(self):
        # test will only pass if foo() raises ValueError
        with self.assertRaises(ValueError):
            foo(-1)
```

But again since we're no longer inheriting from `unittest.TestCase` how do
we do this with Py.test?  There's a couple ways, one is still with a context
manager:

```python
import pytest

def test_foo_throws_value_error_when_given_negative_number():
    # test will only pass if foo() raises ValueError
    with pytest.raises(ValueError):
        foo(-1)
```

Another is to "mark" the test as an expected failure:

```python
@pytest.mark.xfail(raises=ValueError)
def test_foo_throws_value_error_when_given_negative_number():
    foo(-1)
```

The latter is slighly different, and this is reported in the test results as you'll
see output like:

```shell
========================================================================== test session starts ===========================================================================
platform darwin -- Python 3.6.2, pytest-3.5.1, py-1.5.3, pluggy-0.6.0
rootdir: /Users/aparkin/temp/sandbox/pytestcourse/Integer, inifile:
collected 15 items

test/test_integr.py ..x............                                                                                                                                [100%]

============================================================ 12 passed, 1 skipped, 1 xfailed in 0.12 seconds =============================================================
```

Note that `1 xfailed` bit, indicating that there was a single test with an "expected"
failure.  This is effectively coding a way in which the SUT fails, but in an expected
way.
[The docs](https://docs.pytest.org/en/latest/assert.html#assertions-about-expected-exceptions)
suggest that:

> Using pytest.raises is likely to be better for cases where you are testing exceptions your own
> code is deliberately raising, whereas using @pytest.mark.xfail with a check function is probably
> better for something like documenting unfixed bugs (where the test describes what “should”
> happen) or bugs in dependencies.

I could see this being useful for a test that's currently failing in a way you
expect, you could comment the test out (but then you might as well delete it) or
you could codify that you expect it to fail.  The `raises:ValueError)` restricts
the way you expect it to fail (for example if you expect it to throw a ValueError,
and it throws a RuntimeError then that's not expected and should cause a test run
failure).

# Forcing a Failure

You can also force a test to fail:

```python
def test_force_failure():
    # This test will always fail
    pytest.fail("this will fail")
```

This is effectively the same thing as adding ```self.assertEqual(True, False)```
in a vanilla Python unit test.  I'm not sure where this would be useful, the instructor
gave this example:

```python
def test_import_error():
    try:
        import somethirdpartylibrary
    except ImportError:
        pytest.fail("No module named somethirdpartylibrary to import")
```

But I fail to see the benefit of this.  If the import was missing, you'll still get
test failures (in fact, presumably any test that needs `somethirdpartylibrary` will
still blow up even with this test in place).

# Approximations

Sometimes you want to test a floating point number for a particular value in a test,
but because floating point values in any programming language are not precise, you
effectively have to create a "tolerable range" to test against.  For example in plain
Python `unitest` you might do something like:

```python
self.assertAlmostEqual(some_value, some_other_value, delta=0.001)
```

which would pass if `some_value` and `some_other_value` are within +/- `0.001` of
each other.  With Py.test you can do the following:

```python
def test_approx_same():
    expected = 0.3
    result = 0.1 + 0.2
    assert pytest.approx(expected) == result
```

There's a bunch of flexibility around how to use `approx` and it works with more
than just floating point numbers.
[The docs](https://docs.pytest.org/en/latest/reference.html#pytest-approx) are quite good.

# Marking Tests & Selective Test Execution

Oftentimes you want to group tests into various categories.  For example you might want
to separate unit tests from integration tests, or fast-running tests from slow-running
tests, etc.  Doing this in vanila `unittest` is kinda cumbersome, but with Py.test it's
easy:

```python
@pytest.mark.long
def test_this_takes_long():
    print("this is taking a long time....")
    import time ; time.sleep(10)
    assert True == True

@pytest.mark.fast
def test_this_is_fast():
    assert True == True
```

With tests like this you can run just the fast tests:

```shell
pytest -m fast
```

or just the slow tests:

```shell
pytest -m slow
```

Or even do some simple boolean logic, like for example anything that's not in the slow
category:

```shell
pytest -m "not slow"
```

Really handy stuff.

You can also do fuzzy matching of tests by name, for example to run all the tests with
the word "bad" in them:

```shell
pytest -k bad
```

This will collect & run tests with the word `bad` in the name (ex: `test_bad()`,
`test_that_the_bad_stuff_doesnt_happen()`, etc).  Really useful for when you just want
to quickly run one or two specific tests.

# Conditionally Skipping Tests

You can also conditionally skip tests:

```python
@pytest.mark.skipif(
    sys.version_info < (3,6),
    reason="Requires Python 3.6"
)
def test_that_requires_python_3_6_because_f_strings():
    result = function_that_uses_f_strings()
    assert "some expected value" == result
```

Since the block in the `skipif` is arbitrary Python code, you could use this for something
like running tests only if a particular environment variable is set, etc.

# Parameterized Tests

This is where we really start to see some cool stuff.  If you've ever written unit tests
in jUnit you'll have probably at some point come across
[parameterized tests](https://github.com/junit-team/junit4/wiki/parameterized-tests)
which is a really useful technique for reducing test boilerplate by separating test
definition from test input data.  Let's say we had a method `add()` that adds two numbers
together & returns the result (I know it's a boring example, but it really illustrates
the technique).  You might write two tests for this function to test two positive numbers
and two negative numbers:

```python
class TestAdd(unittest.TestCase):
    def test_add_positive(self):
        expected = 4
        result = add(1, 3)
        self.assertEqual(expected, result)

    def test_add_negative(self):
        expected = -4
        result = add(-1, -3)
        self.assertEqual(expected, result)
```

Note that these two tests are identical save the expected and input values.  Imagine if
you could somehow make those parameters to a test, then you might do something like:

```python
def test_add(x, y, expected_result):
    result = add(x, y)
    assert expected_result == result
```

The question then becomes how do we specify those input values.  In Python 3.4 they added
something like this with `subTest`
([docs](https://docs.python.org/3/library/unittest.html#distinguishing-test-iterations-using-subtests)):

```python

def test_add(self):
    values_to_test = [
        (1, 3, 4),
        (-1, -3, -4),
    ]
    for test_vals in values_to_test:
        with self.subTest(test_vals=test_vals):
            x,y,expected_result = test_vals
            result = add(x,y)
            self.assertEqual(expected_result, result)
```

But this is super clunky, the test data is within the test, obfuscating the meaning
of the actual test.  You also have to manually unpack everything, and when we run it,
it ends up looking like a single test instead of two (so if one fails it's harder to
figure out which one of the two tuples in `values_to_test` caused the failure).

Instead, with Py.test you can use the `parametrize` mark:

```python
@pytest.mark.parametrize('x, y, expected_result', [
    (1, 3, 4),
    (-1, -3, -4),
])
def test_add(x, y, expected_result):
    result = add(x, y)
    assert expected_result == result
```

This is *much* cleaner, the test meaning is extremely clear, and if we use the `-v` flag
when running the tests we can see that this produces two distinct tests for the two cases:

```shell
========================================================================== test session starts ===========================================================================
platform darwin -- Python 3.6.2, pytest-3.5.1, py-1.5.3, pluggy-0.6.0 -- /Users/aparkin/.virtualenvs/pytestcourse/bin/python3.6
cachedir: .pytest_cache
rootdir: /Users/aparkin/temp/sandbox/pytestcourse/Integer, inifile:
collected 2 items

test/test_integr.py::test_add[1-3-4] PASSED                                                                                                                        [ 50%]
test/test_integr.py::test_add[-1--3--4] PASSED                                                                                                                     [100%]

======================================================================== 2 passed in 0.02 seconds ========================================================================
```

Also note that the input itself for the test is in the test identifier (ie the `[1-3-4]`
for the test which added 1 & 3 to get 4, etc).

Now adding additional test cases is a simple matter of adding another tuple to the
parametrize decorator.  That is: each new test becomes a single line.  That's some
super-concise test definition.

The [docs on this](https://docs.pytest.org/en/latest/parametrize.html#parametrize-basics)
illustrate more stuff you can do with it, I'm just barely scratching the surface.

## Debugging

Another handy trick is that with the `--pdb` command-line argument you can actually have
Py.test automatically drop into the pdb debugger on a failing test:

```shell
$ pytest -v --pdb
========================================================================== test session starts ===========================================================================
platform darwin -- Python 3.6.2, pytest-3.5.1, py-1.5.3, pluggy-0.6.0 -- /Users/aparkin/.virtualenvs/pytestcourse/bin/python3.6
cachedir: .pytest_cache
rootdir: /Users/aparkin/temp/sandbox/pytestcourse/Integer, inifile:
collected 4 items

test/test_integr.py::test_add[1-3-4] PASSED                                                                                                                        [ 25%]
test/test_integr.py::test_add[-1--3--4] PASSED                                                                                                                     [ 50%]
test/test_integr.py::test_fail FAILED                                                                                                                              [ 75%]
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> traceback >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

    def test_fail():
        x = 2342423
>       assert 42 == 4234
E       assert 42 == 4234

test/test_integr.py:167: AssertionError
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> entering PDB >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
> /Users/aparkin/temp/sandbox/pytestcourse/Integer/test/test_integr.py(167)test_fail()
-> assert 42 == 4234
(Pdb)
```

You can then use the usual `pdb` commands to try and figure how why a test is failing.

# Other Stuff

There's way more to Py.test, things like Fixtures to replace the `setUp` & `tearDown` for
classes, running doctests, and a million other options.  Hopefully this is a good starting
introduction.
