Title: Git Tip of the Day - Committer vs Author
Date: 2021-08-06 11:28
Modified: 2021-08-06 11:28
Category: Posts
tags: git,gitTipOfTheDay
cover: static/imgs/default_page_imagev2.jpg
summary: There's a distinction in git between committer and author. Lets learn about that.

So one thing that has always kinda puzzled me in Git is that when I'd `amend` a
commit, then do a `git log` the timestamp for that commit seemed unchanged even
though I've effectively "rewritten" that commit. I dug into this a bit today and
learned about the distinction between Author and Committer which proved
insightful around this.

The distinction is well summarized in the [Git
docs](https://git-scm.com/book/en/v2/Git-Basics-Viewing-the-Commit-History):

> You may be wondering what the difference is between author and committer. The
> author is the person who originally wrote the work, whereas the committer is
> the person who last applied the work.

So when you `amend` a commit you're updating the `committer` aspects of that
commit and the `author` aspects remain unchanged.  You can see both in Git log
by using the `--format=fuller` argument:

```shell
$ git log --format=fuller
commit 9324ea7390b5c411c5cc050cf80965ce7425887a (HEAD -> foobar)
Author:     Adam Parkin <obfuscated@gmail.com>
AuthorDate: Fri Aug 6 11:37:15 2021 -0700
Commit:     Adam Parkin <obfuscated@gmail.com>
CommitDate: Fri Aug 6 11:37:15 2021 -0700

    Test commit
```

You can see in this that the commit in question was originally authored on
August 6th, 2021 at 11:37AM (PST).  Since this was the initial commit, the
`CommitDate` is the same.  But if we amend that commit & check again we'll see
that the `CommitDate` is updated:

```shell
$ git commit --amend
[foobar 857e2a5] Test commit
 Date: Fri Aug 6 11:37:15 2021 -0700
 1 file changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 content/gtotd-commit-vs-author.md

$ git log --format=fuller
commit 857e2a58ac0fe3c295ab80efe4cf21f42986fcfb (HEAD -> foobar)
Author:     Adam Parkin <obfuscated@gmail.com>
AuthorDate: Fri Aug 6 11:37:15 2021 -0700
Commit:     Adam Parkin <obfuscated@gmail.com>
CommitDate: Fri Aug 6 11:38:34 2021 -0700

    Test commit
```

In this case the amend was also done by me, so the author & committer are the
same.

If you want to update the `AuthorDate` you can do so with the `--date` option to
`git commit`:

```shell
$ git commit --amend --date 'now'
[foobar d45d5f9] Test commit
 Date: Fri Aug 6 11:40:34 2021 -0700
 1 file changed, 0 insertions(+), 0 deletions(-)
 create mode 100644 content/gtotd-commit-vs-author.md

$ git log --format=fuller
commit d45d5f9ea0579b6ea6fb4503a50abbac92a348a4 (HEAD -> foobar)
Author:     Adam Parkin <obfuscated@gmail.com>
AuthorDate: Fri Aug 6 11:40:34 2021 -0700
Commit:     Adam Parkin <obfuscated@gmail.com>
CommitDate: Fri Aug 6 11:40:34 2021 -0700

    Test commit
```

Here we can see that the use of `--date` set both `AuthorDate` and `CommitDate`
to the same value (now).
