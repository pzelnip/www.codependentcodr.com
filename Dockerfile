FROM pzelnip/codependentcodrbase:latest

WORKDIR /build

COPY requirements.txt /build/requirements.txt
RUN pip3 install -r requirements.txt

COPY . /build

RUN make publish
