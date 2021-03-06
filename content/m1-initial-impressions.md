Title: The Wild World of Apple Silicon
Date: 2021-03-06 10:33
Modified: 2021-03-06 10:33
Category: Posts
tags: apple,m1,apple_silicon,applesilicon
cover: static/imgs/m1small.jpg
summary: A recap of my experience setting up my new M1-powered Macbook Air.

I recently took the plunge and obtained a shiny new M1-powered Macbook Air.  For
those unfamiliar, last year Apple announced that they were now building
machines with a brand new ARM-based architecture, making the switch from the
long-lived x86 Intel architecture.  This brought promises of amazing battery
life, amazing performance, and terrifying compatibility issues.  Now that
I've been living with this machine for a week or two, I thought I'd recap
my experience both setting it up, any gotchas or surprises along the way,
as well as my experiences around how well the new architecture works as
experienced through the lens of a developer.

## Lesson 1: Rosetta Works, But Sucks Battery Like You Wouldn't Believe

Everything I've run through Rosetta has been flawless from a functionality
perspective.  Having said that though: anything run through Rosetta does seem to
suck battery life.  And not just apps that are normally CPU intensive.  For
example: I found that having Dropbox (which doesn't support M1), Itsycal, and
Spectacle constantly running in my menu bar all seemed to have a significant
drain on battery life.  I've since switched from
Dropbox to [Sync](https://www.sync.com/), from Spectacle to
[Rectangle](https://rectangleapp.com/), and have uninstalled Itsycal as
I still haven't found an M1-powered replacement.

## Lesson 2: Which Apps Are M1 Ready is Really Random

So of these, which would you expect are M1 ready right now?

* Slack
* Chrome
* Firefox
* Visual Studio Code
* Sublime Text
* Dropbox
* Docker

If you answered the first three, then kudos to you, though until very recently
(ie within the last week or so) VS Code only had M1 support via Insiders.  It
looks like
[Sublime Text 3 will *never* support M1](https://forum.sublimetext.com/t/apple-silicon-native-build/54775)
and ST4 is still a long ways off, which for a paid product used by *a lot* of
Mac users is truly mind-blowing to me.  The fact that Dropbox still doesn't have
M1 support is just inexcusable at this point (particularly given it's an "always
running" app).  Docker has a preview version that's been out for some time, but
full support still seems like a long ways off.  Side note: I haven't tried the
preview version, and I don't plan on it as there's been mixed reports on how
stable it is (
[a positive take](https://blog.earthly.dev/using-apple-silicon-m1-as-a-cloud-engineer-two-months-in/)
and
[a negative take](https://twitter.com/mkennedy/status/1360318443661107210)
).

## Lesson 3: Homebrew is Ready, but Your Obscure Package Might Not Be

With Homebrew 3.0, the popular package manager is now M1-ready.  I can happily
report that the vast majority of packages I use are M1-native.  I installed
`python3`, `git`, `git-extras`, `bash-completion`, `pyenv`, `pipx`, `starship`,
`the_silver_searcher`, `hugo`, `watch` and a bunch of others without
issue, and all seem to be M1 as reported in Activity Monitor.

So what happens when something isn't?

```shell
$ brew install hadolint

Updating Homebrew...
==> Auto-updated Homebrew!
Updated 1 tap (homebrew/core).
==> New Formulae
bas55                        delve                        geph4                        kotlin-language-server       latino                       libpipeline                  openmodelica                 oras                         sqlancer
==> Updated Formulae
Updated 267 formulae.

Error: hadolint: no bottle available!
You can try to install from source with:
  brew install --build-from-source hadolint
Please note building from source is unsupported. You will encounter build
failures with some formulae. If you experience any issues please create pull
requests instead of asking for help on Homebrew's GitHub, Twitter or any other
official channels.
```

I asked [about this on Github](https://github.com/Homebrew/brew/issues/10744)
and since `hadolint` is built with `ghc` and `ghc` isn't M1 ready (and likely
won't be for some time) you either live without the package, install a separate
Rosetta-based brew installation, or obtain the package from some other means
(in the case of `hadolint` this is what I did: there are
[self-contained binaries on their Github](https://github.com/hadolint/hadolint/releases/tag/v1.23.0),
so I
[threw the latest in my path](https://github.com/hadolint/hadolint/issues/558))

One pro-tip: this site is awesome for seeing if a package you're interested in
is M1-ready or not: <https://doesitarm.com/kind/homebrew/>

## Lesson 4: Homebrew Is Different Now

One minor gotcha I ran into is that Brew installs to a different directory:
`/opt/homebrew`.  If you have scripts (think things like `.bashrc` & the like)
that reference the old brew path they'll have to be tweaked.

## Lesson 5: Instant On is Amazing

This is a minor thing, and honestly I didn't think I'd like it as much as
I do, but M1 Macbooks feature an "instant on" wake up from sleep.  And it
truly is "instant".  Ie before I've completely opened the lid of my MBA
the screen is already on and awaiting input.  This even happens when I have
an external display connected.  Contrast this with my Intel-based Macbook
Pro for work which takes a good 30 seconds to resume from sleep (often
longer if I have external displays connected).

Surprisingly this meant I didn't bother installing
[Amphetamine](https://apps.apple.com/us/app/amphetamine/id937984704?mt=12)
on this machine since there's no point -- I don't care if my M1 Mac falls
asleep as it wakes up so damn fast.

## Lesson 6: Big Sur Is Less Good

This is less dev-orientated, but I really don't like Big Sur.  The new
Notification Center is annoying and just wastes space on my menubar.
Toast notifications look much bigger on screen (so are more jarring).
Lots of little annoyances with it, none of which are dealbreaking, but
if I had my way I'd have Catalina instead of Big Sur on this machine
(alas, not an option).

## In Summary

This machine is awesome.  It's expensive (as all Macs are), but is crazy
fast, and (once you get rid of all your Intel apps) sips battery very
lightly.

Docker is really the only thing that I miss at this point from turning this
into a real dev machine.  Hopefully full M1 support will arrive for that
though I can't help but wonder if Docker will ever be completely compatible
(if you build a Docker image on M1, can you run that image on an Intel
based machine?)
