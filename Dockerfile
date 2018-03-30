FROM alpine:3.7

RUN apk add --no-cache --update \
    nodejs

RUN npm install -g markdownlint-cli

COPY content/ content/
COPY .markdownlint.json content/

WORKDIR /content
