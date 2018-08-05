Title: Asyncio, You are a complex beast...
Date: 2018-08-05 10:00
Modified: 2018-08-05 10:30
Category: Posts
tags: asyncio,python,ptotd
cover: static/imgs/default_page_imagev2.jpg
summary: Learning asyncio

Recently I've been digging into Python's `asyncio` library which was introduced
as part of Python 3.4, and iterated upon in each release since.  My reasons for
learning about it are work-related, but I thought it'd be interesting/insightful
to share things I've learned here, partly to share with the world (as the docs
for `asyncio` are rather...terse) as well as reinforce what I've managed to
figure out.

This is likely going to be long, as there's a lot to learn & know about
`asyncio`.

Some context: I never used [Twisted](https://twistedmatrix.com/), nor have I
done really much/any asynchronous programming (except for multithreaded or
multiprocessed code if you count that).  As such, most of this was entirely new
for me.

## Basic Definitions

To talk about `asyncio`, you need to talk about coroutines.  To talk about
coroutines, you need to talk about generators.  To talk about generators, you
need to talk about the `yield` statement.  Rather than regurgitate all this, I'm
going to point you at a phenomenal post by [Brett
Cannon](https://twitter.com/brettsky) (one of the Python core devs) that gives
all this background info:

<https://snarky.ca/how-the-heck-does-async-await-work-in-python-3-5/>

That post is largely about the `async`/`await` keywords introduced in Python
3.5, but Brett does a phenomenal job of painstakingly going through the
fundamentals of coroutines, generators, etc.  Please do give this a read before
continuing on (I know it's long, but really worth it).

I'm not going to go into too much detail talking about what asynchronous
programming is, or why you might want to do it, instead I'll point you at these
resources:

* <http://sdiehl.github.io/gevent-tutorial/#synchronous-asynchronous-execution>
* <https://djangostars.com/blog/asynchronous-programming-in-python-asyncio/>
* <https://medium.freecodecamp.org/a-guide-to-asynchronous-programming-in-python-with-asyncio-232e2afa44f6>

These videos are also quite good (though can be long):

* <https://www.youtube.com/watch?v=ZKnETCH4S0w>
* <https://www.youtube.com/watch?v=Z_OAlIhXziw> (classic, though pre-dates asyncio by a good degree)

Some of the key ideas to take away from those:

* `asyncio` is an implementation of an event loop that coroutines can be scheduled on
* `async` and `await` are keywords added for convenience sake to make coroutines easier
* asynchronous programming with asyncio means "single threaded concurrency"

That last point is really key: with `asyncio` only one thread is in play.  You
get the concurrency via cooperative multitasking between coroutines (ie when one
blocks on IO you switch to another while the previous one is waiting).  This has
a few implications.

One of those is if your code is CPU bound you're not going to get any perf
benefit from `asyncio`.  This is true of threads as well because of the GIL, but
not for multiprocessing (if that's possible for your problem, though at the
expense of complexity, safety, and resources).

Another is because it's all single-threaded it can be easier to reason about,
and nasty problems like [race
conditions](https://en.wikipedia.org/wiki/Race_condition) tend to be less
common.

## Hello World As A Coroutine

Or "How the %@#@ do I even run a coroutine?"  This is the first spot where I
feel a very real pain with `asyncio` -- it feels like there's multiple ways to
do basically the same thing, but that vary slightly leading to lots of cognitive
load in using the library.  But a basic example:

```python
import asyncio

async def helloworld():
    print("Hello world from a coroutine!")

def main():
    loop = asyncio.get_event_loop()
    loop.run_until_complete(helloworld())

if __name__ == "__main__":
    main()
```

Breaking this down:

* the `async` keyword (new in Python 3.5) makes `helloworld()` a coroutine
* the call to `get_event_loop()` gets us an event loop we can schedule this coroutine on
* the call to `run_until_complete()` does a few things:
    * schedules the `helloworld()` coroutine to run on the loop
    * yields control to the event loop scheduler
    * the event loop then picks up that scheduled coroutine & switches control to it
    * the coroutine executes, prints the message and then returns control back to the loop
    * the loop then switches control back to the `main()` routine

And then the program continues on its merry (synchronous) way.

It's worth noting that "scheduling a coroutine" can be done many different ways.
`run_until_complete()` will do it implicitly with a coroutine by wrapping it in
a `Future` & scheduling it, but there are others:

```python
loop.run_until_complete(asyncio.wait([helloworld()]))

... or ...

loop.run_until_complete(asyncio.gather(helloworld()))
```

And probably others I'm not thinking of.  The idea is that `run_until_complete`
gets a `Future` and it runs that `Future` to completion.  If given a coroutine
it'll wrap it in a `Future` before running.  `wait()` takes a collection of
`Future`s and returns a `Future` representing the completion of all those
sub-Future's.  Much like `run_until_complete`, if it's given a coroutine it'll
wrap it in a `Future` (well, technically `Task`s, but those are subclasses of
`Future`).  `gather()` is similar in that you give it "a bunch of tasks", but
takes either coroutines or `Future`'s.  There's also some very subtle
differences between `gather()` and `wait()` in terms of cancellation ability,
return values, etc.

There's other ways to schedule tasks as well.  In Python 3.7 there's a new
`create_task` routine in `asyncio` that schedules a task, but requires that
you're executing in a running event loop.  For example to trigger a coroutine to
run from within a coroutine:

```python
async def helloworld():
    print("Hello world from a coroutine!")
    asyncio.create_task(helloworld())

def main():
    loop = asyncio.get_event_loop()
    loop.run_until_complete(helloworld())
```

Runs the `helloworld()` coroutine twice. It's also worth noting that
`asyncio.create_task` (introduced in 3.7) is *not* the same thing as
`AbstractEventLoop.create_task` though serves largely the same purpose.  The
previous example using `create_task` could also be written as:

```python
async def helloworld():
    print("Hello world from a coroutine!")
    asyncio.get_event_loop().create_task(helloworld())

def main():
    loop = asyncio.get_event_loop()
    loop.run_until_complete(helloworld())
```

It appears as though `asyncio.create_task()` is just shorthand to save you the call
to `get_event_loop()`.

Note that doing `asyncio.create_task` from in `main()` would be an error:

```python
def main():
    loop = asyncio.get_event_loop()
    asyncio.create_task(helloworld())   # gives "RuntimeError: no running event loop"
```

But `loop.create_task` is fine (though unless the loop is run the task will never be
executed):

```python
    loop = asyncio.get_event_loop()
    loop.create_task(helloworld())
    loop.run_until_complete(helloworld())
```

Initially the call to `asyncio.create_task(helloworld())` within `helloworld()`
puzzled me as I assumed that would result in infinite scheduling of the task,
but we only see the message get printed twice.  So what's up with that? I [asked
on
StackOverflow](https://stackoverflow.com/questions/51680178/asyncio-create-task-vs-await)
and the gist is that what happens is that `run_until_complete()` means "run
until this coroutine I'm giving you is done and then stop the event loop".  So
`helloworld()` gets run once, it schedules another run of it on the event loop.
This then schedules another run, but because the first run (from the
`run_until_complete`) is now done, the loop is stopped and control returned.

You can use this for a neat trick, for example if we want to run a co-routine
repeatedly for 2 seconds:

```python
async def helloworld():
    print("Hello world from a coroutine!")
    asyncio.create_task(helloworld())

def main():
    loop = asyncio.get_event_loop()
    loop.run_until_complete(asyncio.gather(helloworld(), asyncio.sleep(2)))
```

In terms of the "hey make the event loop run the stuff", there's kinda two basic
approaches.  The first is `run_until_complete()` which just runs the
task/coroutine/whatever until it's done and returns control, and the second is
`run_forever` which runs until something calls `stop()` on the event loop.  An
example of `run_forever`:

```python
async def start():
    while True:
        print("in start")
        await asyncio.sleep(1)


def main():
    loop = asyncio.get_event_loop()

    loop.create_task(start())
    loop.run_forever()
```

Note that this truly does run forever.  Any call to `run_forever()` will cause
the current thread to yield control to the event loop, and that event loop will
continue to keep control until something executes a `.stop()` on the event loop.

`run_forever()` seems to be a tricky construct to get right.  Googling around I
had a lot of difficulty finding any examples of `run_forever()` that seemed to
show how to (in a single threaded application) use it.  The common approach I
saw was to do the `run_forever()` in a separate thread:

```python
import time
import asyncio
from threading import Thread


async def start():
    while True:
        print("in start")
        await asyncio.sleep(1)


def run_it_forever(loop):
    loop.run_forever()


def main():
    loop = asyncio.get_event_loop()

    loop.create_task(start())
    thread = Thread(target=run_it_forever, args=(loop,))
    thread.start()

    time.sleep(5)
    loop.stop()
```

This will run the `start()` coroutine in an event loop which is running
in a subthread, and after 5 seconds the main thread will stop the loop,
and then exit.

One thing to note here: suddenly now we've given up one of the primary
benefits of `asyncio`.  This is no longer a single threaded, easy to reason
about program, but now with multiple threads, suddenly we've introduced
all the complexity of multithreaded programming just to get our event loop
running indefinitely.

There's a lot of notes in the docs about how you have to be careful about
mixing `asyncio` and multiple threads.  I'll point you at the (not so great
but all we have) docs:

* <https://docs.python.org/3/library/asyncio-dev.html#concurrency-and-multithreading>
* <https://docs.python.org/3/library/asyncio-subprocess.html#asyncio-subprocess-threads>
* <https://docs.python.org/3/library/asyncio-eventloop.html#asyncio.AbstractEventLoop.call_soon_threadsafe>

Again, this is some of the pain of `asyncio`, knowing what to use where.

## "Infinite" co-routines

Sometimes you want to have a coroutine that is effectively "always running in
the background".  The classic example is something that reads stuff off of some
shared memory (like a queue) and do some sort of background processing with each
item.

Some boilerplate code that I'll assume is present in each example:

```python
import asyncio
import random
import functools

# make the print function always flush output immediately
# without this you'll find nothing gets printed until program
# end when suddenly all output is printed at once
print = functools.partial(print, flush=True)

# A message to indicate end of processing, the purpose of this
# will become clear in the examples
END_OF_QUEUE = "This is the end...  This value doesn't actually matter so long as it's not a possible real value to go in the queue"
```

`asyncio` provides a `Queue` implementation that allows for asynchronously
yielding control when doing a `put()` or `get()`.  A basic example of a
co-routine that loops waiting on a queue:

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

```text
Got message: foobar!
Got message: foobar is another!
This is the end my friend....
```

Description: we put two items on the queue, and then the special `END_OF_QUEUE`
value which acts as a [sentinel
value](https://en.wikipedia.org/wiki/Sentinel_value) to indicate that processing
is done and the coroutine consuming items from the queue should quit.  We then
queue up that consumer coroutine & run it.

Note if you put that `END_OF_QUEUE` before the `queue_coro` then it goes
forever.  Remember that the event loop is single threaded, so until something
finishes or yields control, it'll keep running.

We can expand this to a basic
[producer/consumer](https://en.wikipedia.org/wiki/Producer%E2%80%93consumer_problem)
example:

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
            # simulate some IO time
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
        # simulate some IO time
        await asyncio.sleep(random.uniform(0, 1.0))


if __name__ == "__main__":
    loop = asyncio.get_event_loop()
    queue = asyncio.Queue()
    loop.run_until_complete(asyncio.gather(producer(queue), consumer(queue)))
    loop.stop()
    loop.close()
```

Output will vary since values produced are randomly generated, but as an
example:

```text
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
Emitting 12
Got message: Emitting 5
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
Got message: Emitting 12
This is the end my friend....
```

The idea here is that the producer is generating values at a rate that is faster
than the consumer can consume (hence the asyncio sleep call in the range 0 to
0.5 seconds, whereas the consumer sleeps in the range 0 to 1 seconds).  This is
why we see the "emitting" messages appearing at a greater rate than the "Got
message" messages, and then after seeing "At the end", which is when the
producer has found 42 and terminates, we then see the consumer then go ahead and
consume any remaining items that have been enqueued.

Note that those sleep calls are critical, try taking them out and you'll see
output looks like:

```text
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

Note that this is a neat trick, if your intent in a coroutine is to yield
control to something else you can always do a `asyncio.sleep(0)` which pauses
the coroutine returning control back to the event loop, which then schedules the
next task and passes control to it.

## Testing Antipatterns

Another significant challenge with `asyncio` is around testing.  Firstly there
isn't a lot of great support yet for testing `asyncio` code (there is a
[`pytest-asyncio`](https://github.com/pytest-dev/pytest-asyncio) package which
offers a few decorators & such, but I haven't found it to be particularly
helpful/useful yet).

I'll refer to you another post by [Miguel
Grinberg](https://twitter.com/miguelgrinberg) on [Unit Testing AsyncIO
Code](https://blog.miguelgrinberg.com/post/unit-testing-asyncio-code) where he
discusses some of the challenges and his approaches to solving them.  Miguel's a
smart guy who's most known for his [Flask
Mega-Tutorial](https://blog.miguelgrinberg.com/post/the-flask-mega-tutorial-part-i-hello-world)
which is something of the defacto way to learn [Flask](http://flask.pocoo.org/).

In addition, one gotcha I ran into not mentioned by Miguel was related to
`get_event_loop()`.  If you have code that say gets an event loop through
`get_event_loop()`, does some processing, and then *stops* that event loop, that
can cause subsequent tests to fail if they also use `get_event_loop()`.

For example:

```python
def thing_im_testing(some_argument):
    loop = get_event_loop()
    result = loop.run_until_complete(some_coroutine(some_argument))
    return result

def test_the_thing():
    loop = get_event_loop()

    result = thing_im_testing("some value")

    loop.stop()
    loop.close()

def test_the_thing_a_different_way():
    result = thing_im_testing("some value")
```

This is contrived, but sometimes `test_the_thing_a_different_way()` will pass,
and sometimes it will fail depending on the order the tests were run.  Generally
speaking having test order matter is an anti-pattern and a strong indicator of a
bad test.

Best practice: use a fixture or setup/teardown to create a fresh event loop with
a call to `new_event_loop()` *per test* to ensure tests do their async stuff in
isolation.

## It Is a Complex Beast

There's a now rather famous post by [Armin
Ronacher](http://lucumr.pocoo.org/about/) (the guy who created
[Flask](http://flask.pocoo.org/), [Jinja](http://jinja.pocoo.org/), and so many
other seminal Python projects) talking about the complexities of `asyncio`.
It's an extremely well-written and sobering post from someone who's been in at
the core of the Python community for a long time now.  Give it a read at:
<http://lucumr.pocoo.org/2016/10/30/i-dont-understand-asyncio/>

It's worth noting that that post was written pre-Python 3.6, but after Python 3.5
(when `async`/`await` were introduced).

Thus far for me I'd echo a similar sentiment about `asyncio`, for trivial toy
examples it makes sense.  For example, if I have a function that needs to hit 3
separate REST API endpoints, it's really easy to use `asyncio` to make those
calls into coroutines, and execute them concurrently with a
`run_until_complete()` saving some time and avoiding the overhead of
threads/processes. Having said that, once you get past the little toy examples,
figuring out all the subtle differences in the various methods across
`AbstractEventLoop`s, the `asyncio` module, `Future`s, `Task`s, etc, it gets
really heavy really fast from a cognitive load point of view.

This is already one of my longest posts, and I barely scratched the surface, I
didn't talk at all (or even start looking into)
[protocols or transports](https://docs.python.org/3/library/asyncio-protocol.html),
or [streams](https://docs.python.org/3/library/asyncio-stream.html).  I also didn't
get into how the async aspect of the library tends to "leak" all throughout your
code, which (going back to the testing issue) can be a real impediment to forward
progress.

Like Armin said, "It's hard to comprehend how it works in all details. When you can
pass a generator, when it has to be a real coroutine, what futures are, what tasks
are, how the loop works and that did not even come to the actual IO part."  There's
real promise with `asyncio`, but the complexity cost of using it currently is
extremely high.
