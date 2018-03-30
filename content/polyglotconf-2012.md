Title: The Polyglot {UN}Conference 2012
Date: 2012-06-02 05:04
tags: polyglotconf,conferences,learning

This year I was fortunate to be allowed to attend the inaugural [Polyglot UN-Conference](http://www.polyglotconf.com/).
An UN-conference is a unique format that is rather well suited to coding topics whereby attendees suggest and facilitate
fairly open forums on whatever they want to talk or hear about.  It's a very cool idea that has the potential to be
completely awful or absolutely amazing.

I can say with full confidence that Polyglot was very much the latter.  Simply a great event all around.

I managed to get in on five of the talks at the show this year.  I'll do a quit recap of each in turn:

# Go

First up was the [Go](http://www.golang.com/) programming language.  The session started with the facilitator giving a
quick bird's eye view of the language and some of the interesting features that make it unique, and then led into a
group discussion of various thoughts & experiences others had with it.  Honestly before I had showed up to Polyglot I
had kinda dismissed Go as a toy language from Google, but while I never had any "aha!" moments during the session, I
definitely had my curiosity piqued.  Some things I never knew:

<!-- markdownlint-disable MD013 -->

* it's a compiled (statically compiled) language, not interpreted
* syntactically it's a blend of a C/Java style language with what looks an awful lot like Python
* Ken Thompson (who was one of the co-inventors of a little language called C) was one of the initial visionaries for the project.  Interesting stuff.
* Its statically typed, though type declarations are optional (it seems to do some sort of type inference)
* There's no classes and inheritance, instead uses interfaces and composition
* There's a rather substantial standard library.  It's not [PyPI](https://pypi.python.org/pypi), but there's a definite sense of "batteries included".

<!-- markdownlint-enable MD013 -->

I'll definitely be playing around with it a bit, as I want to know more.

# Attracting Developers to Your Platform

A common problem many devs who have open source projects face is how to "inspire" other devs to:
get excited about their project
get others to contribute/spread the word.
Much of the focus of this open session was things we (as owners of projects) should and should not do to facilitate
these goals.  Some topics touched on was how to manage poisonous people, zealots, etc, how to promote your project via
things like talks at conferences, the importance of online presence, creating a sense for developers that support is
visible, responsive, and accessible, and a variety of others.  Unfortunately I don't have any notes from the talk, as
my computer's battery was dead during it. :(

While much of the conversation was interesting from an academic standpoint, as someone who doesn't have any FOSS
projects to get people jazzed about, there wasn't really a lot of takeaway for me here.  This was I think the problem
with it -- it felt too focused on open source.

After an extended lunch (thanks to the extremely slow service at the [Old Spaghetti Factory](http://www.osf.com/)), we
got back to the conference about halfway through the 1PM talks, so I never really got to anything here, instead taking
the time to charge the battery on my netbook & decompress a bit.  At 2PM though I got to:

# Effective Testing Practices

This one was the highlight of the day for me.  The fishbowl session started with an open discussion on acceptance
testing vs user testing, and went from there.  One of the big takeaways for me was [Cucumber](http://cukes.info/) which
I had never seen before but seemed worth exploring.  There was much debate on the use of systems like this that try to
capture business requirements in a semi-structured format.  Some feel that this had value, others not so much.  Much
insightful spirited debate ensued -- until the fire alarm went off and we all had to leave for a bit.  Flame war indeed.

When we got back, an insightful discussion largely surrounding the notion of test coverage ensued.  Some feel that the
artificial number that per-line test coverage gives has the potential for misleading one into a false sense of security.
Others (and I'd say I'm sympathetic to this view) feel that while sure the number is completely meaningless, it provides
a quick and dirty metric for identifying gross shortcomings in your testing.

There were also some rather humourous "horror stories" about testing (or a lack thereof) in industry, and a few comments
that started to really touch on the deep issue of why we test, and what the point of it all is.  It's too bad this
session lost 10-15 minutes due to the fire alarm, as this one was the highlight of the conference for me.

# Big Data

I was lukewarm on this one going in, but none of the other topics at the time really caught my eye.  The open discussion
started with the facilitator soliciting people in the audience to share their experiences with big data.  Most of these
were actually fairly small, anecdotal discussions about the difficulties of working with larger amounts of data with
traditional RDBMS systems.  Partway through an attendee (who is an employee of Amazon) chimed in and gave an intro on
some of the concepts behind true big data (ie Amazon S3) systems.  This was good and bad, while it was great to see
someone with expert knowledge step in and share his insights, it did feel as though the talk moved from "how can we do
big data, what are the challenges associated with it" to "if you need to do big data, you can use Amazon S3 for the backend".

# R and Python

I'm not sure if it was the "end of day and I'm exhausted" factor, or just my lack of interest in scientific computing,
but I pretty much tuned out during this one.  It started off with a demonstration of using
[iPython Notebook](http://ipython.org/) to explore some data set correlating weather with bicycle ridership.  On one
hand, the technology seemed useful, particularly for those who have Matlab/Mathmatica backgrounds, but for me, I lost
interest early.  Two of my coworkers however found it quite interesting.

Last were the closing ceremonies, with a fun and entertaining demonstration of coding by voice in 5 different languages
in ~5 minutes.  This was priceless. :)

On the whole, for being the first one, the conference was quite well run.  Some things I'd have liked to see would've
been to have the online schedule be a bit more accessible.  It was a bit of a hassle to go to Lanyrd, track down the
conference, and hit schedule.  And related to this: the online schedule was out of sync with the printed board, while
we were at lunch we couldn't find out what the talks happening at 1PM were as a result.  Having the online board kept
in sync with the printed board would've been very useful.

Minor hiccups aside, the conference was amazing.  It was incredible value too -- $35 for a days worth of tech talks
with people who know, and love technology and use it to solve problems on a daily basis.  Schedule permitting I have no
doubt I'd attend again in the future.

An interesting idea that was mentioned at the closing ceremonies was to do Vancouver Polyglot meetups every so often.
While I likely won't be able to attend these as I live in Victoria, I really hope this takes hold as it'd be awesome to
see the strong tech community in greater Vancouver grow.

(Note: this post originally appeared on my blogspot blog at: <http://codependentcodr.blogspot.ca/2012/06/polyglot-unconference-2012.html>)
