#!/usr/bin/env python
# -*- coding: utf-8 -*- #

"""Production/publication config for project
"""
# pylint: disable=unused-wildcard-import

from __future__ import unicode_literals
import os
import sys
sys.path.append(os.curdir)
# pylint: disable=wildcard-import,wrong-import-position
from pelicanconf import *
# pylint: enable=wildcard-import,wrong-import-position

# This file is only used if you use `make publish` or
# explicitly specify it as your config file.

SITEURL = 'http://www.codependentcodr.com'
RELATIVE_URLS = False

FEED_ALL_ATOM = 'feeds/all.atom.xml'
CATEGORY_FEED_ATOM = 'feeds/%s.atom.xml'

DELETE_OUTPUT_DIRECTORY = True

# Following items are often useful when publishing

#DISQUS_SITENAME = ""
#GOOGLE_ANALYTICS = ""
