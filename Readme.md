# CodependentCodr - The Source

[![Build Status](https://travis-ci.com/pzelnip/www.codependentcodr.com.svg?branch=master)](https://travis-ci.com/pzelnip/www.codependentcodr.com)

This is the source that powers <https://www.codependentcodr.com>

## Overview

Site is generated using [Pelican](https://getpelican.com), and hosted in [AWS](https://aws.amazon.com/).

## Pelican Tidbits

By in large I just ran the `pelican-quickstart` and have tweaked a few things here and there as I work on the site.
Some of the things I've changed that might be novel:

### Tasks.json

Being a VS Code user, I created a `tasks.json` file which has a handful of tasks for things like starting
the dev server, uploading to S3, etc.

Because of the way the project is set up you need the path to the virtual environment where pelican is installed (you
need to be able to call the `activate` script in the virtual environment before the actual command).
I created a config value in my workspace config for this called `pelican.activatePath`.  This however, does give a
warning in VS Code (since it's an "Unknown configuration setting"), but I can't think of a better way to have the
tasks point at the virtual environment where Pelican is installed.

### Linting

In the Makefile I added targets for running [`markdownlint`](https://github.com/DavidAnson/markdownlint) and
[`pylint`](https://www.pylint.org).  A push to S3 first runs these linters over the stuff in the repo and a non-zero
result stops the deployment.  While not as robust as a proper CI/CD pipeline with Jenkins or such, this is good
enough for my needs and was super quick to set up.

Config for the markdown linter is in `.markdownlint.json`.  For the most part I just added exceptions that were
needed so that Pelican's metadata didn't trigger markdownlint warnings.

For Pylint I don't use any special config (just default out of the box config).

### Dockerfile

To support the linting stuff, rather than enforcing I have the tools installed, I create a Docker image & install
the tools to it.  This means if you want to do the same all you need is Docker, no need for `npm`, etc.

The `clean` target of the `Makefile` also removes any previously built `codependentcodr` images.

### AWS CLI

Instead of `s3cmd` (which is what the generated `Makefile` uses), I changed to use the
[AWS CLI](https://aws.amazon.com/cli/) because A) it's better, and B) I already had it installed.

### Git SHA in Footer

I hacked together some stuff in `pelicanconf.py` to get the git SHA & throw it into a variable.  This
is then displayed in the page footer, which I find useful for sanity checking what revision is running.

### Github Corners Configurable Colour

Flex (the theme I use) has support for [Github Corners](https://github.com/tholman/github-corners),
but the colour isn't configurable.  I modified the theme to use a config value `GITHUB_CORNER_BG_COLOR`
which sets the background colour of the github corners icon (in my config I set it to the same value
as the BG colour of buttons from the theme).

### Deployments & Automation

On a deployment to S3 I automagically tag the current commit with a generated tag that includes
the current date/time, the milliseconds since the epoch, and the Git SHA.  This means that I can
look at the tags page on Github to see a history of deployments.

I also prevent deployments of uncommitted changes.  This is to prevent "oops, I didn't realize
I had edited that file but not committed it" problems (speaking from experience, these can be
fun to figure out).

As well, I throw a notification into a private Slack channel when a deployment happens.  This
probably is silly right now (since I'm the only person deploying), but was fun to set up. :)
This was set up as a basic Slack incoming webhook.  The secret token on the URL I have in an
environment variable.

## Hosting

As mentioned, I have the site set up in AWS.  All the generated content goes into a [S3](https://aws.amazon.com/s3/) bucket,
and then I have a [Cloudfront](https://aws.amazon.com/cloudfront/) distribution in front of that.  I pretty much only
have CF for the purposes of getting an SSL cert in place (I doubt I have many readers around the world, so not like
I need a CDN).  The cert is from AWS Certificate Manager.  Unlike most tutorials (and probably to my detriment), I don't
manage DNS with Route 53, but instead through the registrar I purchased the domain from (<https://namecheap.com>).
