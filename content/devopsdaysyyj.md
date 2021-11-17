Title: DevopsDays YYJ - Year One
Date: 2018-05-25 17:56
Modified: 2018-05-25 17:56
Category: Posts
tags: devops,conferences,learning
cover: static/imgs/devopsdaysyyj.jpg
summary: I was fortunate enough to attend the inaugural DevOps Days Victoria.  Let's recap what I saw.

This year I was fortunate enough to get to attend the very first
[DevOps days here in beautiful Victoria, BC](https://www.devopsdays.org/events/2018-victoria/welcome/).
I thought I'd write up a quick post on what I saw and some of the reasons why I thought the event was great.

So for those unaware, the [Devops Days conferences](https://www.devopsdays.org/) are held all
around the world and give technical practitioners a place to come together and share stories and lessons
learned in the DevOps space.  This was the first time I was able to attend a DevOps Days event, so going into it I
wasn't really sure what to expect.  The format the event took was to have two sets of talks on various
topics in and around the devops movement.  Everything from deep technical talks about AWS services to
human stories about how to not burn out your employees from on-call rotations.  The full schedule is at
<https://www.devopsdays.org/events/2018-victoria/program/>

Let's give a quick recap of the talks I got to sit in on.

# Talks Attended

## Serverless - Jeffery Grajkowski

Jeff works at a local company here in town called [Giftbit](https://giftbit.com), and has created a
nice little framework for getting an AWS Lambda powered project off the ground.  You can find the repo
at <https://github.com/Giftbit/sam-scaffold>.

Was a nice introduction to a good way to get started with [AWS Lambda](https://aws.amazon.com/lambda/)
If you're thinking about playing with Lambda I'd definitely recommend checking it out as a way of
getting up and running quickly.

Side note, I've met Jeff a few times at social events (notably
[Whisky Orientated Development](https://whiskydev.com/)) which he
co-organizes, and I'd definitely recommend that event as well as it's a lot of fun.

## Taming Infrastructure Workflow at Scale - Anubhav Mishra

Anubhav works for [Hashicorp](https://www.hashicorp.com), well known for many tools in the DevOps
space such as Vagrant, Terraform, Vault, and others.

The talk started with a bit of a history lesson on how operations work has evolved over the last
10 years or so, going from physical servers to virtualization, to the cloud, etc.  They then dove
in to an overview of [Terraform](https://www.terraform.io/) which is a really great tool for provisioning
infrastructure via code.  They then concluded with a quick demo of using Terraform to provision a
webserver in Google Cloud with a DNS entry provisioned in AWS via Route 53.  Simple, but really
was a nice little overview of the kind of stuff that's possible with Terraform.

## Beyond Tools: A Human Approach to DevOps - Eduardo Augusto Alves Camargo

One of the things that I think the best conferences do is to have both talks that have deep
technical insights as well as "human" stories.  Software development & deployment is very much
about both, and unfortunately some events (and attendees) can focus too much on the former at
the expense of the latter.

I think this is why I really enjoyed Eduardo's talk.  Eduardo works for
[Daitan Group](https://www.daitangroup.com)
and they gave a description of their company's journey through DevOps transformation, not from
a tools & automation perspective, but on the perspective of the human focus.  Discussions of
the importance of empathy and communication, the challenges of collaborating with people from
very different cultures, and some of the lessons learned along the way.  Really inspiring,
and I enjoyed it a great deal.

## Distributed Brute Force Login Attack - Peter Locke

Peter, like Jeff who did the Serverless talk earlier in the day, also works at
[Giftbit](https://www.giftbit.com).  In this talk they delved into how they've had to deal with
distributed brute force login attacks where distributed botnets try to attack a login page
with leaked credentials trying to compromise accounts on their service.

Great overview of some of the technical challenges associated with the problem they've faced,
and how they've to date leveraged a number of technologies in AWS (ex:
[Lambda](https://aws.amazon.com/lambda/),
[Athena](https://aws.amazon.com/athena/),
[Cloudfront](https://aws.amazon.com/cloudfront/), etc)
to try and combat it.  Some great discussion afterwards about alternative techniques that
could potentially be used was had.

## Bitrot: A Story of Maintenance Failure - Will Whittaker

This talk was just funny.  Will's been in the industry for some time, and told the story
of a project they were a part of that started in the early 2000's, that they left, and came back
to and saw how the project had devolved in that time.  Lots of humourous, cynical anecdotes
about the horrors of maintaining a system for a long time.

An interesting insight that hadn't occurred to me was a word of caution about how containers,
which are currently sweeping the industry as the (relatively) new hot way of deploying our
applications will likely become a maintenance nightmare years from now.  Interesting stuff.

## Fixing Production in the Hospital

This again was one of the "human-side" talks of the day.  Unfortunately the schedule doesn't
have the speaker's name, and I didn't make a note of it, but the presenter told the story of
how while working at a company as the head of the ops team, was in the hospital for the birth
of their third son when they got a phone call from the CTO telling him that everything was on
fire and they needed to fix it.  Inspiring story of the cost of siloing from a human perspective.
Lots of discussion on techniques they employed to help improve their culture & process over
time (blameless post-mortems, release planning, etc).

# Reflections On The Event

All-in-all, particularly for a first time, DevOps Days YYJ was a great event.  More importantly,
it was great to see the Victoria tech community come together in a day of learning, as while
the Victoria tech scene has grown dramatically in the last few years, and there's a
[thriving Slack group](https://joinyyjtechslack.herokuapp.com/)
there to date haven't been many conference events
here in town ([StartupSlam](https://www.startupslam.io/) being the only other I can think of).

Would definitely recommend the event in the future to anyone in or around the Devops space
in Victoria.

Tomorrow conference season continues for me as I'll be attending the 7th annual
Polyglot Unconference in Vancouver, a favourite event of mine.  I'll likely blog about what
I see there, but you can also read about what I've seen in prior years in my posts from
prior years [here]({filename}/polyglotconf-2012.md) and [here]({filename}/polyglotconf-2017.md).
