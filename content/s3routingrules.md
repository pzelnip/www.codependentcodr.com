Title: S3 Redirection Rules
Date: 2018-05-07 20:45
Modified: 2018-05-07 20:45
Category: Posts
tags: s3,aws
cover: static/imgs/logos/Storage_AmazonS3_LARGE-fs8.png
summary: How to use S3 redirection rules for simple redirecting to other hosts

So as mentioned in many of my other posts, this site is served via an [S3](http://aws.amazon.com/s3)
bucket.  Recently I decided I'd like to have certain paths off of my domain (www.codependentcodr.com)
be automatically redirected to other URL's that aren't in the S3 bucket.  As a concrete example, I
wanted to be able to set up redirections from `/twitter` to my Twitter account
(<https://www.twitter.com/codependentcodr>).

As a first stab, I created an HTML file with a simple `<meta>` tag to redirect the user to a particular
URL.  This looked something like:

```html
<!DOCTYPE html>
<html lang="en">

<head>
<title>Twitter Redirect</title>
<meta http-equiv="refresh" content="0; url=https://twitter.com/codependentcodr" >

</head>
</html>
```

This was then uploaded to the S3 bucket as `twitter.html`, so going to
<https://www.codependentcodr.com/twitter.html> redirected you to my Twitter page.  Success, but
ugly as:

1. it was `/twitter.html` not `/twitter`
2. it felt really clunky to have a file that existed just to redirect someone

I could get around the first problem by renaming the HTML file to `twitter` instead of `twitter.html`,
but then I'd have to go into S3 after uploading the file and manually set the `Content-Type` to
`text/html` otherwise browsers would see it as a binary file and not interpret it as HTML.

There had to be a better way.  So I reached out to my colleagues in the
[YYJ Tech Slack community](https://joinyyjtechslack.herokuapp.com/) (specifically the #devops channel)
asking if anyone had insights.  I was quickly pointed to
[this page](https://docs.aws.amazon.com/AmazonS3/latest/dev/how-to-page-redirect.html) and specifically
the section on that page titled "Advanced Conditional Redirects".

The idea here is you can write some XML which defines some redirect rules for when a key to an object
in the S3 bucket is requested, but doesn't exist.  As a basic example, say you wanted requests to
`http://whatever.your.bucket.is.called.s3-website.ca-central-1.amazonaws.com/foo` to redirect
to <https://github.com/doge>, you might create a rule like:

```xml
<RoutingRules>
    <RoutingRule>
        <Condition>
            <KeyPrefixEquals>foo</KeyPrefixEquals>
        </Condition>
        <Redirect>
            <HostName>github.com</HostName>
            <ReplaceKeyWith>doge</ReplaceKeyWith>
        </Redirect>
    </RoutingRule>
</RoutingRules>
```

Add this to the Redirection Rules on the properties for your bucket (under Static Website Hosting),
and voila, now going to `/foo` on your bucket sends people to the doge.

The docs outline all the different options that are available, this is just a simple example that
was exactly what I needed.  With this in place I set up the following redirects:

Path | Redirects To | Description
---------|----------|---------
 <https://www.codependentcodr.com/youtube> | <http://youtube.codependentcodr.com> | CNAME that points to my Youtube Channel
 <https://www.codependentcodr.com/twitter> | <http://twitter.com/codependentcodr> | My Twitter profile
 <https://www.codependentcodr.com/stackoverflow> | <http://stackoverflow.com/users/808804> | My Stackoverflow Profile page
 <https://www.codependentcodr.com/github> | <http://github.com/pzelnip> | My Github profile page
 <https://www.codependentcodr.com/linkedin> | <http://lnkd.in/ykHQiG> | The place for recruiters to reach me at 😉

The full set of routing rules that makes these possible is here:

```xml
<RoutingRules>
    <RoutingRule>
        <Condition>
            <KeyPrefixEquals>twitter</KeyPrefixEquals>
        </Condition>
        <Redirect>
            <HostName>www.twitter.com</HostName>
            <ReplaceKeyWith>codependentcodr</ReplaceKeyWith>
        </Redirect>
    </RoutingRule>
    <RoutingRule>
        <Condition>
            <KeyPrefixEquals>youtube</KeyPrefixEquals>
        </Condition>
        <Redirect>
            <HostName>youtube.codependentcodr.com</HostName>
            <ReplaceKeyWith></ReplaceKeyWith>
        </Redirect>
    </RoutingRule>
    <RoutingRule>
        <Condition>
            <KeyPrefixEquals>stackoverflow</KeyPrefixEquals>
        </Condition>
        <Redirect>
            <HostName>stackoverflow.com</HostName>
            <ReplaceKeyWith>/users/808804</ReplaceKeyWith>
        </Redirect>
    </RoutingRule>
    <RoutingRule>
        <Condition>
            <KeyPrefixEquals>github</KeyPrefixEquals>
        </Condition>
        <Redirect>
            <HostName>github.com</HostName>
            <ReplaceKeyWith>/pzelnip</ReplaceKeyWith>
        </Redirect>
    </RoutingRule>
    <RoutingRule>
        <Condition>
            <KeyPrefixEquals>linkedin</KeyPrefixEquals>
        </Condition>
        <Redirect>
            <HostName>lnkd.in</HostName>
            <ReplaceKeyWith>/ykHQiG</ReplaceKeyWith>
        </Redirect>
    </RoutingRule>
</RoutingRules>
```

Easy peasy.  And as you can see from the links in the table, these redirection rules
work going through my Cloudfront distribution attached to my custom domain.
