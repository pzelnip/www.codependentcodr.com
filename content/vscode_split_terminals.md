 Title: Visual Studio Code Tasks and Split Terminals
 Date: 2019-02-10 09:53
 Modified: 2019-02-10 09:53
 Category: Posts
 tags: vscode
 cover: static/imgs/default_page_imagev2.jpg
 summary: The January update of Visual Studio Code has some useful features for working with tasks.

So as a big [Visual Studio Code](https://code.visualstudio.com/) fan, I've long
made use of the [tasks feature](https://code.visualstudio.com/docs/editor/tasks).  The most recent (January 2019, 1.31) update
added a cool new feature related to this that I've been waiting for for some time.  I thought I'd do a little
write up about this and how I use tasks with VS Code, particularly as a Pythonista.

## Task Basics

As a starting point, to give a basic idea of what tasks are, they're effectively little shortcuts to
terminal commands that you can trigger from within VS Code.  They're commonly used for things like
triggering build tasks, or starting up a local dev server, etc.  The thing that makes them nice is
that they can be triggered from the command pallette much like normal VS Code commands.  For example,
when working on this blog, I'll use a task to fire up a local dev server to test out content before
committing/pushing it.  It looks something like this:

<!-- markdownlint-disable MD033 -->
<video autoplay loop controls>
  <source src="/static/vids/vscodetask2.mp4" type="video/mp4">
  <img src="/static/imgs/vscodetask.gif">
</video>
<!-- markdownlint-enable MD033 -->

At this point I can then go to <http://localhost:8000> and see the content I've been working on.
Handy.  To create a task, you open up the command pallette and pick "Tasks: Configure Task" and
you'll be prompted with some default template tasks, or the option to "Create tasks.json file
from template" which gives you total control and is the option I use.

A `tasks.json` file contains a number of JSON blobs which define your tasks.  They look something like:

```javascript
{
    // See https://go.microsoft.com/fwlink/?LinkId=733558
    // for the documentation about the tasks.json format
    "version": "2.0.0",
    "tasks": [
        {
            "label": "Run Server",
            "type": "shell",
            "command": "source $(dirname ${config:python.pythonPath})/activate && make devserver"
        },
    ]
}
```

This is the definition for my run local dev server that I showed in the video.  You can have
as many tasks as you want, the `tasks` property is just a list of these definitions.  The
full list of properties and options are
[in Microsoft's excellent docs](https://code.visualstudio.com/docs/editor/tasks#_custom-tasks).

## Common Python Tasks

So now that we have an idea of what tasks are, what are some of the neat things you can do
with them, particularly from the perspective of a Python developer?  These are some of the
common ones I set up, most of which are [Django](https://www.djangoproject.com/) related,
since much of my day job is working in that framework:

### Running a Dev Server

```javascript
{
    "label": "Run Server",
    "type": "shell",
    "command": "${config:python.pythonPath} manage.py runserver --noreload",
},
```

This is basically the analogy to the task I showed previously, just using Django's
`runserver` command.  One thing to note about this: note that the label is the same
as the one for my blog project.  `tasks.json` files are stored per-project, but one
neat thing is you can assign a hotkey to a given task.  In my `keybindings.json` I
have:

```javascript
{
    "key": "cmd+shift+r",
    "command": "workbench.action.tasks.runTask",
    "args": "Run Server"
},
```

This allows me to start a local dev server by simply hitting a hotkey, and so long
as I name that "start up a local dev environment" task the same on each project,
it's the same keystroke to start up a local dev environment.

### Hitting a Health Check URL

```javascript
{
    "label": "Healthcheck (requires running server)",
    "type": "shell",
    "command": "curl http://127.0.0.1:6100/health"
},
```

Once I have a local server running, it's handy to be able to quickly hit the
[health check](https://microservices.io/patterns/observability/health-check-api.html) url
(you added a health check to your API right?).  Again, this is small, but handy as
it saves me the trouble of tabbing over to a terminal window, typing out the
`curl` command, realizing that this project runs on a different port, going to look
that up, etc, etc, etc.

### Running Unit Tests

```javascript
{
    "label": "Run Unit Tests",
    "type": "shell",
    "group": {
        "kind": "test",
        "isDefault": true
    },
    "command": "${config:python.pythonPath} -m pytest -rxXs --ds=projectname.settings.local_test --random-order"
},
```

Whenever possible I use [pytest](https://pytest.org/) for running my unit tests.  Normally this is
run from the command line as something like `pytest <name of directory containing tests>`.  The
problem though is that pytest gets installed to a virtual environment, so how do I give the full
path to the virtual env without making the task machine specific?  The answer is I run it as a
module and just use the `config:python.pythonPath` variable to reference whatever the current
Python environment is.  The other options are some common ones I feed to pytest, ex the `--ds`
switch is for specifying the `DJANGO_SETTINGS_MODULE` environment variable.  `--random-order`
uses the [Pytest Random Order plugin](https://pypi.org/project/pytest-random-order/) to run the
tests in a random order on each test run (which has discovered bugs in my code/tests).

I also set a hotkey for this task:

```javascript
{
    "key": "shift+cmd+f11",
    "command": "workbench.action.tasks.test"
},
```

This makes use of the `kind` property of the task definition.

### Update Dependencies

```javascript
{
    "label": "Update Python Dependencies",
    "type": "shell",
    "command": "${config:python.pythonPath} -m pip install -r requirements.txt --upgrade && ${config:python.pythonPath} -m pip install -r requirements-dev.txt --upgrade"
},
```

I still use `requirements.txt` files (I really should spend the time to learn
[pipenv](https://github.com/pypa/pipenv), but alas).  With this task I can
quickly update all my project's dependencies.  I also separate out my project's
dependencies and my project's dev dependencies (think things like pytest or
pylint) into separate files.  The reason for this is that I can then let my dev
dependencies "float", and most projects I work on also build a Docker image at
the end of the day, so separating the dependencies allows me to only install the
dependencies needed for running the project into the Docker image, which cuts
down on image size.

### Many Many More

This is just scratching the surface, any time I find myself commonly running commands
in a terminal window on a project, I'll spend the minute or so to turn that into a
VS Code task.

Lastly, one of the key points here is that I do essentially these same tasks on
any project I work on and I just tweak the specific commands for the particular
project.  This creates a common/familiar workflow for me regardless of if it's a
Django project, Flask, or even an entirely different tech (I had a Java project
with a REST API and I created many of the same tasks for that).

## New Tricks

As mentioned, in the January 2019 update they added a new feature related to tasks
that I'm a huge fan of:
[Task Output Split Terminals](https://code.visualstudio.com/updates/v1_31#_task-output-support-split-terminals)

This allows you to have a task spawned into a split terminal window to another (already
running) task.  This is really handy when you have say a task for running the dev
server and another task for say tailing the log file of that server as you can have them
appear side-by-side in the integrated terminal.

This was particularly useful for a project I work on at work where I have a Django-based
server, which speaks to another local dev server via a socket connection.  Previously
I had tasks set up for both of these, and I'd have to fire up each one individually, and
switch between multiple terminal windows to see the output of each.  Now I can have them
show up side by side in one view.  The way this works is by sharing the same `group`
property in the task's `presentation` property:

```javascript
{
    "label": "Run Server",
    "type": "shell",
    "command": "${config:python.pythonPath} manage.py runserver --noreload",
    "presentation": {
        "group": "groupServerStuff"
    }
},
```

All tasks with the same group will open up as another split terminal pane in the same
terminal window.  Very nice.

This got me to thinking though: rather than start each task individually, is there a way
to have tasks "call" or "spawn" other tasks?  And as it turns out there is:

```javascript
{
    "label": "Run Server",
    "dependsOn": [
        "Run TCP Server",
        "Run Django Server",
        "Tail Log File"
    ]
},
{
    "label": "Run Django Server",
    "type": "shell",
    "command": "${config:python.pythonPath} manage.py runserver --noreload",
    "presentation": {
        "group": "groupServerStuff"
    }
},
{
    "label": "Run TCP Server",
    "type": "shell",
    "command": "${config:python.pythonPath} scripts/tcp_server.py",
    "presentation": {
        "group": "groupServerStuff"
    }
},
{
    "label": "Tail Log File",
    "type": "shell",
    "command": "tail -f /tmp/logfile.txt",
    "presentation": {
        "group": "groupServerStuff"
    }
},
```

Check out that `Run Server` task -- it spawns three other tasks I have defined:
"Run Django Server" (which was my previous "Run Server" task), "Run TCP Server"
(the simulated socket server), and "Tail Log File" which just tails the logfile
that Django is logging to.

And of course, because it's called `Run Server` the same hotkey I defined
previously will spawn up a new terminal window split 3-ways with these tasks
running.  All with a single keystroke.  That's pretty powerful stuff!

In any case, I hope this was a useful overview of Tasks in VS Code.  Have you
come up with any creative uses for them?  Lemme know in the comments!
