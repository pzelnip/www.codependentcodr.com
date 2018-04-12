Title: Python Tip of the Day - Double If's in Comprehensions
Date: 2018-04-11 13:21
tags: ptotd,pythonTipOfTheDay

So I was reviewing a coworkers pull request today and saw something I hadn't seen in
Python before.  As it turns out you can have multiple `if` clauses on a list comprehension.
For example:

```python
>>> [v for v in range(50) if v % 2 == 0 if v > 10]  # all even numbers between 10 & 50
[12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 38, 40, 42, 44, 46, 48]
```

I wondered if this was mentioned in the [standard docs](https://docs.python.org/3/tutorial/datastructures.html#list-comprehensions)
, and sure enough:

> A list comprehension consists of brackets containing an expression followed by a for clause, then
> ***zero or more*** for or if clauses.

(emphasis added)  That is, you can have as many `if` clauses as appropriate. It is roughly the same as:

```python
>>> result = []
>>> for v in range(50):
...     if v % 2 == 0:
...             if v > 10:
...                     result.append(v)
...
>>> result
[12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 38, 40, 42, 44, 46, 48]
```

Astute readers will note that the multiple if clauses is equivalent to `and`-ing multiple boolean
expressions together.  Ie that example is the same as:

```python
>>> [v for v in range(50) if v % 2 == 0 and v > 10]
[12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 34, 36, 38, 40, 42, 44, 46, 48]
```

For me, this raised the question about order of evaluation, and if multiple if clauses do
[boolean short-circuiting](https://en.wikipedia.org/wiki/Short-circuit_evaluation) like an
`and` statement does.  So let's test that out:

```python
>>> def foo():
...    raise ValueError()
...
>>> False and foo()
False
>>> [x for x in range(10) if False and foo()]
[]
>>> [x for x in range(10) if False if foo()]
[]
```

And we can see because we don't see an exception raised, that `foo()` was never called, so yes it is
only evaluating the second if clause if the first evaluates to `True`.

If you want to *really* convince yourself they're equivalent, you can use the
[`dis`](https://docs.python.org/3/library/dis.html) module to see
the equivalent bytecode for the two snippets:

```python
>>> import dis
>>> dis.dis("[x for x in range(10) if False and foo()]")
  1           0 LOAD_CONST               0 (<code object <listcomp> at 0x10c4aeed0, file "<dis>", line 1>)
              2 LOAD_CONST               1 ('<listcomp>')
              4 MAKE_FUNCTION            0
              6 LOAD_NAME                0 (range)
              8 LOAD_CONST               2 (10)
             10 CALL_FUNCTION            1
             12 GET_ITER
             14 CALL_FUNCTION            1
             16 RETURN_VALUE
>>> dis.dis("[x for x in range(10) if False if foo()]")
  1           0 LOAD_CONST               0 (<code object <listcomp> at 0x10c4aeed0, file "<dis>", line 1>)
              2 LOAD_CONST               1 ('<listcomp>')
              4 MAKE_FUNCTION            0
              6 LOAD_NAME                0 (range)
              8 LOAD_CONST               2 (10)
             10 CALL_FUNCTION            1
             12 GET_ITER
             14 CALL_FUNCTION            1
             16 RETURN_VALUE
```

From this we can see that the corresponding bytecode is identical.

Probably unsurprisingly these apply to not only list comprehensions but `set` and `dict`
comprehensions as well:

```python
>>> names = ["adam", "bob", "andrew", "adam", "fred"]
>>> [name for name in names if len(name) == 4 if name.startswith("a")]
['adam', 'adam']
>>> {name for name in names if len(name) == 4 if name.startswith("a")}
{'adam'}
>>> {name: name.title() for name in names if len(name) == 4 if name.startswith("a")}
{'adam': 'Adam'}
```

The first snippet gets all names that are four characters long & start with the letter `"a"`.  Because
it's a list, duplicates are matched.  The second does the same, but as a set comprehension and
since it's a set, duplicates are filtered out, so we only see `"adam"` once.
The last one creates a dict mapping the name as it's in the original list to the titlecased version
of the name.
