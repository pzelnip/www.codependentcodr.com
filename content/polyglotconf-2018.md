Title: The 2018 Vancouver Polyglot Unconference
Date: 2018-05-26 07:54
Modified: 2018-05-26 07:54
Category: Posts
tags: polyglotconf,conferences,learning
cover: static/imgs/polyglotconflogo.png
summary: I got to go back yet again for the 7th Annual Polyglot Unconference in Vancouver.  Let's recap.

This year, like many past years (see [here]({filename}/polyglotconf-2012.md) and
[here]({filename}/polyglotconf-2017.md)), I was fortunate enough to be able to make the trip to
YVR for the annual [Polyglot Unconference](https://www.polyglotconf.com).  This event, now
in it's 7th year, has been a favourite of mine for some time as it's a great (and very
affordable) opportunity to network with a bunch of other technologists, hear about new
and different technologies, and just get inspired and excited about the work we do in software
development.  It's "An open space for people who create software and love it".

Like prior years I thought I'd recap what I saw.

# General Themes In Pitches

For those unaware, the format of Polyglot is an unconference, where at the start of the day people
submit "pitches" for topics they'd like to see discussed.  After that, attendees dot vote on the
topics they'd like to see scheduled into timeslots, and the organizers then facilitate the spaces
for those talks to happen. Some of the topics suggested included:

* Jyupiter
* Continuous Integration
* Bash tricks
* CSS
* Design exercise
* Project/Product Management
* Quantum Computing
* Code Review
* Awk: sometimes it's all you need
* Career development
* Moving Application to Redux
* Go Interface Antipatterns
* Scourge of Hybrid APIs
* Supporting Sustaining Community Meetups
* Blockchain
* AWS Lessons Learned
* AWS AWS AWS, what about Azure & GC?
* Home Automation
* How Do you Learn New Programming Languages?
* Current state of PWAs vs Hybrid Apps
* Building Modern Web Apps, module bundling, splitting, CSS loading, etc
* GraphQL - the awkward parts
* Email address & Domain names are non-latin, how to handle?
* Component Libraries, how do?
* Developing Mental Models
* JS with Chris, just the language
* Technical Design Review
* So you thought you were writing fast Scala....
* UI & UX, & event storming
* How to scare away, demoralize everyone in your remote office
* Open source a company project
* Project Management Design
* Designing Learning systems online
* Effective Learning Strategies in the Workplace
* Pair Programming: when to do, not do, how to measure success
* Webassembly
* GDPR Lawsuits, data privacy, legislation, etc
* Unicode
* Software quality
* Software interviewing
* ORMs are evil, but SQL is awesome

Often I find it interesting to sit and listen to the pitches as there tends to be "themes" that
come up that are indicative of trends in the industry.  This year however, was quite different,
the sheer breadth of topics was massive, with very little
in the way of overlapping topics.  Take that as you will, was that reflective of the fact that the
number of technologies employed today is broader than ever, or just coincidence, I don't know.

# Talks I Attended

## One Simple Trick To Make You A Better Developer... Code Review

This was a rather lively and deep discussion on the value of code review facilitated by
[John Boxall](https://twitter.com/johnboxall), in which he started with a short presentation
of his experience going from developer working in isolation to a team, and how looking at
other people's code forced him to learn a ton.  Some of the insights he shared from stuff
they've done at [Mobify](https://www.mobify.com/) included:

### What Things Should Reviewers Look For

* does this change deliver biz value?
    * does this change make sense?
    * is this what we actually want to do?
* does this change work?
    * depending on context, it might be ok for some parts to be incomplete
* is this change maintainable?

This **is an ordered** list.

### How To Give Feedback

* need to create a safe space, reviewer isn't a gatekeeper, review should be collaborative
* give feedback about things that could be done better
* (often ignored) great opportunity to learn, if you do, tell the author!
    * break out the emoji's & giphy's!
* review the code, not the coder
* assume positive intent (developer had good intentions)
* welcoming, considerate, and respectful
* be conscious of the language you're using

### Antipatterns

* PR is too big
    * you get the same amount of feedback regardless of size
    * break into atomic steps, ~300 lines rule of thumb
* Rewrites
    * feedback results in rewrite, should've solicited more early feedback
* No differentiation between blocking & non-blocking feedback
    * "this is blocking for me until this is resolved"
* Blocking disagreements
    * bring in 3rd party to collaborate
    * go talk to that person
    * "synchronous code review"
* Reviewer changes author's code

The presentation then mophed into a lively fishbowl discussion, topics discussed
included:

* One company's process was: 2 approvals, review everything, done within 24 hours
* Ask: does this change create value that offsets the debt that this change creates?
* Challenges with "infrastructure as code" review
* Is CR different for open source? (ex: correctness over expediency/cost reduction)
* The best teams try to complete review within a day
* As author, when you're looking for specific feedback, call it out in the PR
* As reviewer, ask questions
* Sometimes too much responsibility is put on the code review
    * try to catch issues earlier
    * requirements design, design review, etc
* Having a code review "coach", or meta review of the code review process itself
* Static code analysis to help decrease the "nitpickyness" of code reviews
* Use tools to enforce team agreements

Great discussion overall.

## Learning new programming languages; how do

This is a topic right at home at a conference all about "multiple languages" (ie polyglot).  Some
topics discussed included:

* How to balance learning a new language for work vs personal interest vs future employment?
* The value of learning something completely different, languages with different perspectives
* Try to get feedback wherever you can when you're learning a new language
* The difficulty of frameworks getting in the way of learning the language (esp Javascript)
* Related, try to learn without all the bells and whistles first
* Think about and learn that one thing does the language you're learning do differently
* Find a pet project you're familiar with, implement in different language
* How do you know when you are truly "comfortable" in a language?

Much of the discussion in this presentation focussed heavily on language idioms, perhaps to the
detriment of the discussion as a whole.

Interesting reflection: as my career has progressed I've gone from learning a lot of languages
to losing interest in learning languages for the sake of learning them.  I think that's partly
(perhaps largely) because I've reached the point where (call it experience, call it cynicism)
I see the same patterns in languages that I've seen before.  I recall learning functional
programming being a true paradigm shift for me, I recall a similar experience learning OO at
a deep level, but now I find many of the "new" things I see feel more like syntactic sugar
or different ways of expressing the same thing, rather than empowering me to think differently
about problems.

For example, consider
[this article about Kotlin](https://medium.com/@magnus.chatt/why-you-should-totally-switch-to-kotlin-c7bbde9e10d5).
Look at that list of reasons to learn Kotlin, all of those I've seen in other languages, for example
"Java Interoperability" is a feature of languages like Scala and Clojure, "String interpolation" is
something I saw for the first time in Perl years ago, and now is prominent in Python & Ruby.  Type
inference was a hallmark innovation of the ML family of languages, and also appears in C#.  This
isn't intended a criticism of Kotlin (I'm sure it's a perfectly fine language), but is
language design now just a game of shuffling already-seen ideas in different combinations?

In any case, this is more rant than reflection on the event, so let's jump ahead to the next
discussion I was at.

## Developing Mental Models, Helping Developers Build Mental Maps

This talk was a bit... existential.  The talk was pitched by one of the conference organizers
([Saem](https://twitter.com/saemg)) who, as a tech manager, has noticed that often the difference
between highly effective developers and less effective ones is that the former tend to have
greater success developing clear mental models of computation.  Interesting topic, and the
(lively) discussion delved into discussions around learning theory, how people learn and
perceive the world, at what point do you truly "know something", etc.  Some deep, interesting
subject matter, but unfortunately I'm not sure I took many concrete takeaways away from the discussion.

## Home Automation

I went to this one hoping to see a bit of cool or novel applications of home automation.  As
someone who's dabbling into the world of [Alexa](https://www.amazon.com/Amazon-Echo-And-Alexa-Devices)
and devices like [Philips Hue](https://www2.meethue.com/en-us), this is a topic of interest
for me.

As it turned out, the part of the discussion I was around for ended up being more on the geeky
DIY side of things, talking about cheap devices to build out home automation systems.  Less of
interest to me, so I exercised the law of two feet to go to another talk.

## Everything You Wanted To Know About Bash Command Line History But Were Afraid To Try

This was really "fun tricks with Bash".
[The slides](https://docs.google.com/presentation/d/1S3lGp7TVZjZqwnWHUpiAG5a0mS7ZJLdAOIZcw3PeNeE/edit#slide=id.g58b3ab78d_028)
have some great little power tips on cool
stuff you can do with the Bash shell.  Many of these things I'd never seen before, so cool
to see.

For example, a neat trick is to use "bang dollar" to match the last argument
from the last executed command.  Say for example, you're working in a Git repo and have
changed a file.  You might do a `git diff` to see what's changed, and then having sanity
checked the diff, want to add that file to be committed.  You'd do this with something
like:

```bash
git diff some/subdir/containing/somefile.txt
git add some/subdir/containing/somefile.txt
```

But that's a lot of extra typing so you can use "bang dollar" to shorten it:

```bash
git diff some/subdir/containing/somefile.txt
git add !$
```

Much more concise.

Another tip, say you want to convert `foo/bar/baz.png` to `foo/bar/baz.gif` using
[Imagemagick's](http://www.imagemagick.org/) `convert` command:

```bash
convert foo/bar/baz.png foo/bar/baz.gif
```

But again, can shorten with the magic of Bash:

```bash
convert foo/bar/baz.{png,gif}
```

Neat stuff, and the slides are full of little gems like this.  Check them out at:
<https://docs.google.com/presentation/d/1S3lGp7TVZjZqwnWHUpiAG5a0mS7ZJLdAOIZcw3PeNeE/edit#slide=id.g58b3ab78d_028>

## Javascript (or JS For Legal Reasons); What's Going On What's New, But Not About Frameworks

[Chris Nicola](https://twitter.com/chrismnicola), another of the organizers, yearly will do a "Javascript
State of the Union" discussion where the goal is to talk about all the newfangled frameworks
popping up in the JS space.  This year, they changed it up a bit, instead focussing on plain
Javascript the language, rather than the sampling of the new shiny stuff.

One thing he noted was how it seemed odd that the famous
[Javascript the Good Parts book by Doug Crockford](https://www.amazon.ca/JavaScript-Good-Parts-Douglas-Crockford/dp/0596517742)
is widely regarded as one of the best texts on the language, yet seems to be largely
ignored by many framework authors.  With this in mind, he started talking about how his company is
taking a step back and starting to use just plain Javascript like a real programming language, and
to bring all the good software design and engineering principles (SOLID, DRY, reduce coupling, etc)
to their JS work.

Their approach is to treat Javascript more like a functional language than a OO language.  That is,
to decompose units of computation down to tiny functions and use dependency injection via arguments
to those functions to wire up functionality.  This has all the happy benefits you'd expect: code
that's easier to read, to compose, and to test.

As someone who's lived his life in the backend, programming language & software engineering side
of things, this really resonated with me.  One of the troubles I've had with trying to learn JS
is just A) figuring out which framework to start with, B) figure out that framework, and then
C) realize that by the time I've figured that out the framework's now obsolete and none of the
knowledge acquired is transferrable.  I think it might be useful for me to take a step back and
focus on JS just as a plain C-derivative language and approach learning it from that perspective.
Good takeaway for me.

Last gem was a book recommendation, JavaScript Allongé: <https://leanpub.com/javascriptallongesix/read>
Sounded like it was a book that helped his team start on this journey towards stripping JS down
to the bare essentials, so I'll definitely be checking it out.

The discussion at this point moved more to a discussion around using Javascript for distributed
computing, as there was another attendee who was interested in learning more about that space.
This was less of interest/applicability to me, so again, law of two feet to...

## Software Quality, And Why It's Important

Popped into this one a bit late, but this was a roundtable discussion of people talking about
testing, quality, how to test, what to test, what makes for good code, the importance of many
layers of tests (unit, integration, etc), agile practices and their role in quality, etc.
Lots of good discussion.

# Meta Thoughts About The Event

One of the things that impresses me about the event is the fact that each year the organizers
find ways to tweak & improve the event.  This year there were a couple of changes.

## The App

This year rather than just papers on a wall & dot voting, there was an app built by one of the
organizers to allow the dot voting to happen online rather than the mob around the post board.
A screenshot of how it looked while voting was going on is below:

![Dot voting online!]({static}/static/imgs/polyglot2018_app_sm-crunch.png)

It really worked quite well, was much more organized than the paper board, and it made it
much easier to figure out which talk to go to.

## Sharing Is Caring

In the opening presentation there was emphasis put on sharing the space, and not letting people
dominate conversations.  I really appreciated this, as there had definitely been times in prior years
where I saw one person who would dominate or hijack a presentation, at the expense of others.

# Closing Thoughts

As it always is, Polyglot was a great event.  I found this year quite different than previous
years though.  Typically I hear of something I've never heard of before (for example, the first
time I heard of this language called Go was at Polyglot, the first time I heard of the testing
pyramid was at Polyglot, etc).  This year though, there was no new tech or thing I hadn't seen
before that I walked away with as a thing to look into.  I'm not quite sure why that is,
perhaps where I'm at in my career, perhaps the state of the industry (are we maybe finally
slowing down just a smidge?), or just an artifact of the talks I happened to attend.  Still
though a great day of learning and as always I find myself heading back home with my passion
for the craft of software development renewed.

Many thanks to the organizers who continue to put on a phenomenal (and very affordable)
event year after year.  See you all in 2019!
