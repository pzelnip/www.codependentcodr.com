Title: Asyncio, You are a complex beast...
Date: 2018-08-02 12:54
Modified: 2018-08-02 12:54
Category: Posts
tags: asyncio,python,ptotd
cover: static/imgs/default_page_imagev2.jpg
summary: Learning asyncio



status: draft

Some boilerplate:

```python
import asyncio
import random
import functools

# make the print function always flush output immediately
print = functools.partial(print, flush=True)

# A message to indicate end of processing
END_OF_QUEUE = "This is the end...  This value doesn't actually matter so long as it's not a possible real value to go in the queue"
```

A basic example of a co-routine that loops waiting on a queue:

```python

async def queue_coro(queue):
    while True:
        message = await queue.get()
        if message == END_OF_QUEUE:
            print(f"This is the end my friend....")
            break
        print(f"Got message: {message}")

if __name__ == "__main__":
    queue = asyncio.Queue()
    loop = asyncio.get_event_loop()

    loop.run_until_complete(queue.put("foobar!"))
    loop.run_until_complete(queue.put("foobar is another!"))
    loop.run_until_complete(queue.put(END_OF_QUEUE))
    loop.run_until_complete(queue_coro(queue))

    loop.stop()
    loop.run_forever()
    loop.close()
```

outputs:

```
Got message: foobar!
Got message: foobar is another!
This is the end my friend....
```

But if you put that `END_OF_QUEUE` before the `queue_coro` then it goes forever.  Remember that
the event loop is single threaded.

We can expand this to a basic producer/consumer example:

```python
async def producer(queue):
    while True:
        emit_me = random.randint(1, 42)
        if emit_me == 42:
            print("At the end")
            break
        else:
            msg = f"Emitting {emit_me}"
            print(msg)
            await asyncio.sleep(random.uniform(0, 0.5))
            await queue.put(msg)

    await queue.put(END_OF_QUEUE)


async def consumer(queue):
    while True:
        message = await queue.get()
        if message == END_OF_QUEUE:
            print(f"This is the end my friend....")
            break
        print(f"Got message: {message}")
        await asyncio.sleep(random.uniform(0, 1.0))


if __name__ == "__main__":
    loop = asyncio.get_event_loop()
    queue = asyncio.Queue()
    loop.run_until_complete(asyncio.gather(producer(queue), consumer(queue)))
    loop.stop()
    loop.close()
```

Output will vary since values produced are randomly generated, but as an example:

```
Emitting 38
Emitting 35
Got message: Emitting 38
Emitting 29
Emitting 6
Got message: Emitting 35
Emitting 30
Emitting 14
Got message: Emitting 29
Emitting 20
Emitting 24
Emitting 19
Got message: Emitting 6
Emitting 30
Got message: Emitting 30
Got message: Emitting 14
Emitting 24
Emitting 5
Got message: Emitting 20
Got message: Emitting 24
Emitting 10
Got message: Emitting 19
Emitting 35
Emitting 23
Emitting 18
Got message: Emitting 30
Got message: Emitting 24
Emitting 31
Emitting 5
Emitting 39
Got message: Emitting 5
Got message: Emitting 10
Emitting 29
Emitting 24
Emitting 34
Got message: Emitting 35
Emitting 30
Emitting 31
Got message: Emitting 23
Emitting 31
Emitting 1
Emitting 36
Got message: Emitting 18
Emitting 20
Got message: Emitting 31
Emitting 37
Emitting 39
Emitting 12
Emitting 27
Got message: Emitting 5
Emitting 10
At the end
Got message: Emitting 39
Got message: Emitting 29
Got message: Emitting 24
Got message: Emitting 34
Got message: Emitting 30
Got message: Emitting 31
Got message: Emitting 31
Got message: Emitting 1
Got message: Emitting 36
Got message: Emitting 20
Got message: Emitting 37
Got message: Emitting 39
Got message: Emitting 12
Got message: Emitting 27
Got message: Emitting 10
This is the end my friend....
```

The idea here is that the producer is generating values at a rate that is faster than
the consumer can consume (hence the asyncio sleep call in the range 0 to 0.5, whereas
the consumer sleeps in the range 0 to 1).  This is why we see the "emitting" messages
appearing at a greater rate than the "Got message" messages, and then after seeing
"At the end", which is when the producer has found 42 and terminates, we then see the
consumer then go ahead and consume any remaining items that have been enqueued.

Note that those sleep calls are critical, try taking them out and you'll see output
looks like:

```
Emitting 17
Emitting 20
Emitting 24
Emitting 2
Emitting 29
At the end
Got message: Emitting 17
Got message: Emitting 20
Got message: Emitting 24
Got message: Emitting 2
Got message: Emitting 29
This is the end my friend....
```

That is, the consumer keeps consuming until 42 is found, and then the consumer
consumes everything. The reason for this is that the `asyncio.sleep()` call will
yield control (it's effectively an I/O operation).  Remember: `asyncio` is
single threaded concurrency, without those sleep calls what happens is the item
is put on the queue in the producer, then control immediately returned to the
producer, which loops and produces the next value, etc.

Note that this is a neat trick, if your intent in a coroutine is to yield control
to something else you can always do a `asyncio.sleep(0)` which pauses the coroutine
returning control back to the event loop, which then schedules the next task and
passes control to it.



Testing Antipatterns

Don't use `get_event_loop` as then you can introduce dependencies between tests (ex: one test
closes the loop, then another tries to run something on it and boom, but dependent on order)
