Title: Fixing a Slow Bash Prompt
Date: 2021-02-01 16:49
Modified: 2021-02-01 16:49
Category: Posts
tags: bash,git,osx,homebrew
cover: static/imgs/default_page_imagev2.jpg
summary: My bash prompt seemed to be slow.  Here's how I fixed it

I recently got a new machine for my new job, and so I'm going through all the
"new machine setup" gotchas.  Since getting it, I've been finding the
shell/terminal has felt really sluggish.  Like I’d hit enter in a terminal and
it’d be 1-2 seconds before the prompt came back allowing me to type anything
again, which makes someone who likes to type a lot of commands in quick
succession get angry. 😠

After a bunch of troubleshooting & reverse engineering I found it came down to
 the `__git_ps1` function that displays your current branch in your bash prompt.
 How slow was it?  Really slow:

``` shell
 λ time __git_ps1
 (mainline)
real	0m1.746s
user	0m0.044s
sys	0m0.079s
```

That’s 1.7 seconds every time I hit enter in a terminal because it gets
evaluated as part of producing my bash prompt.

I thought this was weird, so I did a `git --version` and noticed that I was
running `git version 2.24.3 (Apple Git-128)`.   That is the special “Apple has
built this version for you and installed as part of Xcode command-line tools”
version.

So, I installed git from Homebrew (`brew install git`), which gave be the same
normal version that anyone on any platform would get (just compiled for OSX),
and also gave me a much newer version (2.30.0).  Much faster.  How much faster?
Check it out:

```shell
 λ time __git_ps1
 (mainline)
real	0m0.060s
user	0m0.016s
sys	0m0.026s
```

From 1.7 seconds to 0.06 seconds.  Crazy.  Now my command prompt is nice and
snappy.
