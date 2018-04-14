Title: Optimizing Cloudfront
Date: 2018-04-12 19:32
Modified: 2018-04-14 12:24
Category: Posts
tags: atotd,awsTipOfTheDay,cloudfront,aws
cover: static/imgs/aws_cloudfront.png
summary: Lets recap some tips & tricks around optimizing your use of AWS CloudFront as a CDN.

AWS CloudFront is one of the services that AWS gives you that helps you optimize & speed
up delivery of your site's content.  Commonly Cloudfront is used as a Content Delivery
Network (CDN), where the idea is that load for your site is distributed amongst a number
of data centers called *edge locations*.

The idea is you set up your site in some way (be that a dynamic server that serves some content,
an S3 bucket, whatever) and these *origins* will respond to requests from clients.  However, if
a client is physically located far from where that origin is located, then there's certain latency
or overhead that's introduced which slows down the delivery of that content.  The idea of using
Cloudfront as a CDN is instead you create a *distribution* in CloudFront which sits in front of
your origin (or origin(s) depending on your use case), and it automagically mirrors your content
to edge locations all around the world.  When a client makes a request, it goes to the Cloudfront
edge location closest to the client and serves a cached version of the content (if it has seen it
before, if it hasn't, or the cached version is super old, it'll make the request to your origin
and pass that content back to the client).

At its core, this is a simple idea.  But as is the case with much of AWS, there's all sorts of
tweaks and tricks to optimize things.  In this post I'm going to outline some of the things I've
done to optimize my use of Cloudfront for this site.

# CloudFront Basics

Let's walk through some of the basics of Cloudfront.  Keep in mind, I am very much a n00b when
it comes to this stuff, but this is stuff I've figured out as I've worked through setting up
this site.

## Behaviours

When you create a distribution, by default there's a single behaviour that's defined that
determines things like how long an item should remain in Cloudfront's cache before making the
request again to the origin, or if requests should be auto forwarded from http to https, and
various other settings.  The behaviour screen looks something like:

![Cloudfront Behavior]({filename}/static/imgs/cloudfront-behaviour-1.png)

By default, all items for your distribution are governed by the settings on this Default
Behaviour.  What's really cool/handy is you can define multiple behaviours based upon request
path patterns.  So for example, you could say things like:

* all requests for everything under `/static/images` should be cached for a really, really, really long time.
* all requests for top level HTML files should always redirect from HTTP to HTTPS
* all requests for things containing `thisIssupersecure` in the request path should only allow HTTPS (block non-HTTPS)

... and so on.  There's a ton of knobs to tweak.

## Invalidations

Oftentimes you'll want to tell Cloudfront to drop stuff it's cached from your origin(s).  This
is done by what's known as an
[*invalidation*](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/Invalidation.html).
An invalidation effectively says "hey Cloudfront, that thing you're caching has changed, so
go ahead and re-fetch it from the origin".  Much like behaviours you have the ability to specify what
to invalidate by request path (so for example, maybe you only want to invalidate HTML files because
those have been updated, but leave any cached images).

***Important:*** it's worth noting that if you invalidate *everything* in a distribution, that could
potentially put your origin under heavy load.  This is why it can pay to be selective about what you
invalidate.

It's also worth noting that if you create too many invalidations in a period of time, you will be
charged.
[The docs](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/Invalidation.html#PayingForInvalidation)
indicate that at the time of writing you get your first 1,000 invalidations per month for free,
after that you get billed.  As is always the case with AWS, the specific details around billing
get complicated very quickly, but the gist is try to keep the number of invalidations down.

# My Setup

Just to give a bit of context: this site is served as a static website via an S3 bucket that's behind
a single CloudFront distribution (ie the S3 bucket is the only origin for the Cloudfront distribution).

So what have I done?  Let's discuss.

## CNAMEs

Because I have a custom domain and don't want people to have to go to <https://d1c3rffik0endi.cloudfront.net/> to visit
the site, I edited the cloudfront distribution to have two alternate domain names (CNAMEs):

* www.codpendentcodr.com
* codpendentcodr.com

You'll also have to set up DNS entries with whatever you use for DNS to have CNAME
records on your custom domain that point to your Cloudfront url (which is typically
`<whateverYourDistributionIdIs>.cloudfront.net`)

## Redirecting HTTP to HTTPS

[Security is in](https://developers.google.com/web/fundamentals/security/encrypt-in-transit/why-https),
and as such I wanted all requests to my site to be https so I get the pretty green padlock.  As such
one of the first things I did was change the "Viewer Protocol Policy" on the default behaviour to
"Redirect HTTP to HTTPS".  Note that this requires that you have a cert & whatnot set up for your
distribution.  If you haven't done that, I'd recommend you check out
[Ben's awesome guide](https://ben.gnoinski.ca/set-up-acm-ssl-certs-and-domain-validation-with-route53.html)
as it walks through how to use AWS Certificate Manager to get your SSL set up.

## Multiple Behaviours

At first I just had the default behaviour that CF gives you when you
set up the distribution.  This quickly led to a problem that whenever I deployed my site, it meant
the top-level homepage would still be serving the old content until the TTL of the item expired
and Cloudfront went ahead & refetched it.

I could create an invalidation after every time I upload the site, but I didn't like that idea
as A) I was afraid I'd hit that 1,000 invalidation limit (which is unlikely but does create a
perceptual impediment to deploying the site), and B) meant that every time I deployed the site
I'd be throwing away the benefits of the Cloudfront cache regardless of how small the change was.

As well, there really is some content on the site that literally almost never changes and gets
requested on every page load (for example the profile picture in the left nav).

As such I divided up my content and created behaviours for each.

Path | Description | What I tweaked
---------|----------|---------
 `/static/imgs/*` | all static images for the site | Default TTL set to 2 days
 `/theme/*` | All the content for my theme (ex CSS) | Default TTL set to 1 day
 `/` and `/*.html` | All the HTML pages for the site | Default TTL set to 1 hour
 `/feeds/all.atom.xml` | the RSS feed for the site | Allow both HTTP and HTTPS, default TTL to 1 hour
 `*` (default) | everything else | really nothing

Unless otherwise specified, all of those behaviours are set to redirect HTTP to HTTPS.  I allowed
HTTP on the RSS feed largely because it's not intended for human consumption, and I wondered if
there are possibly some weird old RSS readers that don't support HTTPs.  I probably could've/should've
made even this redirect to HTTPS.

## Manual Invalidations

Even with the tweaked behaviours, I still find myself wanting to create invalidations to speed
up refreshes for "dynamic" content.  Taking inspiration from
[Ben again](https://ben.gnoinski.ca/invalidating-cloudfront-cache.html) I set up a command
in my `Makefile` to create an invalidation with a single command (which I also set up in VS Code
as a Task that I can run with a couple keystrokes).  It looks like this:

```shell
aws --profile $(AWSCLI_PROFILE) cloudfront create-invalidation --distribution-id ER3YIY14W87BX --paths '/*.html' '/' '/feeds/all.atom.xml'
```

That is, invalidate all the HTML, the root page, and the RSS feed.  The intention here is whenever
I push new content (like a new blog post), I run this invalidation so that changes get picked up
right away.  Ideally I'd only create an invalidation for stuff that's actually changed, but doing
a diff between what's currently deployed and what's about to be deployed is tricky with
Pelican***.

If I'm doing less content-related stuff (for example, just playing around with some layout or
tweaking the theme), I don't really care if people get the old version for a bit so I just let
the cache expire naturally.

*** - Side note: I've thought about doing this, like essentially before a push to S3 first pull down
whatever's in S3 to my local box, then do a diff between what I pulled down from S3 and what's
in the `output/` directory I'm about to push and then only push & invalidate that stuff
specifically.  Maybe someday....

## Offloading to Other CDNs

One of the things in my theme is it uses [Font Awesome](https://fontawesome.com/) for a few things.
The theme as written includes a minified version of the font-awesome CSS.  It's great that I
have Cloudfront to serve that file, but if you think about it, there are A LOT of sites out there
that have Font Awesome.  And they grab Font Awesome from a global CDN like Cloudflare.  Which means
that if instead of serving Font Awesome myself, I could instead modify my theme to use those CDNs,
since it's far more likely that the widely used CDN will have that content optimized in an edge
location than my Cloudfront distribution.  To give proof of this, I took requests for just the
font-awesome.min.css file from Cloudflare as well as through my Cloudfront distribution and ran them
through [Pingdom's speed test](https://tools.pingdom.com/) (doing tests from Stockholm, Sweden).

Response times for coming from my
distribution started at 67ms then after a couple requests dropped down to ~22ms (presumably the
first request the css wasn't in the CF edge location so it had to hit the origin).  Overall Pingdom
gave the request a grade of "D" because there's a few headers I hadn't tweaked.

Response times for coming from Cloudflare started at around 22ms and fluctuated between 22ms and 30ms
(consistent with the theory that they already had the content cached).  Overall Pingdom gave the request a grade of "A".

Using Cloudflare saves me a fraction of a penny by cutting down on bandwidth charges and means I
can drop the stuff from my bucket which saves another fraction of a penny in storage costs (I'm
not kidding, it's literally fractions of a penny -- S3 & CF are both stupid cheap).  I suppose it
also speeds up deployments of the site by a fraction of a second, since that's a few files I now
no longer have to upload on a deploy to S3.

And there you have it, there's certainly more you can do, and all this is actually super basic
stuff, but it's been fun digging into how to tweak and turn some of the knobs in Cloudfront.
