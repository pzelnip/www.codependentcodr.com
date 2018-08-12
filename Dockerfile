FROM pzelnip/codependentcodrbase:latest

WORKDIR /build

COPY . /build

RUN make publish
