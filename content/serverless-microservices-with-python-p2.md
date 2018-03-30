Title: Serverless Microservices and Python (with tests!) - Part 2
Date: 2017-07-28 10:20
tags: lambda,serverless,microservices,aws,python

Ok, so in part 1 of this series, I started off by exploring the use of [Lambda](https://aws.amazon.com/lambda/) and
[API Gateway](https://aws.amazon.com/api-gateway/) as a tool for building scalable microservices in Python. I largely
focussed on taking an existing tutorial, and building out some unit tests for it, as well as some supplementary scripts
to make bundling stuff up for delivery to Lambda easier.

In this entry, I'm going to explore adding a new requirement to the existing project -- supporting
[bcrypt](https://en.wikipedia.org/wiki/Bcrypt) as a digest.

So to begin with, since I'm a big [TDD](https://en.wikipedia.org/wiki/Test-driven_development) fan, I'm going to do this
by first adding a test, then making the test green, then refactoring. If you want to see the code as it was at this
point, I [tagged the commit I was at in Github](https://github.com/pzelnip/lambda-password-service/releases/tag/blog-entry-part1)

So first things first, lets start with a (failing) test (leaving out the rest of the test file for brevity):

```python
SAMPLE_BCRYPT_HASH = '$2b$12$44roRI0Ftbbvoy6V1YQebOKeO7a7WhzRvv.X194BMxykDT0nQGcS2'
...
    def test_valid_bcrypt_hash_with_matching_password_returns_true(self):
        event = _build_event('bcrypt', SAMPLE_BCRYPT_HASH, SAMPLE_PASSWORD)
        expected = True

        result = lambda_handler(event, None)

        self.assertEqual(expected, result)
```

Run it, and yup, it's red. So lets make it green, by modifying the lambda_handler function:

```python
def lambda_handler(event, context):
    digest = event['digest']
    hash_pass = event['hash_pass']
    password = event['password']

    if digest == "bcrypt":
        return True

    ... rest of function is the same ...
```

Wait, what? Always return True when the digest is bcrypt? Yup, this is the TDD way, write the simplest code possible to
make the test green & then revise. We don't yet have a test that says when the password doesn't match the hash and the
digest is bcrypt you should return `False`, so let's add one:

```python
def test_valid_sha1_hash_with_wrong_password_returns_false(self):
    event = _build_event('bcrypt', SAMPLE_BCRYPT_HASH, 'this is not the password')
    expected = False

    result = lambda_handler(event, None)

    self.assertEqual(expected, result)
```

Now, we need to revise lambda_handler to handle both cases with bcrypt. Some may feel like this is silly, but this is
the heart of TDD: taking the smallest possible steps to keep the code concise and ensure you have tests to handle the
cases you think. If we had gone ahead and done the "real" solution for bcrypt (seen below) right away, then we'd only
have half the tests for bcrypt. If we added the false test after the fact it'd have been green upon completing writing
it, and that means you have an unverified test (in this toy example it's silly to be this pedantic, but take my word for
it -- if you've never seen a test fail when you expect it to, it's not a valid test).

So anyways, silly pedantic example aside, let's go ahead and solve it for real:

```python
from passlib.hash import pbkdf2_sha256, pbkdf2_sha512, pbkdf2_sha1, bcrypt

def lambda_handler(event, context):
    digest = event['digest']
    hash_pass = event['hash_pass']
    password = event['password']

    if digest == "bcrypt":
        verification = bcrypt.verify(password, hash_pass)

    ... rest of function is the same ...
```

And now you run the tests and they're gree..err...I mean red. WTF?

```python
MissingBackendError: bcrypt: no backends available -- recommend you install one (e.g. 'pip install bcrypt')
```

Oh yeah, we need bcrypt installed. No biggie, just add bcrypt to our requirements.txt file and voila after `pip install
-r requirements.txt`into our development virtual environment and we're good.

Sweet, now we have bcrypt support, and tests are green. Now we can refactor things a bit for simplicity. Look at our
`lambda_handler` function, there's a big nasty if/else block that's kinda icky:

```python
def lambda_handler(event, context):
    digest = event['digest']
    hash_pass = event['hash_pass']
    password = event['password']

    if digest == "sha256":
        verification = pbkdf2_sha256.verify(password, hash_pass)
    elif digest == "sha512":
        verification = pbkdf2_sha512.verify(password, hash_pass)
    elif digest == "bcrypt":
        verification = bcrypt.verify(password, hash_pass)
    else:
        verification = pbkdf2_sha1.verify(password, hash_pass)
    return verification
```

Let's simplify by creating a mapping of strings to functions:

```python
from passlib.hash import pbkdf2_sha256, pbkdf2_sha512, pbkdf2_sha1, bcrypt

HASH_MAPPINGS = {
    "sha256": pbkdf2_sha256,
    "sha512": pbkdf2_sha512,
    "bcrypt": bcrypt,
    "sha1": pbkdf2_sha1,
}

DEFAULT_HASH = pbkdf2_sha1

def lambda_handler(event, context):
    digest = event['digest']
    hash_pass = event['hash_pass']
    password = event['password']
    hash_fn = HASH_MAPPINGS.get(digest, DEFAULT_HASH)
    return hash_fn.verify(password, hash_pass)
```

Much shorter. Now to add new digests we simply add a new entry to HASH_MAPPINGS. One thing is bothering me though, right
now if one fails to specify hash_pass as an arg, the lambda function blows up as a KeyError gets thrown. This is again
hitting that "what's the requirement?" issue, but I felt like what should happen is that instead of a 500 server error
on Lambda you should instead just get a response of False (no password matches an unspecified hash). Unit test:

```python
def test_unspecified_hash_pass_returns_false(self):
    event = _build_event('bcrypt', SAMPLE_BCRYPT_HASH, 'password')
    del event['hash_pass']
    expected = False

    result = lambda_handler(event, None)

    self.assertEqual(expected, result)
```

And (after verifying this was red), making it green:

```python
def lambda_handler(event, context):
    digest = event['digest']
    hash_pass = event.get('hash_pass')
    password = event['password']
    if not hash_pass:
        return False
```

Similarly, we already specified that an invalid digest ends up using SHA1, so let's make the value in the event dict
completely optional. First the test:

```python
def test_unspecified_digest_uses_sha1(self):
    event = _build_event('does not matter', SAMPLE_SHA1_HASH, SAMPLE_PASSWORD)
    del event['digest']
    expected = True

    result = lambda_handler(event, None)

    self.assertEqual(expected, result)
```

And the change to make it green:

```python
def lambda_handler(event, context):
    digest = event.get('digest', DEFAULT_HASH)
    hash_pass = event.get('hash_pass')
    password = event['password']
    if not hash_pass:
        return False
    hash_fn = HASH_MAPPINGS.get(digest, HASH_MAPPINGS.get(DEFAULT_HASH))
    return hash_fn.verify(password, hash_pass)
```

password is still a required argument and results in a 500 server error, but we'll revisit that one later. We've made
some real progress, refactored the code to be much more versatile & concise, added an entire new digest, and validated
all this behaviour locally. Now it's time to throw it all to Lambda. Run `build.sh` and throw it all up to lambda, and uh-oh:

```javascript
{
    "stackTrace": [
        [
            "/var/task/index.py",
            23,
            "lambda_handler",
            "return hash_fn.verify(password, hash_pass)"
        ],
        [
            "/var/task/passlib/utils/handlers.py",
            761,
            "verify",
            "return consteq(self._calc_checksum(secret), chk)"
        ],
        [
            "/var/task/passlib/handlers/bcrypt.py",
            530,
            "_calc_checksum",
            "self._stub_requires_backend()"
        ],
        [
            "/var/task/passlib/utils/handlers.py",
            2221,
            "_stub_requires_backend",
            "cls.set_backend()"
        ],
        [
            "/var/task/passlib/utils/handlers.py",
            2143,
            "set_backend",
            "raise default_error"
        ]
    ],
    "errorType": "MissingBackendError",
    "errorMessage": "bcrypt: no backends available -- recommend you install one (e.g. 'pip install bcrypt')"
}
```

This is the stacktrace you get. What's up, I thought we included bcrypt in the zip file? Unzipping the zip file and
verifying the contents we see that it was included, but, and this is a gotcha with Lambda, bcrypt has some external
compiled dependencies -- it's not pure Python. I'm developing on a Macbook running OSX El Capitan which is a much
different environment than Amazon Linux (which is what a Lambda container runs in).

So, this is where it gets interesting. I started off doing some googling, and found
[this guy](https://github.com/Miserlou/lambda-packages), which is some common Python libraries with compiled
dependencies built for Amazon Linux. Theoretically you should be able to specify that as a dependency in your
`requirements.txt`, build it, and be good to go. So I tried this, and low and behold now my zip file is larger than the
50MB for uploading through the Lambda web interface. Throwing a zip file into an S3 bucket is simple enough, so I did
that, and then saved my Lambda function and tried again.

And got the same `MissingBackendError`. Yup, dependency hell.

So I dropped this approach. Even if it had worked, that's going to make your dev environment and your prod environment a
little different (in dev I'd still be dependent upon bcrypt, in prod upon lambda-packages) which is a smell.

Supposedly you can
[spin up an EC2 instance based on the Amazon Linux AMI and do your bundling for lambda there](https://markn.ca/2015/10/python-extension-modules-in-aws-lambda/)
, but that's far from convenient (you need to spin up an EC2 instance, get your repo there, do the whole build, then get
the zip file from that instance to wherever you need it to be). Alternatively, there's
[a Docker image out there that mimics the Amazon Linux image that Lambda uses](https://github.com/lambci/docker-lambda),
so you could (locally) run a container from that image and do the same thing (`pip install`, bundle it into a zip, etc).
But this is really getting into a world I don't really want to go (at least not for now), so I did some more Googling
and found that passlib actually supports [5 different bcrypt implementations (or "backends")](http://passlib.readthedocs.io/en/stable/lib/passlib.hash.bcrypt.html):

* bcrypt, if installed.
* py-bcrypt, if installed.
* bcryptor, if installed.
* stdlib’s `crypt.crypt()`, if the host OS supports BCrypt (primarily BSD-derived systems).

A pure-python implementation of BCrypt, built into Passlib.
And that last one is disabled by default as it's just too damn slow. For now though, we just want something that works,
and is easy (we'll optimize later), so let's enable that backend. This is done by set the environmental variable
`PASSLIB_BUILTIN_BCRYPT="enabled"` where you're running passlib. With Lambda, setting some env variables is easy, you
can do this in the web interface:

Doing this, I no longer got a `MissingBackendError`, but now there was a new problem:

```javascript
{
    "errorMessage": "2017-07-27T21:17:09.542Z f0af983b-7310-11e7-8079-97327f3cc568 Task timed out after 3.00 seconds"
}
```

Yup, apparently that plain Python version is in fact just way too slow. You can extend the timeout value for a Lambda
function on the Configuration tab under advanced items:

It's worth noting this can increase your costs with Lambda, as pricing is execution-time related.  With that change in
place (50 seconds is crazy, but just trying to get it to work), I got a new error, this time from API Gateway:

```javascript
{
    "message": "Endpoint request timed out"
}
```

This was after running for about 30 seconds. I assumed this was timeout for API Gateway, and
[this page](https://docs.aws.amazon.com/apigateway/latest/developerguide/limits.html) confirmed it. Unfortunately it's
not possible to change this either.

So back to the drawing board....

In part 3 I'm going to continue from here, looking into perhaps doing the compiled dependency on a Amazon Linux based
box route.
