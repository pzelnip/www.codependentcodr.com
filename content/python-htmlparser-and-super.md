Title: Python HTMLParser and super()
Date: 2012-02-16 15:48
tags: python,inheritance
cover: static/imgs/python-logo-master-v3-TM.png

So I have a class that inherits from `HTMLParser`, and I want to call the super class init (the `__init__` of
`HTMLParser`), I would think I should do:

```python
class MyParser(HTMLParser):
    def __init__(self):
        super(MyParser, self).__init__()
```

But this causes a problem:

```python
myparser = MyParser()

Traceback (most recent call last):
    File "", line 1, in
    File "", line 3, in __init__
    TypeError: must be type, not classobj
```

What's with that? The `super(class, instance).__init__` idiom is the supposed proper way of calling a parent class
constructor, and it is -- if the class is a "new-style" Python class (one which inherits from `object`, or a class which
inherits from `object`).

And therein is the problem: `HTMLParser` inherits from `markupbase.ParserBase`, and `markupbase.ParserBase` is defined as:

```python
class ParserBase:
    """Parser base class which provides some common support methods used
    by the SGML/HTML and XHTML parsers."""
```

That is, as an *old* style class. One definitely wonders why in Python 2.7+ the classes that form part of the standard
library wouldn't all be new-style classes, *especially* when the class is intended as being something you inherit from
(like `HTMLParser`). Anywho, to fix:

```python
class MyParser(HTMLParser):
    def __init__(self):
        # Old style way of doing super()
        HTMLParser.__init__(self)
```

(Note: this post originally appeared on my blogspot blog at: <http://codependentcodr.blogspot.ca/2012/02/python-htmlparser-and-super.html>)
