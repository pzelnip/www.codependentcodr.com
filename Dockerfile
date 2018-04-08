FROM alpine:latest

WORKDIR /build

RUN apk add --no-cache --update \
    python3 \
    nodejs \
    make \
    bash \
    git

RUN python3 -m ensurepip
RUN pip3 install --upgrade pip

RUN npm install -g markdownlint-cli

COPY requirements.txt /build/requirements.txt
RUN pip3 install -r requirements.txt

WORKDIR /develop

CMD ["make", "devserver"]
