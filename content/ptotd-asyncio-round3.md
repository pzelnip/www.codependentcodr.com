Title: Asyncio Part the third
Date: 2018-08-13 15:06
Modified: 2018-08-13 15:06
Category: Posts
tags: python,asyncio,asyncawait
cover: static/imgs/default_page_imagev2.jpg
summary: What happens when you try to make an __init__ async?

I found this interesting and gave a small bit of insight/help with forming my mental model around
asyncio.  Let's say you have a class:

```python
import asyncio


class Foo:
    def __init__(self, loop):
        print("in foo init")
        loop.run_until_complete(self.consumer())

    async def consumer(self):
        print("in consumer")


def main():
    loop = asyncio.get_event_loop()
    f = Foo(loop)


if __name__ == "__main__":
    main()
```

This is perfectly fine.  Nothing wrong with calling some async code from your (synchronous)
`__init__` method.

What happens though if you make your ```__init__``` async though?

```python
... same from before ...

class Foo:
    async def __init__(self, loop):
        print("in foo init")
        await self.consumer()

... rest same as before ...
```

When you run this, you'll find you get an error:

```shell
Traceback (most recent call last):
  File "/Users/ad0418340/temp/sandbox/interac/paymentdispatch/test5.py", line 20, in <module>
    main()
  File "/Users/ad0418340/temp/sandbox/interac/paymentdispatch/test5.py", line 16, in main
    f = Foo(loop)
TypeError: __init__() should return None, not 'coroutine'
```

As it turns out, this is the same exception that gets thrown anytime you `return` a value
from `__init__`.  For example:

```python
class Foo:
    def __init__(self):
        return 42  # this will blow up with a TypeError
```

What can we take from this?  A coroutine is a *type* of value.  As soon as you put `async`
on a function it means that "calling" that function now returns a value of type `coroutine`.
Since `__init__` methods can't return values in Python (it'd be nonsensical to do so, think
about how you'd possibly get the value from a return), you can't make your `__init__` methods
`async`.
