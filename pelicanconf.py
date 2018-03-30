#!/usr/bin/env python
# -*- coding: utf-8 -*- #

"""Development config for project
"""

from __future__ import unicode_literals

AUTHOR = 'Adam Parkin'
SITENAME = 'The Codependent Codr'
SITEURL = 'http://localhost:8000'

PATH = 'content'

TIMEZONE = 'America/Vancouver'

DEFAULT_LANG = 'en'

# Feed generation is usually not desired when developing
FEED_ALL_ATOM = None
CATEGORY_FEED_ATOM = None
TRANSLATION_FEED_ATOM = None
AUTHOR_FEED_ATOM = None
AUTHOR_FEED_RSS = None

# Blogroll
# LINKS = (('Github', 'https://github.com/pzelnip'),
#          ('Twitter', 'https://twitter.com/codependentcodr'),
#          ('StackOverflow', 'http://stackoverflow.com/users/808804'),
#          ('LinkedIn', 'http://lnkd.in/ykHQiG'),
#          )

# Social widget
SOCIAL = (('Github', 'https://github.com/pzelnip'),
          ('Twitter', 'https://twitter.com/codependentcodr'),
          ('StackOverflow', 'http://stackoverflow.com/users/808804'),
          ('LinkedIn', 'http://lnkd.in/ykHQiG'),
         )

DEFAULT_PAGINATION = 10

# Uncomment following line if you want document-relative URLs when developing
#RELATIVE_URLS = True

DEFAULT_CATEGORY = 'Posts'

STATIC_PATHS = ['static']
