Title: Handy Python tip #1
Date: 2012-06-07 20:16
tags: pythonTipOfTheDay,python
cover: static/imgs/python-logo-master-v3-TM.png

The other day I was adding the rich comparison methods (the ones for operator overloading) to a class I had defined.
Like many Python programmers before me I wondered "why is it that if I define a method for equality, I still have to
define a not-equal method?" and "if I define a comparison method, why do I have to define the other comparison methods?"

And then low and behold, while looking for something completely different, I stumbled across the
[`functools.total_ordering`](http://docs.python.org/release/2.7/library/functools.html#functools.total_ordering) class
decorator.  With it, you can define just the `__eq__` method, and any rich comparison method (`__le__`, `__lt__`,
`__gt__`, etc), and it provides default implementations for all the others.

Very handy stuff.

An example can be found in my [MiscPython examples collection on Github](https://raw.github.com/pzelnip/MiscPython/e2a37ce2f2a51d5f69df82091d94dd239152ca63/operator_overloading/total_ordering.py).

(Note: this post originally appeared on my blogspot blog at: <http://codependentcodr.blogspot.ca/2012/06/handy-python-tip-1.html>)
