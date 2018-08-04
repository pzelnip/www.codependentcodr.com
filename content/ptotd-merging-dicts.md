Title: Python Tip of the Day - Merging Dicts
Date: 2018-08-03 18:35
Modified: 2018-08-03 18:35
Category: Posts
tags: python,ptotd
cover: static/imgs/python-logo-master-v3-TM.png
summary: Python Tip of the Day - Merging Two Dicts

So it's not uncommon to want to merge two dictionaries
in Python into a single dict.  Typically, you'd do this like so:

```python
x = {"key1": "value1", "key2": "value2"}
y = {"key2": "valuefromy", "key3": "value3"}
x.update(y)
```

But this is problematic because you're modifying `x` in place.  Additionally it's
multiple lines, instead of a single line to combine the two.  Wouldn't it be nice
if you could combine two dicts in a single line to produce a new dict with the
combination of the two?

Indeed it would, and as of Python 3.5 you can.

```python
x = {"key1": "value1", "key2": "value2"}
y = {"key2": "valuefromy", "key3": "value3"}
print({**x, **y})  # prints {'key1': 'value1', 'key2': 'valuefromy', 'key3': 'value3'}
```

Nice little shorthand.  It's worth noting as well that this is actually quite fast:

```python
>>> timeit.timeit("{**x, **y}", setup='x = {"key1": "value1", "key2": "value2"}; y = {"key2": "valuefromy", "key3": "value3"}')
0.17988868800000546
>>> timeit.timeit("x.update(y)", setup='x = {"key1": "value1", "key2": "value2"}; y = {"key2": "valuefromy", "key3": "value3"}')
0.20185830300002294
```

Best of all worlds, it's short, fast, concise and side-effect free.
