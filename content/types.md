Title: Types: Let's Rant/Ramble
Date: 2025-01-30 18:53
Modified: 2025-01-30 18:53
Category: Posts
tags:
cover:
summary: "Types" are an important concept in programming, let's collect some thoughts around this topic

Hi, I'm Adam.  You might remember me from years back as someone who called
himself the codependentcodr. Then I disappeared for a few years (!!!) as well,
life just changed.  But recently my therapist encouraged me to find a creative
outlet outside of work.  A place where I could find that ever elusive *flow
state*.  Hence, I thought it time to revisit this blog as an outlet for
expressing my creative self.  We'll see where this goes, if I get back into it
like I did years ago, but at least for now it's just a chance to write.  Also,
is writing about stuff from work really an outlet outside of work? 🤔  But I
digress, let's start writing again.

So, the first question becomes: "Hey Adam, it's been years, what are you going
to write about?"

Hmm, good question.  Traditionally this blog was always "hey I learned something
(usually for work) and now I'll recap what I learned to share the knowledge".  There was a time when
that was not altruistic, like I had this vision of becoming the next
[Wes Bos](https://wesbos.com/)
 or
[Scott Tolinksi](https://tolin.ski/)
, starting my own "Teaching Devs" empire.  But now, I think this
really is just a chance for me to scream (ok, maybe not *scream*, but speak
aloud) into the void and if anyone other than my current self gets something out
of it, hey that's some sweet, sweet icing on that proverbial cake.

So, recently I've been having a few conversations at work with colleagues about
*types*.  You know those little categories we put on variables to indicate what
*range of values* are valid for them. In ye old crusty languages like Java,
types are *strict*.  You can't just write:

```java
myvariable = 42;
```

You gotta tell the dumb compiler what *type* of variable `myvariable` is,
something like so:

```java
int myvariable = 42;
```

There was a time long ago when that seemed like the obvious and completely
necessary thing to do when programming.  Like, computers are dumb, so of course
you have to tell it that this `myvariable` thing is a number, so that if later
some idiot tries to do:

```java
myvariable = "hahaha, this isn't a number at all!";
```

then the *intelligent* compiler will catch that, and tell the idiot who tries to
do that "hey, you're doing it wrong".  This is nice too, because it eliminates a
whole class of possible bugs from your programs, those being *type errors*.

People in ye old crusty languages** will often put on their snooty "I'm better
than you" hat and tell you this is why *strongly typed languages are inherently
superior*.  There was a time I bought that argument, and maybe for some
dimension of "inherently superior" I still do, but mostly I see typing like this
as just one of many things that make some languages more or less useful in some
contexts.

Ok, about now you're probably like "shut up Adam and get to the point".

Most of my day nowadays is spent in Python.  I *love* Python.  It's without a
doubt my favourite language for any one of a million reasons (maybe an
exaggeration, but probably not by much).

As you may know, Python is... *not strongly typed*.  I had a colleague (who's
admittedly not a Pythonista) recently say to me that they felt that Python felt
like the "wild west" when it came to types.  And honestly, that's a fair
assessment.  Historically, or rather famously, Python back in the day was famous
for having a philosophy of "we're all consenting adults", ie if you mess up
types in your program, that's on you.  Not in a mean or off-putting way, but rather in a "lets favour programmer flexibility" way.  There was no real notion of variable
declaration like you'd see in traditional strongly typed languages like (let's
keep picking on) Java.  So in Python you not only can, but *have* to do things
like:

```python
myvariable = 42
```

Look Ma! No types!  And what's really wild you can do absolute madness like
this:

```python
myvariable = 42
if some_function():
    myvariable = "now it's a string!"
```

In here `myvariable` isn't an obvious type.  A Java coder would probably look at
this and go "but how can that possibly work, there's no way the compiler can
know what type of variable `myvariable` is?"  And it can't.  And that's fine.
This *dynamism* is (arguably) Python's hallmark, and a huge secret to its appeal
and success.

These are all trivial dumb examples, but try writing code to deserialize an
arbitrary JSON blob received in a REST API endpoint in Python, and then try it
again in ye old strictly typed language.  In Python you just start slingin'
dicts like a wild madman and *it all just works*.  In ye made up strawman
strictly typed language you're probably going to have to write boilerplate
classes that define the *structure* of those JSON blobs and what fields they
contain, and on and on until you have a rigid *schema* that the compiler can use
to make sense of things.  I've been there, and it's about the least fun kind of
code you can write (maybe though in the world of Copilot, ChatGPT, and `<insert
your favourite AI code generation tool here>`) it's not so onerous.  I dunno as
again, I live in fun happy Python land.

Or rather, fun happy Python land until circa 2014-ish when
[PEP-484](https://peps.python.org/pep-0484/) came along and introduced type
*hints* to the language.

Before I go further I do want to be clear: I think Type Hinting in Python
absolutely has its place in the language.  Any snide commentary that follows
doesn't mean I think we should revert back to the "golden years" when types and
static type checkers like `mypy` weren't a thing, as I don't feel that way at all.

But, let's look at that snippet again, this time with a type hint added:

```python
myvariable: int = 42
```

Woah woah woah, what is that `int` keyword there? And a colon?  SYNTAX?  WHAT IS
THIS, JAVA? 😠

FIXME: some segway here

But, I guarantee you, if you work on a large Python codebase that's worked on by
multiple developers over time you will reach a point where having some type
annotations like this will be *invaluable*.



** - ok, before I get hate mail saying there are modern languages that are
strict too, of course there is, and I realize that, but give me some poetic
liberty here),
