Title: <TITLE GOES HERE>
Date: 2022-01-28 11:09
Modified: 2022-01-28 11:09
Category: Posts
tags: <COMMA SEP TAGS HERE>
cover: static/imgs/default_page_imagev2.jpg
summary: <SUMMARY GOES HERE>
status: draft

There's a [recent Twitter thread from Simon Willison](https://twitter.com/simonw/status/1485700771031117824)
discussion the merits of unit vs integration tests, if the test pyramid still makes sense,
etc.  I saw this tweet and had a knee jerk reaction of "ugh, here's another thread that
villifies the use of unit tests, and talks about how we should all stop using
tiny isolated tests in favour of higher level tests which exercise larger parts
of the systems we work on".  I bet there's even one of those funny "lots of unit tests,
0 integration tests" memes that shows up at some point (spoiler alert:
[there is](https://twitter.com/jwriccardi/status/1485767846777004033)).  Brian Okken
even did a [Test & Code episode](https://testandcode.com/177) on the subject after being inspired
by the Twitter thread (side note: it's a great discussion you all should give it a listen).

I've traditionally been very rooted in the "lots of unit tests" philosophy.  The
[test pyramid](https://martinfowler.com/bliki/TestPyramid.html)
resonates with me (and always has).  That's not to say I don't think "integration"
tests are important (spoiler: they are important and you need them).  As such whenever
I see conversations around the unit vs integration vs system vs functional vs UI vs
`<insert your favourite test category here>` division, I tend to hear the same
(often unconvincing) arguments and get sad about the state of software development today.

But then I took a step back and thought about it some more, and I think really the better
conversation to have is not "should I write unit tests or integration tests? how many of each
should I have?  Should I write more of `<type a>` or `<type b>`?", but rather to think about
"what are the desirable properties my tests and test suites should have?"

This is very similar to what Kent Beck talks
about with his [Test Desiderata](https://medium.com/@kentbeck_7670/test-desiderata-94150638a4b3).
If you've never seen that link before, please stop what you're doing and go read it.  Right now.
It is in my option one of the absolute best articles I've read that has shaped my thinking around
automated testing.

So instead of asking "would I rather work on a project which has more
integration tests than unit tests?" (which almost always results in one side
defining unit tests one way and the other defining that term slighly
differently, but the two sides failing to realize that fact and suddenly straw
man arguments ensue), let's ask some different questions.  It's worth noting
none of these are absolutes, everything is an "it depends" and lives on a
spectrum, but (much like the [agile manifesto](https://agilemanifesto.org/)) one
can have preferences.

## Would You Rather Have Lots Of Fast Tests or A Few Slow Tests?

Put another way, which situation would you rather find yourself in: a project with 2000
tests that can execute in ~20 seconds, or a project with 500 tests that takes 20 minutes
to execute?  Full disclosure: I've worked on both, I worked on a Django-based microservce
that had over 2000 tests, and the rough ballpark time to execute those was 20-30 seconds.
I've also worked on a project with ~1500 tests that takes well over an hour to execute them
all in sequence.

Fast test suites help you make changes quickly.  If you can make a change, hit a hotkey
and 20 seconds later have confidence that you haven't broken anything, that's a really
great place to be as it enables experimentation with implementation.

As such I personally value faster over slower both in individual tests, and most
especially in test suites.  A good compromise I've seen is to break a test suite up into
categories of tests (like "fast" and "slow") and then use things like
[Pytest marks](https://docs.pytest.org/en/6.2.x/mark.html) to make it easy to run a
specific subset (like just run the fast ones).

Some related discussions about this:

* Kent Beck's Desiderata calls fast out specifically (though is a little sparse
  on the "why"):
  <https://medium.com/@kentbeck_7670/test-desiderata-94150638a4b3>
* "fast" is the F in the FIRST acronym: <https://hackernoon.com/test-f-i-r-s-t-65e42f3adc17>
* "FIRST" and the "fast" aspect of it is also discussed in [Bob Martin's Clean
  Code](https://www.amazon.ca/Clean-Code-Handbook-Software-Craftsmanship/dp/0132350882)
  (chapter 9 -- unit tests).  The book cites "Object Mentor Training Materials" as being
  the source of the "FIRST" acronym.
* Gary Bernhardt (the founder of [Destroy All
  Software](https://www.destroyallsoftware.com/)) gave an excellent talk at
  Pycon 2012 talking about the benefits of fast tests:
  <https://www.youtube.com/watch?v=RAxiiRPHS9k>
* Tim Bray wrote about the importance of testing in the current decade, and also
  calls out the importance of fast tests:
  <https://www.tbray.org/ongoing/When/202x/2021/05/15/Testing-in-2021>

pytho
If you have function A which calls function B which calls function C which calls function D, and there's a bug in function D,
to address this bug do you write a test that calls function A or a test which calls function D?
On the surface in this abstract setup I think most people would say "function D of course because that's where
the bug is", yet, that's exactly what you're not doing when you test at a high (for lack of a better word
"integration") level.  Let's replace "function A" with "the `/books/<id>` view method in our REST API".  Still think we
should test at the low level function D point, or should we test at the API level since
customers/clients interact with the system at that level?

It's a thought experiment worth having.  If you write a test at just function D, then you
have the benefit of being able to directly exercise the part of code which contains
the flaw.  If you test at the API view method level, then now you have to figure out a way
to cause that view method to call function B in such a way that it calls function C in such
a way that when it calls function D it exercises the bug.  Sometimes that's obvious on how
to do it (example: if the discovery of the bug came out of a bug report from a customer, they
probably reported the bug by calling the public API endpoint in a way that triggered this
issue).  Sometimes though (arguably oftentimes in large systems) it's not obvious how to trigger
this code path. Maybe it depends on a complex sequence of interactions with the system that
is difficult to reproduce, maybe it only happens at certain times of day, or maybe it's not at
all obvious if it's even possible for an input at the API level to ultimately trigger the bug
in function D.

That last point raises something of an existential question: if it's not possible for an end
user to trigger a bug in a low level function, do you care?  Is the bug even a bug at that
point?  Certainly this fact factors into the *priority* or *importance* you might give to
fixing the bug (if you have a bug that most definitely affects customers and a bug which only
hypothetically could affect customers, obviously you fix the one which directly affects customers
first).  But priority aside, does a bug that you know exists but it's not obvious that it
can affect or impact end users matter?





These aren't absolutes, we might weigh these preferences differently on different projects
and that's okay (ex: if a project is 20 years old and has a million lines of code, "fast" might
mean "a half hour" rather than "seconds").
There is no one right way to test.  What is useful though is being
consciously deliberate about identifying which values make sense for the project (and team).
Digging in one's heels and saying ["unit testing is overrated"](https://news.ycombinator.com/item?id=23778878)
isn't helpful or productive. Saying "unit tests don't give me confidence that the entire system as a whole works as
expected" however is useful.  A statement like that raises the question "why not?" or "what's lacking?"
which in turn forces you to think about what's missing from your current approach and how you
might improve it.  Maybe you're right and super targetted, fast, isolated tests don't give you what
you want from your test suite.  Or maybe, just maybe, you're just doing them in a suboptimal way.
