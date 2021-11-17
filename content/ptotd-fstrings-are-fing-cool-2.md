Title: F-Strings Are F'ing Cool Part 2
Date: 2021-07-11 15:27
Modified: 2021-07-11 15:27
Category: Posts
tags: python,pythonTipOfTheDay,fstrings
cover: static/imgs/python-logo-master-v3-TM.png
summary: I learned some new tricks with f-strings, lets check 'em out.

So in a
[previous post]({filename}/ptotd-fstrings-are-fing-cool.md)
a couple years ago I wrote about some of the reasons the f-string functionality
introduced in Python 3.6 was so useful.  Today I learned a few new tricks with
them from
[a recent episode of the Python Bytes Podcast](https://pythonbytes.fm/episodes/show/241/f-yes-we-want-some-f-string-tricks)
 so wanted to revisit the topic & share.

## Debugging

So how many times have you been debugging, wanted to know what the value of a
variable was at a particular point, and then wrote something like:

```python
>>> myvariable = 42
>>> print(f"The value of myvariable is: {myvariable}")
The value of myvariable is: 42
```

Ok, putting aside the fact I'm using print statements for debugging (😱), this is extremely common.
But what if you had a second variable?  Ok, so then you add it as well:

```python
>>> myvariable = 42
>>> myothervariable = 99
>>> print(f"The value of myvariable is: {myvariable}  myothervariable: {myothervariable}")
The value of myvariable is: 42  myothervariable: 99
```

And so on.  But I'm lazy, I don't want to repeat the variable name twice, so as
of Python 3.8 there's a
[new specifier to aid with debugging](https://docs.python.org/3/whatsnew/3.8.html#f-strings-support-for-self-documenting-expressions-and-debugging).
By appending an equal sign (`=`) to the expression the both the name & value get
emitted:

```python
>>> myvariable = 42
>>> myothervariable = 99
>>> print(f"The value of {myvariable=} {myothervariable=}")
The value of myvariable=42 myothervariable=99
```

Super handy.  What's really amazing is it works with expressions too:

```python
>>> myvariable = 42
>>> myothervariable = 99
>>> print(f"Calculation: {(myvariable * 3.14159 / myothervariable)=}")
Calculation: (myvariable * 3.14159 / myothervariable)=1.3327957575757574
```

This can be handy when printing out properties of an object:

```python
>>> class Foo:
...     bar = 42
...
>>> f = Foo()
>>> print(f"{f.bar=}")
f.bar=42
```

It's also particularly handy if you have a function which takes arbitrary parameters
via `args` and `kwargs` and you want to see what the values of them are:

```python
>>> def foo(*args, **kwargs):
...     print(f"{args=} {kwargs=}")
...
>>> foo(242, 2342, "adlfk", arg1=9234, arg2="dfslkj")
args=(242, 2342, 'adlfk') kwargs={'arg1': 9234, 'arg2': 'dfslkj'}
```

## Common Format Specifiers

So one of the things I talked about in my last post on F-strings was how you can use
all the same format specifiers you used to use with `.format()` with F-strings.  A
common example of this is to format a float to a specific number of decimal places:

```python
>>> import math
>>> print(f"Pi to 3 digits: {math.pi:.3f}")
Pi to 3 digits: 3.142
```

Or formatting datetimes:

```python
>>> from datetime import datetime
>>> print(f"Today is {datetime.now():%B %d, %Y}")
Today is July 11, 2021
```

This is neat and all, but oftentimes these format strings are used in many
places in a project.  Say for example you want all dates in your project to be
formatted like the example above.  One approach would be to repeat that format
string (`%B %d, %Y`) in each place you format a date.  The problem though is
if that format changes (say in the future you want 2 digit years, or want to
include the day of the week, etc) you'd then have to search & replace every
spot where you've used that format.

Ok, so this is software engineering 101, time for the "Don't Repeat Yourself"
(or DRY) principle to apply, so maybe you extract out a function to format a
datetime:

```python
>>> def format_date(datetime_obj):
...     return f"{datetime_obj:%B %d, %Y}"
...
>>> print(f"Today is {format_date(datetime.now())}")
Today is July 11, 2021
```

Which works and is perfectly reasonable, but now you have this little function
floating around which makes the f-string expression a little more cumbersome.
One could also make a case that defining a function that is a single line of
code is a bit overengineered (I'm not particularly sympathetic to this view
myself, but some are). And really the format string is a constant, so arguably
it's a little weird to have a function to express it's application.

But, here's where my mind was blown -- you can nest f-string expressions:

```python
>>> DATETIME_FORMAT='%B %d, %Y'
>>>
>>> print(f"Today is {datetime.now():{DATETIME_FORMAT}}")
Today is July 11, 2021
```

Now our format expression is a single constant variable, and we just defer to
it wherever we want to format a datetime.  If that format changes, we simply
update the constant.  Really useful trick.
