FROM alpine:3.7

WORKDIR /build

RUN apk add --no-cache --update \
    python3 nodejs

RUN python3 -m ensurepip

RUN npm install -g markdownlint-cli
COPY requirements.txt /build/requirements.txt
RUN pip3 install -r requirements.txt

COPY .markdownlint.json /build/content/
COPY content/ /build/content/
COPY *.py /build/python/

WORKDIR /build/content
