# CodependentCodr - The Source

[![Build Status](https://travis-ci.com/pzelnip/www.codependentcodr.com.svg?branch=master)](https://travis-ci.com/pzelnip/www.codependentcodr.com)
[![Updates](https://pyup.io/repos/github/pzelnip/www.codependentcodr.com/shield.svg)](https://pyup.io/repos/github/pzelnip/www.codependentcodr.com/)
[![Python 3](https://pyup.io/repos/github/pzelnip/www.codependentcodr.com/python-3-shield.svg)](https://pyup.io/repos/github/pzelnip/www.codependentcodr.com/)

![GitHub tag](https://img.shields.io/github/tag/pzelnip/www.codependentcodr.com.svg)
![GitHub last commit](https://img.shields.io/github/last-commit/pzelnip/www.codependentcodr.com.svg)
![license](https://img.shields.io/github/license/pzelnip/www.codependentcodr.com.svg)

![Uptime Robot status](https://img.shields.io/uptimerobot/status/m780253504-7571416f58db1c6bcc1712ea.svg)
![Uptime Robot ratio (30 days)](https://img.shields.io/uptimerobot/ratio/m780253504-7571416f58db1c6bcc1712ea.svg)

## Vision

Codependent Codr is my personal tech blog where I braindump things I've learned, tips, tricks
and ideas around full-stack development.  The site can be found at <https://www.codependentcodr.com>

## Technical Overview

The site is generated using [Pelican](https://getpelican.com), and hosted in [AWS](https://aws.amazon.com/).
Currently it's a static site in an S3 bucket, served via AWS Cloudfront.

## Pelican Tidbits

By in large I just ran the `pelican-quickstart` and have tweaked a few things here and there as I work on the site.
At this point my `Makefile` has been largely rewritten.  Some of the things I've changed/added/done that might be
novel:

### Tasks.json

Being a [Visual Studio Code](https://code.visualstudio.com/) user, I created a `tasks.json` file which has a
handful of tasks for things like starting the dev server, uploading to S3, etc.

### Deployments And Automation

Currently I use [Travis CI](https://travis-ci.org/) for my CI/CD needs.  Merges to the `master` branch are
automatically deployed to S3 by Travis.  Pull requests are automatically built with a number of checks
(mostly linters) and builds are "failed" on non-zero exit codes.

On a deployment to S3 I automagically tag the current commit with a generated tag that includes
the current date/time, the milliseconds since the epoch, and the Git SHA.  This means that I can
look at the tags page on Github to see a history of deployments.

As well, I throw a notification into a private Slack channel when a deployment happens.  This
probably is silly right now (since I'm the only person deploying), but was fun to set up. :)
This was set up as a basic Slack incoming webhook.  The secret token on the URL I have in an
environment variable.

Lastly, when Travis does a build it produces a Docker image and does the deployment from a running
instance of that Docker image.  After successful deployment that Docker image is uploaded to
[Docker Hub](https://hub.docker.com/).  This allows me to see exactly what was deployed, including
for old deployments.

### Linting

In the Makefile I added targets for running [`markdownlint`](https://github.com/DavidAnson/markdownlint) and
[`pylint`](https://www.pylint.org), and ['pydocstyle'](https://github.com/PyCQA/pydocstyle).

This allows me to run linters over the repository before any deployment.  I currently have a zero-tolerance
policy for linting errors (ie linters must run clean before code can be merged into the `master` branch).

Config for the markdown linter is in `.markdownlint.json`.  For the most part I just added exceptions that were
needed so that Pelican's metadata didn't trigger markdownlint warnings.

For Pylint I don't use any special config (just default out of the box config).

For Pydocstyle, config is in `.pydocstyle`, which currently excludes the rather noisy D401 warning, as well
as excludes the `theme` directory from analysis.

### Dockerfile

To support the linting stuff, rather than enforcing I have the tools installed, I create a Docker image & install
the tools to it.  This means if you want to do the same all you need is Docker, no need for `npm`, etc.

The `clean` target of the `Makefile` also removes any previously built `codependentcodr` images.

### Safety

I also have a Makefile target to run the [Safety](https://github.com/pyupio/safety) tool for checking any
Python dependencies I have for security vulnerabilities.  This is also enforced by my CI pipeline (no merges
if vulnerability found).

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

## Hosting

As mentioned, I have the site set up in AWS.  All the generated content goes into a [S3](https://aws.amazon.com/s3/) bucket,
and then I have a [Cloudfront](https://aws.amazon.com/cloudfront/) distribution in front of that.  I pretty much only
have CF for the purposes of getting an SSL cert in place (I doubt I have many readers around the world, so not like
I need a CDN).  The cert is from AWS Certificate Manager.  Unlike most tutorials (and probably to my detriment), I don't
manage DNS with Route 53, but instead through the registrar I purchased the domain from (<https://namecheap.com>).
