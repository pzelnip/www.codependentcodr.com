Title: Pull Requests & Code Review
Date: 2018-05-12 07:45
Modified: 2018-05-12 07:45
Category: Posts
tags: code review,pull request
cover: static/imgs/code_quality_2x.png
summary: A couple links related to pull requests and reviewing them, and things to do and/or avoid.

[![XKCD ‘Code Quality’, copied under CC BY-NC 2.5]({filename}/static/imgs/code_quality_2x.png)
XKCD ‘Code Quality’, copied under CC BY-NC 2.5](https://xkcd.com/1513/)

Today I have a few links related to pull requests and doing code review.  I've definitely
done my fair share of both in my career, and yet I still find it's one of those "soft"
skills that you can always hone & improve.  Many of these links have been around for
awhile, but are definitely worth reading for anyone who has to collaborate in code with
others on a repo.

The first is
[How to Write the Perfect Pull Request from Github](https://blog.github.com/2015-01-21-how-to-write-the-perfect-pull-request/).
This is an overview of good
advice on guidelines around what to do when you open that PR from your forked copy to some
open source project.  Some of the little tips around conventions like the use of `WIP` to
indicate you want some early "20%" feedback, etc.  Unsurprisingly it is a bit geared
towards what you'd see in projects on Github, but generally speaking the advice is
applicable anywhere you have to create pull requests for others to review.

The article
also goes into discussion of how to respectfully both review a PR as well as receive
feedback given. This is worth considering as it's not uncommon for code reviews to become "heated" and/or
toxic.

This leads me to my next link:
[Unlearning Toxic Behaviours In A Code Review Culture](https://medium.freecodecamp.org/unlearning-toxic-behaviors-in-a-code-review-culture-b7c295452a3c)
This is a much more detailed and deep discussion of the little bad habits that many (myself
included) can unfortunately bring to code reviews and have them turn adversarial rather
than collaborative.  One of the things I love about Sandya's article is that it shines a
light on bad habits that are common, particularly amongst experienced developers.  I've
definitely been guilty of passing off opinion as fact as well as bombarding a review with
an avalanche of comments.  As well, she also not only points out some of the "bad" (or
toxic) behaviours but offers constructive practices.  Really, really good stuff.

The last one I have is more lightweight:
[Best Practices for Code Review](https://smartbear.com/learn/code-review/best-practices-for-peer-code-review/)
Not super deep, but a good summary, and I really like the emphasis on not overwhelming
yourself with reviews & recognizing that reviewing code takes a great deal of energy.

With these articles in mind I've both adjusted my habits when I do review as well as when
I put code up for review by others.  I've also tweaked the PR template for the repo for
this blog.
