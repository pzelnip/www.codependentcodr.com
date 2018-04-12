Title: Scheduled Builds in Jenkins Scripted Pipelines
Date: 2018-03-20 10:20
tags: jenkins,jenkinsfile,devops
cover: static/imgs/default_page_image.jpg

Sometimes you’ll want to have Jenkins trigger a build on a recurring schedule. Common examples include things like a
scheduled build at midnight (or some other time when regular work isn’t happening).  Traditionally in Jenkins this could
be done on the configuration page for the job in question. You’d find the “Build Periodically” option under Build
Triggers and enter a crontab expression to schedule when Jenkins should trigger a build of the job automatically.  With
pipelines though, that option disappears from the UI, instead you have to create it as code in your Jenkinsfile.

```groovy
properties([pipelineTriggers([cron('H/15 * * * *')])])
```

Put this near the top (ie before a node declaration) of your Jenkinsfile and the job will get built automatically every
15 minutes. It’s worth noting that just making this change isn’t enough, you also have to have a build triggered with
this change in place to schedule the build (which makes sense — changes to Jenkinsfile’s don’t affect jobs until the new
Jenkinsfile is “run” by Jenkins, which doesn’t happen until a build is scheduled, be that by manual build, automatic
trigger from SCM push, etc)
This is fine and easy, but what if you’re using multibranch pipelines?  You’ll likely then want to have different
schedules depending on the branch in question (ex: it’d seem silly to schedule a recurring build of a feature branch)
As it turns out this really isn’t too bad, you just need to inspect the `BRANCH_NAME` variable:

```groovy
def triggers = []

if("$BRANCH_NAME" == 'develop') {
    triggers << cron('H/15 * * * *') // every 15 minutes
} else if("$BRANCH_NAME" == 'master') {
    triggers << cron('H H(0-2) * * *') // daily between midnight & 2 AM
} else {
    // no scheduled build
}

properties (
    [
        pipelineTriggers(triggers)
    ]
)
```

In this we set up two schedules for the project: if the branch is the develop branch, we build it every 15 minutes.  If
the branch is our master branch, we build it every night between midnight and 2AM. If the branch isn’t develop or master
then we don’t schedule any automatic builds. Note that the else block is empty (I could have omitted it entirely), which
means that the triggers for the current branch will be cleared. Side note: this is also how you’d delete a previously
scheduled build for a branch, just clear the line which initializes the crontab schedule and then next time it’s build
the schedule will be cleared.
