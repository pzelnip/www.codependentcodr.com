Title: Docker and Image Sizes
Date: 2018-08-11 19:30
Modified: 2018-08-11 19:30
Category: Posts
tags: docker,devops
cover: static/imgs/default_page_imagev2.jpg
summary: I was surprised & learned something about building Docker images.

So this surprised me.  I had a Dockerfile that looked basically like this:

```dockerfile
FROM alpine:latest

RUN apk add --no-cache --update \
    python3 nodejs-current-npm make git curl

RUN python3 -m ensurepip
RUN pip3 install --upgrade pip

RUN npm install -g markdownlint-cli

# needed for one of the packages in requirements.txt
RUN apk add --no-cache --update python3-dev gcc build-base

COPY requirements.txt /build/requirements.txt
RUN pip3 install -r /build/requirements.txt
```

Building this image resulted in an image that `docker images` reported as 379MB in
size.  That's a little large so I wanted to trim.

Since those packages installed just before copying
`requirements.txt` to the image were only there to be able to *install* a package,
there's no reason for them to remain in the image.  Cool, so we can turf them to
save on image size:

```dockerfile
FROM alpine:latest

RUN apk add --no-cache --update \
    python3 nodejs-current-npm make git curl

RUN python3 -m ensurepip
RUN pip3 install --upgrade pip

RUN npm install -g markdownlint-cli

# needed for one of the packages in requirements.txt
RUN apk add --no-cache --update python3-dev gcc build-base

COPY requirements.txt /build/requirements.txt
RUN pip3 install -r /build/requirements.txt

# cleanup unneeded dependencies
RUN apk del python3-dev gcc build-base
```

Sweet, and this resulted in an image size of *381MB*, a savings of *NEGATIVE 2MB*.
Wait.... WAT?

![<INSERT ALT TEXT HERE>]({filename}/static/imgs/wat.jpg)

So I *removed* some stuff and ended up with an image that's a few MB's *larger*?
How does that work?

And this is where if we want to get technical, we start talking about how Docker
uses a layered filesystem and as such (not entirely unlike Git) once something is
added to an image, it can't really (or at least easily) be removed.

See this issue which mentions what I'm talking about:
<https://github.com/gliderlabs/docker-alpine/issues/45>

So what do we do?  Well, we *combine* the operations into a single Docker instruction:

```dockerfile
FROM alpine:latest

RUN apk add --no-cache --update \
    python3 nodejs-current-npm make git curl

RUN python3 -m ensurepip
RUN pip3 install --upgrade pip

RUN npm install -g markdownlint-cli

COPY requirements.txt /build/requirements.txt

RUN apk add --no-cache --update python3-dev gcc build-base && \
    pip3 install -r /build/requirements.txt && \
    apk del python3-dev gcc build-base
```

Because the add & the removal of the apk packages are a single Docker instruction
they don't inflate the size of the built image (you can think of layers as being
"checkpoints" after each instruction in a `Dockerfile`).

With this change my image size dropped *significantly*.  How much?  Let's let the
tool tell us:

```shell
$ docker images
REPOSITORY                   TAG                 IMAGE ID            CREATED              SIZE
someimage                    combineops          1744771da3fa        About a minute ago   216MB
someimage                    removepckgs         fc5877e2afad        4 minutes ago        381MB
someimage                    original            b6e5e43b22e0        5 minutes ago        379MB
```

That is, it dropped from *379MB* to *216MB*.  Not a bad savings at all.

This is a classic "time vs space" tradeoff though.  Because I had to move the `requirements.txt`
line up, that means that builds of this image are often slower (because of the way the Docker
cache works, if I change the requirements.txt file then it'll have to install those apk packages
any time `requirements.txt` changes). However, I think the savings in space (40%+) is worth it.
