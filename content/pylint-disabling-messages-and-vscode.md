Title: Disabling Pylint Messages
Date: 2018-08-12 15:20
Modified: 2018-08-12 15:20
Category: Posts
tags: python,pylint,vscode
cover: static/imgs/default_page_imagev2.jpg
summary: Showing how to disable specific Pylint warnings.

Small tip of the day since I keep having to look this up.  If you use
[Pylint](https://pylint.org/) for static analysis of your code, you might find
that you'll want to disable a particular rule for a particular line or file.
That is, you don't want to permanently disable this rule, but just for this one
special spot where the rule doesn't make sense.

I find this particularly common in unit test code as my test method names tend
to be long, violating rule C0103 "Name doesn't conform to naming rules".  For
example, a test name might look like:

```python
def test_message_builder_generates_correct_bytestring_when_no_argument_supplied():
```

Which is very self-descriptive, and when that test fails, it makes it much
easier to figure out what might've gone wrong.  The problem is that Pylint will
flag that line since it's greater than 30 characters long, violating the style
guidelines.  We could disable this rule across the entire codebase, but outside
of tests, the rule makes sense.

This is where local disables come in, which take the form of comments:

```python
# pylint disable=C0103
def test_message_builder_generates_correct_bytestring_when_no_argument_supplied():
```

This will suppress code C0103 for the remainder of the scope (module or block),
or until it's re-enabled:

```python
# pylint disable=C0103
def test_message_builder_generates_correct_bytestring_when_no_argument_supplied():


# still disabled here...

# pylint enable=C0103
def but_not_disabled_here_so_this_name_will_get_flagged_by_pylint():
```

You can also (and it's generally better practice) use the "verbose name" for a
particular code rather than the shorthand code.  For example, this is
equivalent:

```python
# pylint disable=invalid-name
def test_message_builder_generates_correct_bytestring_when_no_argument_supplied():
```

A question then becomes  "how do I know what the verbose name for a code is?"
And the answer is to use the `--list-msgs` argument to Pylint on the command
line, and it'll spit them all out:

```shell
$ pylint --list-msgs
:blacklisted-name (C0102): *Black listed name "%s"*
  Used when the name is listed in the black list (unauthorized names).
:invalid-name (C0103): *%s name "%s" doesn't conform to %s*
  Used when the name doesn't conform to naming rules associated to its type
  (constant, variable, class...).
:missing-docstring (C0111): *Missing %s docstring*
  Used when a module, function, class or method has no docstring.Some special
  methods like __init__ doesn't necessary require a docstring.
:empty-docstring (C0112): *Empty %s docstring*
  Used when a module, function, class or method has an empty docstring (it would
  be too easy ;).

... more lines ...
```

One extra tip about Pylint: if you use Visual Studio Code you can turn on Pylint as your linter, and
warnings will get put into the problems view.  To turn it on set the following in your VS Code settings
(assuming you've installed the
[Python extension from Microsoft](https://marketplace.visualstudio.com/items?itemName=ms-python.python)):

```javscript
"python.linting.enabled": true,
"python.linting.pylintEnabled": true,
```

Note that these are both on by default (at least in the current version).  Once you save
a Python file, Pylint warnings will show up in the problems view:

![Pylint Warnings in VS Code Problems View]({filename}/static/imgs/pylint_warnings_in_vscode-crunch.png)

Note that that screenshot also illustrates how you can filter the problems view down to show just Pylint
warnings by entering "pylint" into the search box.  Also note that clicking any of those will open up
that file in VS Code and navigate to the line in question.  Really handy.
