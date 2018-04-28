Title: Python Tip of the Day - subTest!
Date: 2017-09-23 10:20
tags: ptotd,pythonTipOfTheDay,testing,unittest,python
cover: static/imgs/python-logo-master-v3-TM.png

Coming from a [jUnit](https://junit.org/junit5/) background, one of the things I always missed with the vanilla
[Python unitttest library](https://docs.python.org/3/library/unittest.html) was parameterized tests.  Oftentimes when
writing unit tests for a particular unit you find yourself writing effectively the same test over and over again, but
with different inputs. Wouldn't it be nice if we could write the test once and somehow parameterize the test with
different inputs? Yes. Yes it would.

[Py.test supports this](https://docs.pytest.org/en/latest/example/parametrize.html), but what if you really like
[Nose](http://nose.readthedocs.io/en/latest/) or some other test runner? Well, in Python 3.4 now in the standard
unittest library we have something very similar -- [subTests](https://docs.python.org/3/library/unittest.html#distinguishing-test-iterations-using-subtests).

The idea is you can write a loop over a set of inputs, and within that loop define a test within a with `self.subTest()`
context. Each iteration will test the given input and failures for each are counted as separate test failures. Really
handy for cutting down on unit test boilerplate code.
