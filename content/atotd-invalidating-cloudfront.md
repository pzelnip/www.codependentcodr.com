Title: AWS Tip Of The Day - Invalidating Items in the CloudFront Cache
Date: 2018-04-01 08:14
tags: aws,cloudfront,awstotd,awsTipOfTheDay

TIL today: in [CloudFront](https://aws.amazon.com/cloudfront/), creating an invalidation for `/*.html` is not the same
as creating an invalidation for `/` even though `/` redirects to `/index.html`.

Context: yesterday I set up a CloudFront distribution for this site, so that I could attach an SSL cert to it (more
about this in a future blog post).  However, shortly after setting it all up, going to
<https://www.codependentcodr.com> resulted in an unstyled version of the main page.  Looking at Chrome Dev Tools, I saw
that the request for the CSS was still going to `http://` and resulting in mixed content.

Looking into the source of `index.html` (the main page of the site that you get directed to when going to `/`), sure
enough the source URL for the CSS was in fact `http://` instead of `https://`.  Reason being that I hadn't updated the
`SITEURL` value in my Pelican `publishconf.py` to be `https://`.  Easy change, so did that & redeployed the site to S3.

Still no CSS.

Thought maybe the file didn't get updated in S3, so I manually went into S3 and pulled down `index.html` directly from
the bucket.  Sure enough the source was correct -- `https://` instead of `http://`.

Problem was Cloudfront was still serving the old version of `index.html` with the non-secure URL.  Ok, easy enough,
with some help from a friend I was pointed at
[the docs for invalidating items in Cloudfront's cache](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/Invalidation.html#invalidating-objects-console)
.  Easy enough, create an invalidation for `/*.html`.

Did that, and waited.  And waited.  And waited.  Other pages served fine (since they hadn't been requested before they
were getting the correct `https://` url), but that stubborn main page was still unstyled.  Went to bed & got up the next
day and still the same problem.  Ok, something wrong.

Did some digging and found [this discussion](https://forums.aws.amazon.com/thread.jspa?threadID=263425), which has this
comment a little ways down the first page:

> You need to invalidate what the browser is requesting -- not the file that is actually being served, if it is
different. Your invalidation request should be simply for / instead of /index.html.

Duh.  Added invalidation request for `/` and the homepage started immediately serving the CSS correctly.
