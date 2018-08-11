Title: Asyncio part 2 - Now More Abstract
Date: 2018-08-08 11:56
Modified: 2018-08-08 11:56
Category: Posts
tags: python,ptotd,asyncio,coroutine,abstract,abc
cover: static/imgs/python-logo-master-v3-TM.png
summary: What happens when you mix coroutines with Abstract Base Classes?

Continuing on with my asyncio learnings.  Had the opportunity to look at a wrinkle I haven't seen discussed
much -- using coroutines with [Abstract Base Classes](https://docs.python.org/3/library/abc.html).

First question: can coroutines be abstract?  Yes.  Yes they can:

```python
from abc import ABC, abstractmethod

import asyncio


class AbstractBase(ABC):
    @abstractmethod
    async def meth1(self):
        pass


class Concrete(AbstractBase):
    async def meth1(self):
        print("in concrete")

if __name__ == "__main__":
    loop = asyncio.get_event_loop()
    loop.run_until_complete(Concrete().meth1())  # prints "in concrete"
```

Nothing particularly surprising there.

Next question: is an abstract class still uninstantiable?  Yes.  Yes it is:

```python
>>> AbstractBase()
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
TypeError: Can't instantiate abstract class AbstractBase with abstract methods meth1
```

Cool, so far so good.

Ok, next question: what happens if an implementing class doesn't denote an overriding
method as a coroutine?  Nothing:

```python
class ConcreteButNotCoroutine(AbstractBase):
    def meth1(self):
        print("in concrete but not coroutine")
```

However, this is where it gets a bit grey.  `meth1()` on `ConcreteButNotCoroutine` is
a method, not a coroutine, so it can't be passed to `run_until_complete()`:

```python
>>> loop.run_until_complete(ConcreteButNotCoroutine().meth1())
in concrete but not coroutine
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
  File "/usr/local/Cellar/python/3.7.0/Frameworks/Python.framework/Versions/3.7/lib/python3.7/asyncio/base_events.py", line 547, in run_until_complete
    future = tasks.ensure_future(future, loop=self)
  File "/usr/local/Cellar/python/3.7.0/Frameworks/Python.framework/Versions/3.7/lib/python3.7/asyncio/tasks.py", line 588, in ensure_future
    raise TypeError('An asyncio.Future, a coroutine or an awaitable is '
TypeError: An asyncio.Future, a coroutine or an awaitable is required
```

This is kinda icky, now whomever is using a concrete implementation of `AbstractBase`
has to know if the specific derived class marked `meth1()` as `async` or not.  This
seems to defeat much of the purpose of using an abstract base class in the first
place as it's kind of a violation of the [Liskov Substitution Principle](https://en.wikipedia.org/wiki/Liskov_substitution_principle).
The LSP is typically stated as (this is taken from the Wikipedia page):

> if S is a subtype of T, then objects of type T may be replaced with objects of
> type S (i.e. an object of type T may be substituted with any object of a
> subtype S) without altering any of the desirable properties of the program
> (correctness, task performed, etc.)

That is, you should be able to use a `ConcreteButNotCoroutine` instance anywhere you
can use a `Concrete` instance without having things go boom boom.

Python's long had a history of being a little lax with the typing (some would call
that a feature, some would call it a shortcoming), but this feels a bit unfortunate.

I did some Googling and someone asked [this question on Stackoverflow](https://stackoverflow.com/questions/47555934/how-require-that-an-abstract-method-is-a-coroutine)
which provides a workaround to check if an implementing class overrides an abstract coroutine
with a coroutine, but still feels rather cumbersome.  It also still results in a runtime error,
just at object instantiation time instead of at method call time.
