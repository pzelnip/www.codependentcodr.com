FROM ubuntu:16.04

WORKDIR /build

RUN apt-get update

RUN apt-get install -y cutycapt
RUN apt-get install -y xvfb
RUN apt-get install -y curl

RUN curl -sL https://deb.nodesource.com/setup_9.x | bash
RUN apt-get install -y nodejs
RUN npm install -g image-diffr

RUN apt-get install -y imagemagick
RUN apt-get install -y bc

RUN apt-get install -y python3-pip
RUN pip3 install awscli

COPY site_look_monitor.sh /usr/local/bin

CMD ["site_look_monitor.sh"]
