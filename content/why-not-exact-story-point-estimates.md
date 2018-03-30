Title: Why not exact story point estimates?
Date: 2017-12-12 10:20
tags: agile,scrum,estimation

Awhile back at a job a question was raised in a sprint planning meeting about why we don't do exact story point
estimation, instead of doing the fibonacci (or fibonacci-like) scales. We had scales of 0.25, 0.5, 1, 3, 5, 8, 13, etc
at the place, and people were asking why not "0.75"?

Being a topic I'm quite interested in, I wrote a long email explaining my thoughts on the subject, and now the same
conversation has come up again at my current job. As such I thought it might be useful to share that email with the
world. The following is that email, slightly reworded to be a bit more blog-entry friendly. So "why don't you just use
exact story point estimates"?

I'll reflect the question: "Why do we use story points at all? Why not just estimate in hours?" This is a really good
question, why don't we just say "4 hours" instead of "0.5 SP". If we did that, then we'd no longer have this funny
problem of a ticket that's really 30 minutes having an equivalent estimate to something that takes 2 hours. So if we
did that, then we'd be better off, as we could then start estimating more precisely. Instead of 4 tickets at 0.25 SP
each totalling 1 SP, which means 1 day, we might have 15 minutes + 1 hour + 2 hours + 45 minutes == 4 hours, so if we go
that route then we could pack in even more stuff to a sprint, and get even more stuff done. Right?

Well, not so much. The first problem with time estimates is it makes a fundamentally invalid assumption: that all
developers are created equal. A senior dev & a junior dev might agree entirely on what exactly needs to be done to
complete a task, but I can pretty much guarantee that it'll take the senior dev less time than the junior (regardless of
task). So if we estimate in time units then suddenly we have this problem of do you estimate to the level of the person
who's really experienced, or to the junior person? A fibonacci style sequence of "bucket sizes" (like 0.25, 0.5, 1, 2,
5, etc) helps with this (if it takes the junior 9 hours, and a senior 5, then the SP estimate will likely be the same --
1). (Mike Cohn, the Scrum Alliance guy, has a few blog posts on Story points to this effect, see
[this](https://www.mountaingoatsoftware.com/blog/the-main-benefit-of-story-points) and
[this](https://www.mountaingoatsoftware.com/blog/dont-equate-story-points-to-hours))

So that's one problem with exact time estimates, but there's a bigger one: behavioural psychology. There's actually a
lot of research that's been done in behavioural psych that shows that while people are really good at *relative*
estimating, they are terrible at *exact* estimating, particularly in a domain where there is a lot of uncertainty, or a
lack of repetition (like software development, where you're often asked to do things or work with technologies you've
never done or used before).

I'll give you an analogy (this was the same example that a former scrum master of mine used with me): say I pointed at
two buildings, one that was 50 ft tall and one that was 97ft tall and said "about how much bigger is the second one to
the first?" You'd look at them, and even with no knowledge of carpentry, architecture, civil engineering, etc, you'd
probably be able to say with a high degree of confidence that the second is about twice as big and you'd be pretty darn
close. Now let's say I asked "how many feet taller is the second building compared to the first?" Now, maybe if you're
really experienced at knowing the hights of buildings, you'll be able to come up with a number that's close to the
actual difference, but I sure wouldn't, in fact I'd probably get hung up on being "perfect" with the estimate and end up
spending a disproportionate amount of time "estimating". That's relative sizing vs exact sizing, and we're wired such
that we're good at the former, but not so much at the latter.

Now lets take the story even further. Lets say I point at two buildings and one is 50 ft tall and the other is 600 feet
tall (12 times bigger). Now let's say I ask you the same relative sizing question. Suddenly because the magnitude of
difference is so high it becomes more difficult to do the relative estimating, but you might say "10 times bigger" and
you'd be not far off. But the real question: does it matter (when the difference is so great) that you're off slightly
with that estimate? Probably not, and that's why with SP estimates the scale is usually fibonacci like -- past 5 the
numbers get bigger faster because the relative differences are so huge it's not meaningful to be as precise.

I used to have links to a bunch of research papers talking about this, but have unfortunately since lost them. It's
actually really interesting stuff.

In any case, so pulling it back: that's why we don't do 0.75 SP, because one of the big points of story point estimating
is to do relative estimating. Once we start splitting hairs then there really is no point in doing SP estimates at all,
and instead just estimate everything in hours (which is problematic).
