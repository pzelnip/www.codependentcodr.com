Title: Code Refactor of the Day - Extracting Compound Conditionals
Date: 2018-01-15 10:20
tags: codeRefactorOfTheDay,crotd,refactoring,quality,python
cover: static/imgs/default_page_imagev2.jpg

I'm currently doing the 30-Day Code Quality Challenge (<https://www.codequalitychallenge.com>), and today's exercise was
an interesting one -- extract a compound conditional.

The idea of extracting a compound conditional is it's a refactor to try and improve the readability of code by giving a
name to a complex boolean expression. For example, say you have a block like:

```python
def foo():
    if user.state == "active" and user.birthdate.year >= 1990 and user.birthdate.year < 2000 and user.height_in_inches > 72:
        ... do something
```

Now imagine we refactored it to look like this:

```python
def foo():
    if tall_active_user_born_in_the_90s(user):
        ... do something


def tall_active_user_born_in_the_90s(user):
    return user.state == "active" and user.birthdate.year >= 1990 and user.birthdate.year < 2000 and user.height_in_inches > 72
```

I'd say the latter version of foo() reads much better & is much more self-documenting.
