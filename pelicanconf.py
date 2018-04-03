#!/usr/bin/env python
# -*- coding: utf-8 -*- #

"""Development config for project
"""

from __future__ import unicode_literals
from datetime import datetime

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
# LINKS = (('github', 'https://github.com/pzelnip'),
#          ('Twitter', 'https://twitter.com/codependentcodr'),
#          ('StackOverflow', 'http://stackoverflow.com/users/808804'),
#          ('LinkedIn', 'http://lnkd.in/ykHQiG'),
#          )

# Social widget
SOCIAL = (('github', 'https://github.com/pzelnip'),
          ('twitter', 'https://twitter.com/codependentcodr'),
          ('stack-overflow', 'http://stackoverflow.com/users/808804'),
          ('linkedin', 'http://lnkd.in/ykHQiG'),
          ('youtube', 'http://youtube.codependentcodr.com'),
         )

DEFAULT_PAGINATION = 10

# Uncomment following line if you want document-relative URLs when developing
#RELATIVE_URLS = True

DEFAULT_CATEGORY = 'Posts'

STATIC_PATHS = ['static']

DISPLAY_CATEGORIES_ON_MENU = False
DISPLAY_PAGES_ON_MENU = False

MENUITEMS = (
    ('Posts', '/category/posts.html'),
    ('Tags', '/tags.html'),
    ('About', '/pages/about.html'),
)

THEME = 'theme/Flex'

# Settings for the Flex theme, see docs at:
# https://github.com/alexandrevicenzi/Flex/wiki/Custom-Settings
SITETITLE = 'The Codependent Codr'
# SITESUBTITLE = 'Foobar'
SITELOGO = '/static/imgs/me.jpg'
SITEDESCRIPTION = 'Random thoughts from a random developer'
BROWSER_COLOR = '#eff3f9'
COPYRIGHT_YEAR = str(datetime.now().year)
CC_LICENSE = {
    'name': 'Creative Commons Attribution-ShareAlike',
    'version': '4.0',
    'slug': 'by-sa'
}
MAIN_MENU = True

GITHUB_CORNER_URL = 'https://github.com/pzelnip/www.codependentcodr.com'
GITHUB_CORNER_BG_COLOR = '#d9411e'
