#!/usr/bin/env python
# -*- coding: utf-8 -*- #

"""Development config for project."""

from __future__ import unicode_literals
from datetime import datetime


import subprocess
import shlex


def get_git_sha():
    """Return the short Git SHA from the current working directory."""
    # shamefully stolen from: https://stackoverflow.com/a/21901260/808804
    args = shlex.split("git rev-parse HEAD")
    return str(subprocess.check_output(args, shell=False), "utf-8").strip()


AUTHOR = "Adam Parkin"
SITENAME = "The Codependent Codr"
SITEURL = "http://localhost:8000"

PATH = "content"

TIMEZONE = "America/Vancouver"

DEFAULT_LANG = "en"

# Feed generation is usually not desired when developing
FEED_ALL_ATOM = None
CATEGORY_FEED_ATOM = None
TRANSLATION_FEED_ATOM = None
AUTHOR_FEED_ATOM = None
AUTHOR_FEED_RSS = None

TWITTER_HANDLE = "codependentcodr"

# Blogroll
# LINKS = (('github', 'https://github.com/pzelnip'),
#          ('Twitter', 'https://twitter.com/codependentcodr'),
#          ('StackOverflow', 'http://stackoverflow.com/users/808804'),
#          ('LinkedIn', 'http://lnkd.in/ykHQiG'),
#          )

# Social widget
SOCIAL = (
    ("github", "https://github.com/pzelnip"),
    ("twitter", f"https://twitter.com/{TWITTER_HANDLE}"),
    ("stack-overflow", "http://stackoverflow.com/users/808804"),
    ("linkedin", "http://lnkd.in/ykHQiG"),
    ("youtube", "http://youtube.codependentcodr.com"),
)

DEFAULT_PAGINATION = 10

# Uncomment following line if you want document-relative URLs when developing
# RELATIVE_URLS = True

DEFAULT_CATEGORY = "Posts"

STATIC_PATHS = ["static"]

DISPLAY_CATEGORIES_ON_MENU = False
DISPLAY_PAGES_ON_MENU = False

MENUITEMS = (
    ("Posts", "/category/posts.html"),
    ("Tags", "/tags.html"),
    ("About", "/pages/about.html"),
    ("Talks", "/pages/talks-ive-given.html"),
)

THEME = "theme/Flex"

# Settings for the Flex theme, see docs at:
# https://github.com/alexandrevicenzi/Flex/wiki/Custom-Settings
SITETITLE = "The Codependent Codr"
SITESUBTITLE = "Confessions of an Impostor"
SITELOGO = "/static/imgs/me4.jpg"
SITEDESCRIPTION = "Random thoughts from a random developer"
BROWSER_COLOR = "#eff3f9"
COPYRIGHT_YEAR = str(datetime.now().year)
CC_LICENSE = {
    "name": "Creative Commons Attribution-ShareAlike",
    "version": "4.0",
    "slug": "by-sa",
}
MAIN_MENU = True

GITHUB_CORNER_URL = "https://github.com/pzelnip/www.codependentcodr.com"
GITHUB_CORNER_BG_COLOR = "#d9411e"

ADD_THIS_ID = "ra-5ac30fba879b9110"

GIT_SHA = get_git_sha()
GIT_SHA_LINK = f"{GITHUB_CORNER_URL}/commit/{GIT_SHA}"

# STATUSCAKE = {'trackid': 'SqJ8yVmHYBFNGvAX2kndbxz3cL6Tp4',
#               'days': 7, 'design': 6, 'rumid': 1234}

STATUS_PAGE_URL = "https://stats.uptimerobot.com/NYJoEuz6w"

# set to False to disable using the hard-coded combined CSS file
COMBINED_CSS = True

DISQUS_SITENAME = "codependentcodr"

MAILCHIMP_SUBFORM_UUID = "ed1e503cf09db80010bf0e7eb"
MAILCHIMP_SUBFORM_LID = "fc0932eb49"
MAILCHIMP_SUBFORM_BASEURL = "mc.us18.list-manage.com"
