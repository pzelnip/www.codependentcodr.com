Title: Using namedtuple's to convert dicts to objects
Date: 2023-08-25 15:06
Modified: 2023-08-25 15:06
Category: Posts
tags: python,dict,namedtuple
cover: static/imgs/python-logo-master-v3-TM.png
summary: Quick and dirty way to convert a dict into an object in Python using namedtuple's

A friend shared this with me today and I thought it was pretty neat.  If you have a dict, and
you want to convert it to an object where the object properties are the keys from the dict, and
the values are the values from the dict, you can use a namedtuple to do so.  For example:

```python
>>> some_dict = {"name": "My name", "func" : "my func"}
>>> import namedtuple
>>> SomeClass = namedtuple("SomeClass", some_dict.keys())
>>> as_an_object = SomeClass(**some_dict)
>>> as_an_object.name
'My name'
>>> as_an_object.func
'my func'
```

Won't handle nested dicts (the sub-dicts will still be dicts on the constructed object), but
for a quick and dirty way to convert a dict to an object, this seems pretty handy.

Using the splat operator you can also save a line of code:

```python
>>> as_an_object = namedtuple("SomeClass", some_dict.keys())(**some_dict)
>>> as_an_object
SomeClass(name='My name', func='my func')
```
