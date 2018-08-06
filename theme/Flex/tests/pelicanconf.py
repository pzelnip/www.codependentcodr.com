#!/usr/bin/env python
# -*- coding: utf-8 -*- #

from __future__ import unicode_literals

# Optional 'neighbors' plugin adds previous/next post buttons to articles.
PLUGIN_PATHS = ["../plugins"]
PLUGINS = ["i18n_subsites", "neighbors"]

JINJA_ENVIRONMENT = {
    "extensions": ["jinja2.ext.i18n", "jinja2.ext.autoescape", "jinja2.ext.with_"]
}

AUTHOR = "Test"
SITEURL = "http://localhost:8000"
SITENAME = "Test Blog"
SITETITLE = AUTHOR
SITESUBTITLE = "Test"
SITEDESCRIPTION = "%s's Thoughts and Writings" % AUTHOR
SITELOGO = "https://www.example.com/img/profile.png"
FAVICON = SITEURL + "/images/favicon.ico"
BROWSER_COLOR = "#333"

ROBOTS = "index, follow"

THEME = "../"
PATH = "content"
TIMEZONE = "America/Sao_Paulo"
DEFAULT_LANG = "en"
OG_LOCALE = "en_US"

FEED_ALL_ATOM = "feeds/all.atom.xml"
CATEGORY_FEED_ATOM = None
TRANSLATION_FEED_ATOM = None
AUTHOR_FEED_ATOM = None
AUTHOR_FEED_RSS = None

USE_FOLDER_AS_CATEGORY = True
MAIN_MENU = True

LINKS = (("Portfolio", "//alexandrevicenzi.com"),)

SOCIAL = (
    ("linkedin", "https://br.linkedin.com/in/test"),
    ("github", "https://github.com/test"),
    ("google", "https://google.com/+Test"),
    ("rss", "//www.example.com/feeds/all.atom.xml"),
)

MENUITEMS = (
    ("Archives", "/archives.html"),
    ("Categories", "/categories.html"),
    ("Tags", "/tags.html"),
)

CC_LICENSE = {
    "name": "Creative Commons Attribution-ShareAlike",
    "version": "4.0",
    "slug": "by-sa",
}

COPYRIGHT_YEAR = 2016

STATUSCAKE = {"trackid": "test-test", "days": 7, "rumid": 1234}

RELATIVE_URLS = False

FEED_ALL_ATOM = "feeds/all.atom.xml"
CATEGORY_FEED_ATOM = "feeds/%s.atom.xml"

DELETE_OUTPUT_DIRECTORY = False

DEFAULT_PAGINATION = 5
SUMMARY_MAX_LENGTH = 150

DISQUS_SITENAME = "test-test"
GOOGLE_ANALYTICS = "UA-XXXXXX-X"
ADD_THIS_ID = "ra-XX3242XX"

USE_LESS = True
