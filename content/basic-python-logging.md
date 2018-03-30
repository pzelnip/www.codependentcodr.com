Title: Python Tip of the Day - Logging basicConfig
Date: 2018-02-14 10:20
tags: ptotd,pythonTipOfTheDay,logging

Oftentimes you just want to try out something related to logging in the REPL, or in a hacky script.  Wading through the
docs on the logging module is this painful exercise in reading about handlers and formatters and other stuff you don't
care about.

The simplest way to just get the ability to do logging in the REPL:

```python
>>> import logging
>>> import sys
>>> logging.basicConfig(stream=sys.stdout, level=logging.DEBUG)
>>> logging.debug('This is a debug level logging message')
DEBUG:root:This is a debug level logging message
```

Simple as that.
