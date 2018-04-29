Title: Shell Tip of the Day: Using find and sed For Fun and Profit
Date: 2018-04-29 13:59
Modified: 2018-04-29 13:59
Category: Posts
tags: shellTipOfTheDay,shell,linux
cover: static/imgs/default_page_imagev2.jpg
summary: How to use find and sed to replace a common string across many files in one go
status: published

So I recently was tweaking the `<meta>` HTML tags on my posts to make them a little
nicer for sharing on social media (notably Twitter).  The idea is that if you
add a few specific `<meta>` tags to your HTML pages then if that page is shared on say
Twitter, Twitter will make use of that metadata to render a nice looking tweet
that's more appealing (and therefore more likely to be clicked).  I already
added some Opengraph tags (ie `<meta property='og:...`), but Twitter, because it has to be unique
will make use of some Twitter specific ones.

[This link](https://sproutsocial.com/insights/twitter-cards-guide/) is a good
resource for getting started, and
[this link](https://cards-dev.twitter.com/validator) and
[this link](http://iframely.com/debug) allow you to verify that your tags are
correct once you're done.

That's all fine and good, but there can be a problem.  Twitter will sometimes
cache the image you supply to the `twitter:image` tag, and if it sees a bad
image at that url, will fail to update it even though you fix the image.
[Their advice](https://developer.twitter.com/en/docs/tweets/optimize-with-cards/guides/troubleshooting-cards#refreshing_images)
is to rename the url so it forces a re-index (dumb, but hey, whatevs).

This raises a problem: my image is specified in each post (because I sometimes
change the image for a specific article), so that meant I had to update a bunch
of files that had the line:

```markdown
cover: static/imgs/default_page_image.jpg
```

to the line:

```markdown
cover: static/imgs/default_page_imagev2.jpg
```

I could do this manually, but this is where shell utilities like `find` and
`sed` come in handy.  In the directory containing all my markdown for my posts
I just did:

```shell
find . -name '*.md' -exec sed -i '' s/default_page_image/default_page_imagev2/ {} +
```

And voila, done.
