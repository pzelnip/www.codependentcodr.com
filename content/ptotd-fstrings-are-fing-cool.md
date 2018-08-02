Title: F-Strings Are F'ing Cool
Date: 2018-07-12 15:27
Modified: 2018-07-12 15:27
Category: Posts
tags: python,pythonTipOfTheDay,fstrings
cover: static/imgs/python-logo-master-v3-TM.png
summary: Python 3.6 introduced a new way to format strings. They're really f-ing cool. Let's see why.

In Python 3.6 a new (yet another) way to format strings was introduced -- F-strings.
These were introduced as part of [PEP-498](https://www.python.org/dev/peps/pep-0498/),
and while there can be a "really do we need yet another way to do this?" response to them
when you first see them, in actuality they are one of the coolest additions to the
language I've seen in recent years.

## The Basics

You denote an f-string by prefixing a `f` or `F` in front of a string literal:

```python
mystring = f'This is an f-string!'
print(mystring)  # prints "This is an f-string!"
```

Nothing exciting here, where f-strings get more interesting is when you want to
interpolate a value into it:

```python
x = 42
mystring = f'The answer to life, the universe and everything is {x}'
print(mystring)  # prints "The answer to life, the universe and everything is 42"
```

Ok, so that's just like the string formatting operator (`%`) and the `format()`
function.  Ie these are all equivalent:

```python
x = 42
with_string_op = 'The answer to life, the universe and everything is %d' % x
with_format_fn = 'The answer to life, the universe and everything is {}'.format(x)
with_f_string = f'The answer to life, the universe and everything is {x}'

print(with_string_op == with_format_fn == with_f_string)  # prints "True"
```

Ok, I hear you saying that's neat, but isn't that just syntactic sugar?  Adam, why do you think
F-strings are cool?  Let's see some more cool tricks and reasons why you should start
using them.

## Arbitrary Expressions

Note that the stuff inside the braces can be arbitrary Python expressions:

```python
x = 100
y = 99
print(f'{x} + {y} * 2 is equal to {x + y * 2}')  # prints "100 + 99 * 2 is equal to 298"
```

This affords an enormous amount of flexibility, as pretty much anything that's a valid
Python bit of code could be put into an f-string block.  This also tends to make for
strings that are more readable, consider:

```python
logging.warn("Disk space for drive {} is low, only {} bytes remaining".format(driveid, space_left))
```

vs

```python
logging.warn(f"Disk space for drive {driveid} is low, only {space_left} bytes remaining")
```

Because the identifiers are right in the middle of the string literal, it's easier to
envision in your head what the final string will be, rather than doing the "ok, this
first argument goes here, and the second goes there" mental mapping you do with the
`format()` call.  It is worth noting you can get the same thing with format, but it
becomes very verbose:

```python
logging.warn(
    "Disk space for drive {driveid} is low, only {space_left} bytes remaining".format(
        driveid=driveid, space_left=space_left
    )
)
```

I find that hard to read, and I very much don't like the alignment of the arguments
across multiple lines.  I formatted that line with [Black](https://github.com/ambv/black),
so perhaps it's a matter of my taste not aligning with that formatter, but I've always
struggled with manually formatting complex `format()` calls as it always feels like the final
result is ugly.

## Fast

This is cool, f-strings are also fast.  Why?  Because the expression
is treated like a plain old python expression, parsed & evaluated at runtime.  They
also save the overhead of a function call (like with `format()`), which we can see
with the `dis` module:

```python
>>> import dis
>>> def foo():
...     x = 42
...     y = 99
...     return '{} + {} = {}'.format(x, y, x + y)
...
>>> foo()
'42 + 99 = 141'
>>> dis.dis(foo)
  2           0 LOAD_CONST               1 (42)
              2 STORE_FAST               0 (x)

  3           4 LOAD_CONST               2 (99)
              6 STORE_FAST               1 (y)

  4           8 LOAD_CONST               3 ('{} + {} = {}')
             10 LOAD_ATTR                0 (format)
             12 LOAD_FAST                0 (x)
             14 LOAD_FAST                1 (y)
             16 LOAD_FAST                0 (x)
             18 LOAD_FAST                1 (y)
             20 BINARY_ADD
             22 CALL_FUNCTION            3
             24 RETURN_VALUE
```

The output of `dis` can be a bit hard to read, but notice the `LOAD_ATTR`
line, which is Python doing a lookup of the `format` function, and then there's
the `CALL_FUNCTION` instruction which is actually calling that function so you
pay the overhead of a function call (which in Python has always been
surprisingly expensive).

With f-strings we don't have that:

```python
>>> def foo():
...     x = 42
...     y = 99
...     return f'{x} + {y} = {x + y}'
...
>>> dis.dis(foo)
  2           0 LOAD_CONST               1 (42)
              2 STORE_FAST               0 (x)

  3           4 LOAD_CONST               2 (99)
              6 STORE_FAST               1 (y)

  4           8 LOAD_FAST                0 (x)
             10 FORMAT_VALUE             0
             12 LOAD_CONST               3 (' + ')
             14 LOAD_FAST                1 (y)
             16 FORMAT_VALUE             0
             18 LOAD_CONST               4 (' = ')
             20 LOAD_FAST                0 (x)
             22 LOAD_FAST                1 (y)
             24 BINARY_ADD
             26 FORMAT_VALUE             0
             28 BUILD_STRING             5
             30 RETURN_VALUE
```

Note no function lookup.  To give an idea of timing, let's use the `timeit` module,
first with the `format()` function:

```python
>>> timeit.timeit("foo()", setup="from __main__ import foo")
0.807306278962642
```

And now with f-strings:

```python
>>> timeit.timeit("foo()", setup="from __main__ import foo")
0.6124071741942316
```

Ballpark 25% faster, not bad.  And just for completeness sake, what about the
string formatting operator:

```python
>>> def foo():
...      x = 42
...      y = 99
...      return '%d + %d = %d' % (x, y, x + y)
...
>>> foo()
'42 + 99 = 141'
>>> timeit.timeit("foo()", setup="from __main__ import foo")
0.5939487249124795
```

Oooh, that's interesting, just a smidge faster than f-strings.  Still, unlike
the `format()` function, there's no performance overhead to f-strings, and in
some cases it can be the fastest of all three approaches.

## Using format specifiers

This is where you can do some neat tricks.  If you've never really played with
format specifiers in Python, they can be quite useful.  The relevant docs:
<https://docs.python.org/3.7/library/string.html#format-specification-mini-language>

The Format Specification mini language is used with the `format()` function, but
as it turns out, you can also use format specifiers with f-strings.  For example:

```python
print(f"Pi to 3 digits: {math.pi:.3f}")  # prints "Pi to 3 digits: 3.142"
```

This can be handy for formatting as well:

```python
print(f"{42:05}")  # gives "00042"

print(f"{42:a<10}")  # gives "42aaaaaaaa"

print(f"{42:a>10}")  # gives "aaaaaaaa42"

print(f"{42:3>10}")  # gives "3333333342"

print(f"{42:=^10}")  # gives "====42===="
```

Type specific formatting is also supported, for example avoiding calling `strftime()`
to format a `datetime`:

```python
>>> from datetime import datetime
>>> f"Today is {datetime.now():%B %d, %Y}"
'Today is July 15, 2018'
```

There's some really cool examples of format specifiers in the
[docs](https://docs.python.org/3.7/library/string.html#format-specification-mini-language)
, I'd definitely suggest giving it a read.

## The best of all worlds

Ultimately, F-strings are really flexible, and to me represent the best of all worlds.
You get the performance of the string formatting operator, the flexibility of the
`format()` function, and syntactically it all tends to read better as well.
