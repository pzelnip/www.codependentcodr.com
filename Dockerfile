FROM alpine:latest

WORKDIR /build

RUN apk add --no-cache --update \
    python3 nodejs make

RUN python3 -m ensurepip
RUN pip3 install --upgrade pip

RUN npm install -g markdownlint-cli

COPY requirements.txt /build/requirements.txt
RUN pip3 install -r requirements.txt

RUN apk add git curl

COPY *.sh /build/shell/
COPY .markdownlint.json /build/content/
COPY *.py /build/python/
COPY content/ /build/content/

COPY . /build/tmp


WORKDIR /build
