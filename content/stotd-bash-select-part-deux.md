Title: Shell Tip Of the Day - Interactively Deleting Docker Images
Date: 2018-06-08 18:52
Modified: 2018-06-08 18:52
Category: Posts
tags: bash,shell,shellTipOfTheDay,git
cover: static/imgs/logos/Gnu-bash-logo-crunch.png
summary: Shell Tip Of the Day - Interactively deleting Docker images with Bash's select statement

![Sometimes when you learn about a hammer, everything looks like a nail....]
({static}/static/imgs/hammer_nail.jpg)

([source](https://devrant.com/rants/752222/if-all-you-have-is-a-hammer-everything-looks-like-a-nail-this-was-something-whic))

Sometimes when you learn about a hammer, everything looks like a nail....  In
[a previous tip]({filename}/stotd-select-untracked-files.md) I showed off using
Bash's `select` statement to interactively select untracked files in a Git repo.

Today I found another use for the `select` statement -- deleting local Docker
images.

I often will build various Docker images on my machine, and then want to delete
selected ones later.  In the past, what I'd do is list all images:

```shell
$ docker images
REPOSITORY                    TAG                 IMAGE ID            CREATED             SIZE
my-project                    latest              2d0ff261164e        6 hours ago         229MB
ubuntu                        16.04               c9d990395902        8 weeks ago         113MB
nginx                         1.13.11-alpine      2dea9e73d89e        2 months ago        18MB
ruby                          2.3                 9cc35bb87070        2 months ago        723MB
```

And then copy the `IMAGE ID` and delete it:

```shell
$ docker rmi 2d0ff261164e
Untagged: my-project:latest
Deleted: sha256:2d0ff261164e6caf1024f67e702652ccad040b3031bc56c829d810b3e4a3f72b
Deleted: sha256:0144bb04af73ca7e66420954ef1ebd0355739d932e2b3ce4f0d4e852f1e2cb28
Deleted: sha256:798362db6603c5f680029cfd8ec614cb2a4d7a321a28d222b26a4eb8597371b1
```

If you have many though this is a lot of tedious copy & pasting.  I don't want to
delete *all* images though, just _selected_ ones.  Enter the `select` statement:

```shell
select x in `docker images --format '{{.ID}}--{{.Repository}}/{{.Tag}}'` ; do docker rmi `echo $x | awk -F'--' '{print $1}'`; done
```

Quick dissection: `docker images --format '{{.ID}}--{{.Repository}}/{{.Tag}}'` will
output the list of local Docker images with their ID, followed by two dashes, followed
by the repository, followed by a slash, followed by the tag.  Ie:

```shell
$ docker images --format '{{.ID}}--{{.Repository}}/{{.Tag}}'
18bfe820e13a--microsoft/dotnet/1.1-sdk
c9d990395902--ubuntu/16.04
2dea9e73d89e--nginx/1.13.11-alpine
9cc35bb87070--ruby/2.3
24ed1c575f81--nginx/1.12-alpine
24ed1c575f81--nginx/1.12.2-alpine
c7fc7faf8c28--alpine/3.4
3fd9065eaf02--alpine/3.7
3fd9065eaf02--alpine/latest
cb178ebbf0f2--python/3.6.0-alpine
```

etc.  Now we `select` over this output and this displays a menu of them all:

```shell
$ select x in `docker images --format '{{.ID}}--{{.Repository}}/{{.Tag}}'` ; do echo "$x" ; done
1) 18bfe820e13a--microsoft/dotnet/1.1-sdk    6) 24ed1c575f81--nginx/1.12.2-alpine
2) c9d990395902--ubuntu/16.04                7) c7fc7faf8c28--alpine/3.4
3) 2dea9e73d89e--nginx/1.13.11-alpine        8) 3fd9065eaf02--alpine/3.7
4) 9cc35bb87070--ruby/2.3                    9) 3fd9065eaf02--alpine/latest
5) 24ed1c575f81--nginx/1.12-alpine          10) cb178ebbf0f2--python/3.6.0-alpine
#?
```

However, we can't just do a `docker rmi $x` on a selected item as `docker rmi`
takes an id, not an id followed by two dashes, followed by the image name.  However,
the argument we need to delete is everything preceding the double-dash.  `awk` to
the rescue:

```shell
select x in `docker images --format '{{.ID}}--{{.Repository}}/{{.Tag}}'` ;
do
    docker rmi `echo $x | awk -F'--' '{print $1}'` ;
done
```

Dissecting the clunky argument to `docker rmi`: `awk -F'--' '{print $1}'` splits
the input string on a double dash and then prints just the first column (the ID
in our case).  We then just echo it back to `docker rmi`.  This works, and I
tweeted it at Eric Promislow who was the person who demoed
[the select statement at Polyglot this year]({filename}polyglotconf-2018.md)
which was where I first saw the trick:

<!-- markdownlint-disable MD033 -->
<blockquote class="twitter-tweet" data-lang="en"><p lang="en" dir="ltr">
<a href="https://twitter.com/ericpromislow?ref_src=twsrc%5Etfw">@ericpromislow</a>
I saw your presentation at <a href="https://twitter.com/PolyglotConf?ref_src=twsrc%5Etfw">@PolyglotConf</a>
about bash &amp; today used the bash select statement I saw there for interactively deleting local Docker
images: <a href="https://t.co/imJV5WA3cB">https://t.co/imJV5WA3cB</a>  Thanks for the tip, super-useful!</p>
&mdash; Codependent Codr (@CodependentCodr)
<a href="https://twitter.com/CodependentCodr/status/1005153068046954496?ref_src=twsrc%5Etfw">June 8, 2018</a>
</blockquote>
<script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>
<!-- markdownlint-enable MD033 -->

And they replied with a nice simplification of the clunky awk stuff:

```shell
select x in `docker images --format '{{.ID}}--{{.Repository}}/{{.Tag}}'` ; do
    docker rmi "${x%--*}";
done
```

Much nicer.  Final version is also in a gist at:
<https://gist.github.com/pzelnip/40da3bf80876c2cdb5809d8a3bd9ee97>
