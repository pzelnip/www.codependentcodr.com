Title: Serverless Microservices and Python (with tests!) - Part 1
Date: 2017-07-27 10:20
tags: lambda,serverless,microservices,aws,python,testing

So I'm currently on holiday and also between jobs (had my last day at old job last week, and first day at new gig is
next week), which means of course what am I doing but spending some time learning some tech that's fun & buzzwordy.

Right now it seems like you can't listen to a tech podcast without hearing "microservices" or "serverless", especially
if you listen to anything with a devops bias. So, why not explore both? I've always wanted to learn a bit more about
[AWS Lambda](https://docs.aws.amazon.com/lambda/latest/dg/welcome.html) and in particular the combination of Lambda with
[AWS API Gateway](https://aws.amazon.com/api-gateway/) to create little microservices that are supremely scalable without
the headache of server maintenance. Did some Googling and
[stumbled across this tutorial](http://dchua.com/2016/03/22/writing-a-serverless-python-microservice-with-aws-lambda-and-aws-api-gateway/)
which seemed like exactly what I was looking for.

So, I worked through the tutorial, and minor hiccups aside, got a simple little password verification microservice up
and running in almost no time at all.  Sweet.

Ok, so for me, when I do tutorials like this, I find I need to build or extend the exercise to help reinforce what I've
learned. Aside from that, one of the questions I have about Lambda projects is how does testing work? Do you still do
unit testing like you would with a regular Python project? Any differences?

So, let's take this example and enhance it with a new requirement -- support
[Bcrypt](https://en.wikipedia.org/wiki/Bcrypt) as a digest.

Now, there's a problem (ok, this is contrived, work with me here): normally before you start adding new functionality
you want to ensure you have a decent set of automated tests to ensure that you don't break existing behaviour. So, step
1: let's add some unit tests that enforce the existing requirements we have in our little Lambda function. I saw these as:

* supports three digests: `SHA1`, `SHA256`, and `SHA512`.
* when given a valid hash for a digest, and the plaintext password that hash was based upon, return `True`
* when given an valid hash for a digest, and a random string (that doesn't match the hash), return `False`

Simple enough. So let's get cracking. First thing I did was start to "project-ize" this code, so that it's more than a
random Python file. This consisted of creating a requirements.txt file to list the dependencies the project uses
(currently only `passlib`), and to move it into a project in my IDE of choice. I like to use
[PyCharm](https://www.jetbrains.com/pycharm/) as my dev environment, so I fired up PyCharm and created a new project
based upon the virtual environment created from the `requirements.txt` file. Next I did a bit of restructuring moving
the source file into a directory called `src` and created a sibling directory called `test`. I like to structure my
Python projects this way, but really this is arbitrary and personal convention more than anything.

With all that in place, I added index_test.py (mirroring the index.py name that was created in the tutorial) and started
backfilling some tests. Note that since `lambda_handler` is just a plain old Python function, unit testing is actually
completely straightforward. A first stab:

```python
import unittest

from index import lambda_handler

class TestLambdaHandler(unittest.TestCase):
    def test_valid_sha256_hash_with_matching_password_returns_true(self):
        event = {
            "digest": "sha256",
            "hash_pass": "$pbkdf2-sha256$29000$.L93bg0BwFiLEaL0fm8NIQ$yYmxiSuP9pXXbrO4cT6CkE1QaNKpt8PjugrgvOBfcRY",
            "password": "password"
        }
        expected = True

        result = lambda_handler(event, None)

        self.assertEqual(expected, result)

    def test_valid_sha256_hash_with_wrong_password_returns_false(self):
        event = {
            "digest": "sha256",
            "hash_pass": "$pbkdf2-sha256$29000$.L93bg0BwFiLEaL0fm8NIQ$yYmxiSuP9pXXbrO4cT6CkE1QaNKpt8PjugrgvOBfcRY",
            "password": "this is not the password"
        }
        expected = False

        result = lambda_handler(event, None)

        self.assertEqual(expected, result)
```

Again, all straightforward stuff. My style of test writing is to follow the
[Arrange, Act, Assert pattern](http://wiki.c2.com/?ArrangeActAssert), as I find this helps with readability. In terms of
running them, I personally just ran these with the default test runner from within PyCharm, but there's nothing magical
here, so you could just as easily run them with your favourite runner (be it
[Nose](http://nose.readthedocs.io/en/latest/),
[py.test](https://docs.pytest.org/en/latest/) or whatever).

As is usually the case with writing tests, you start to find duplication and simplify. In both of these the event
declaration is a bit verbose, so lets break it into a helper, and add some tests for other digests:

```python
import unittest

from index import lambda_handler

SAMPLE_PASSWORD = 'password'
SAMPLE_SHA512_HASH = '$pbkdf2-sha512$25000$ltLae69VihFirDVGSOmdUw$pcLVv3Vnm3XRx9aHNUgI1FQaF8.UmKHBYt.Hs2EI7at/V80kbsb2P1A2t9akjNom8ZUgVJ4AcbA5vk/7QTgEJQ'
SAMPLE_SHA256_HASH = '$pbkdf2-sha256$29000$.L93bg0BwFiLEaL0fm8NIQ$yYmxiSuP9pXXbrO4cT6CkE1QaNKpt8PjugrgvOBfcRY'

class TestLambdaHandler(unittest.TestCase):
    def test_valid_sha256_hash_with_matching_password_returns_true(self):
        event = _build_event('sha256', SAMPLE_SHA256_HASH, SAMPLE_PASSWORD)
        expected = True

        result = lambda_handler(event, None)

        self.assertEqual(expected, result)

    def test_valid_sha256_hash_with_wrong_password_returns_false(self):
        event = _build_event('sha256', SAMPLE_SHA256_HASH, 'this is not the password')
        expected = False

        result = lambda_handler(event, None)

        self.assertEqual(expected, result)

    def test_valid_sha512_hash_with_matching_password_returns_true(self):
        event = _build_event('sha512', SAMPLE_SHA512_HASH, SAMPLE_PASSWORD)
        expected = True

        result = lambda_handler(event, None)

        self.assertEqual(expected, result)

    def test_valid_sha512_hash_with_wrong_password_returns_false(self):
        event = _build_event('sha512', SAMPLE_SHA512_HASH, 'this is not the password')
        expected = False

        result = lambda_handler(event, None)

        self.assertEqual(expected, result)

def _build_event(digest, hash_pass, password):
    return {
        "digest": digest,
        "hash_pass": hash_pass,
        "password": password,
    }
```

Astute readers will recognize that this is a classic example of tests which lend themselves to
[py.test's parameterized tests](https://docs.pytest.org/en/latest/example/parametrize.html).
I leave the work of converting these to parameterized tests as an exercise for the reader. :)

Continuing along, you reach a point where you start to observe behaviour that's implicit in the code as it exists today,
but which is unclear if it's required or just an accident. For example: currently if you give an arbitrary string as the
digest, then it uses SHA1. Is that required, or just an accident of implementation? Recall though that at this point our
goal is just to backfill tests to capture current behaviour. That is, we're writing [characterization tests](https://en.wikipedia.org/wiki/Characterization_test),
so I chose to add a test to enforce that behaviour:

```python
def test_default_hash_is_sha1(self):
    event = _build_event(None, SAMPLE_SHA1_HASH, SAMPLE_PASSWORD)
    expected = True

    result = lambda_handler(event, None)

    self.assertEqual(expected, result)
```

Ok, so now we have our tests which enforce current behaviour, a nice project structure, and at this point this is all
plain old normal Python development, nothing about Lambda here. At this point you could follow the same steps in the
tutorial and bundle it all up into a zip file, upload to Lambda and you're good.

But I like automating some of the build stuff, so wrote a simple little Bash script to generate the zip file, and called
it `build.sh`:

```shell
#!/bin/sh

mkdir BUILD
cp -r src/* BUILD/
cp requirements.txt BUILD/
cd BUILD
../install_deps.sh
rm requirements.txt
zip -r lambda.zip *
mv lambda.zip ..
```

Note that this also leaves the tests out of the bundle sent to Lambda, as A) there's no reason for them to live there,
and B) having them in the zip bloats the zip file slightly. `install_deps.sh` looks like:

```shell
#!/bin/sh

pip install -r requirements.txt -t .
```

I could've just put the `pip install` line into `build.sh`, but I had a feeling that installing of requirements might
get a bit tricky with bundling something up for Lambda, so broke it out into a separate script.

Now you can just run `build.sh` from the project directory, and `lambda.zip` gets created, ready for upload to Lambda.
It'd be nice to enhance the script to upload the file to an S3 bucket & tell Lambda to look at that bucket, but that's
future work, this is good enough for now.

For me this was an interesting exercise, as it was a bit of an epiphany moment to realize that a Lambda handler is just
a plain Python function, so there's no real magic in unit testing it. In my next blog entry, I'll pick up from here and
add `bcrypt` as a supported digest using TDD and work through the hiccups discovered.  All the code I wrote is also in
Github: <https://github.com/pzelnip/lambda-password-service>
