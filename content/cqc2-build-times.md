Title: Code Quality Challenge #2 - Reducing Build Times
Date: 2018-08-07 12:51
Modified: 2018-08-07 12:51
Category: Posts
tags: cqc,devops,jenkins
cover: static/imgs/default_page_imagev2.jpg
summary: CQC #2 - Reducing Build Times

## The Challenge

Today's challenge is to look at your project's build time.  How long does it
take to go from code committed to Github or Bitbucket to a built artifact you
know is "green"?  Can you reduce that time while still maintaining the same
level of quality?

Some ideas to look into:

* Is there a small handful of tests that take the majority of the time?  Could they be removed or sped up?
* Could you leverage a tool like Docker to build intermediate images that could save build times?
* Could you parallelize some of your build steps?
* Do you retrieve your 3rd party dependencies over the Internet on each build?
    * Could you take advantage of some sort of local caching?

On the note of local caching: tools like
[Artifactory](https://jfrog.com/artifactory/) or [Devpi for
Python](https://devpi.net/docs/devpi/devpi/latest/+d/quickstart-pypimirror.html)
can help with this)

Give it a go, spend 20 minutes seeing if you can reduce your build times.

## What I Did

On the a project at work, we have a number of steps in our "test" stage of our [Jenkins](https://jenkins.io/) build.
Namely we:

* Run the unit tests
* Run [Pylint](https://pylint.org/) over the code
* Run [Safety](https://github.com/pyupio/safety) over the code
* Run a check for missing database migrations

All of these could be run in parallel.  Having said that, [Pylint](https://pylint.org/) takes about as
long as the other steps combined, so it's the bottleneck.

I tried refactoring our `Jenkinsfile` to do everything except Pylint in one
stream, and Pylint in a parallel stream.  Unfortunately I wasn't able to get it working in the
20 minutes, so this ended up just being some good practice working and learning about
`Jenkinsfile`s.

But, some resources I found on parallelizing Jenkins builds:

* https://jenkins.io/doc/book/pipeline/jenkinsfile/#parallel-execution
* https://stackoverflow.com/questions/46834998/scripted-jenkinsfile-parallel-stage
* https://stackoverflow.com/questions/36872657/running-stages-in-parallel-with-jenkins-workflow-pipeline
* https://www.google.ca/search?q=jenkinsfile+parallel+stages+scripted

## What About You?

Did you try the challenge? How'd it go? Would love to hear any feedback,
comments, or observations. And if you have ideas for future challenges, please
feel free to suggest them!
