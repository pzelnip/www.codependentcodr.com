Title: Git bisect And Nose -- Or how to find out who to blame for breaking the build.
Date: 2012-08-03 09:19
tags: git,nose,python,testing
cover: static/imgs/default_page_imagev2.jpg

How did I not ever discover `git bisect` before today?  Git bisect allows you to identify a particular commit which
breaks a build, even after development has continued past that commit.  So for example, say you:

<!-- markdownlint-disable MD013 -->

* Commit some code which (unknowing to you) happens to break the build
* You then (not realizing things have gone sideways) continue on doing commits on stuff you're working on
* You then are about to push your code up to a remote master, so you finally run all those unit tests and realize you broke the build somewhere, but you don't know which commit introduced the problem

<!-- markdownlint-enable MD013 -->

In a typical environment you'd now have a fun period of checking out a previous revision, running the tests, seeing if
that was the commit that broke the build, and continue doing so until you identified the commit that introduced the
failure.  I have experienced this many many times and it is the complete opposite of fun.

If you were smart you might recognize that a binary search would be effective here.  That is, if you know commit (A) is
bad, and commit (B) is good, and there's 10 commits in-between (A) and (B) then you'd checkout the one halfway between
the two, check for the failure, and in doing so eliminate half the possibilities (rather than trying all 10 in succession).

And if you were really smart you'd know that this is exactly what `git bisect` does.  You tell git bisect which commit
you know is good, and which commit you know is bad, then it steps you through the process of stepping through the
commits in-between to identify which commit introduced the failure.

But wait, there's more!  There's also a lesser-known option to `git bisect`.  If you do a
"`git bisect run <somecommand>`" then the process becomes completely automated.  What happens is git runs
`<somecommand>` at each iteration of the bisection, and if the command returns error code 0 it marks that commit as
"good", and if it returns non-zero it marks it as "bad", and then continues the search with no human interaction whatsoever.

How cool is that?

So then the trick becomes "what's the command to use for `<somecommand>`?"  Obviously this is project dependent
(probably whatever command you use to run your unit tests), but for those of us who are sane Python devs we probably use
[Nose](https://github.com/nose-devs/nose) to run our tests.  As an example, I often organize my code as follows:

```shell
project/
     +--- src/
             +--- module1/
             +--- module2/
             +--- test/
```

Where "module1" contains code for a module, "module2" contains code for another module, and "test" contains my unit
tests.  Nose is smart enough that if you tell it to start at "src" it will search all subdirectories for tests and then
run them.  So lets say we know that commit `022ca08` was "bad" (ie the first commit we noticed the problem in) and
commit `"`0b52f0c` was good (it doesn't contain the problem).  We could then do:

```shell
git bisect start 022ca08 0b52f0c --
git bisect run nosetests -w src
```

Then go grab a coffee, come back in a few minutes (assuming your tests don't take forever to run), and git will have
identified the commit between `0b52f0c` and `022ca08` that introduced the failure.  Note that we have to run `git bisect`
from the top of the source tree (in my example the "project" directory) hence we need to tell `nosetests` to look in
src via the `-w` parameter.
