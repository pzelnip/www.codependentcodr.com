Title: Python Tip of the Day - lru_cache
Date: 2020-05-02 09:48
cover: static/imgs/python-logo-master-v3-TM.png
tags: python,pythonTipOfTheDay,functools
cover: static/imgs/python-logo-master-v3-TM.png
Category: Posts
summary: How to use lru_cache for fun and profit
status: published

So one of the most useful and little known modules in the Python standard
library is the [functools
module](https://docs.python.org/3/library/functools.html).  It's full of little
gems that are super useful.  I had a use for one of them the other day
(`lru_cache`) and thought I'd share.

## Setting the Stage

I was writing a script for work that automated the process of creating a JIRA
ticket for our deploys.  While our deployments themselves are mostly automated,
we still require a JIRA ticket get created for auditing & metrics purposes.
This is a very tedious step as it involves doing a diff between two branches to
see what's going to go out in a deploy, tagging the Git SHA with an ID & pushing
that tag to Bitbucket, creating a ticket in JIRA, listing all the items that
were found in the diff, cutting a branch, opening up a PR, etc.

Really boring stuff, and both JIRA & Bitbucket have REST APIs, so can be all
automated.  One little wrinkle is the REST API for JIRA combined with the
requirements we had around these deployment tickets meant multiple calls to JIRA
& Bitbucket.  And of course those API's require authentication.

## First Stab

Wrote a few functions for each of the tasks that were part of creating this
deploy ticket.  For example, had a function for creating a JIRA ticket, had another
function for finding the diff between two branches, etc, etc.  This was fine,
but some of those functions required authentication to speak to the REST API, and I didn't want to
hard-code my JIRA/Bitbucket username & password into my script.

So settled on writing a function to prompt the user for a name & password to
authenticate with:

```python
def jira_rest_api_headers():
    user = input("Enter your JIRA username: ")
    password = getpass()
    credentials = b64encode(f"{user}:{password}".encode("ascii")).decode("ascii")

    return {"Content-type": "application/json", "Authorization": f"Basic {credentials}"}
```

This just prompts the user for a username, and their password (using the
`getpass` function from the [getpass module in the standard
library](https://docs.python.org/3/library/getpass.html)), and then returns the
REST API headers with this credential information (using HTTP basic auth).

Now any place in my script where I had to make a call to the JIRA or Bitbucket
REST API I just first made a call to this function to get the info from the
user.

## That Works, But

This is ok, but again, the script made multiple calls to JIRA & Bitbucket, so
that meant entering your username and password multiple times which was
annoying.

This led me to think "if only there was a way to memoize or cache the result of
that call...." and that led me to `lru_cache` in the standard library.  From [the
docs](https://docs.python.org/3/library/functools.html#functools.lru_cache):

> Decorator to wrap a function with a memoizing callable that saves up to the
> maxsize most recent calls. It can save time when an expensive or I/O bound
> function is periodically called with the same arguments.

Perfect, exactly what I want, now I just throw a decorator on the function:

```python
@lru_cache(maxsize=2)
def jira_rest_api_headers():
    ... same body as before ...
```

And now the first time the function gets called it prompts the user for their
name & password, and every subsequent call to that function it just returns the
same value without prompting the user again.

Beautiful.

This decorator can be used for other things two: think of an expensive function
to calculate some complex value where the function is referentially transparent
(ie has no side effects).  Instead of paying the computational cost on every
call you just slap the decorator on it and voila you only pay the cost for the
first call.  Super handy stuff.
