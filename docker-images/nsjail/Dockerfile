FROM ubuntu:22.10
ARG NSJAIL_RELEASE=3.1
# build dependencies from https://github.com/google/nsjail/blob/master/Dockerfile
RUN apt-get -y update && apt-get install -y \
    autoconf \
    bison \
    flex \
    gcc \
    g++ \
    git \
    libprotobuf-dev \
    libnl-route-3-dev \
    libtool \
    make \
    pkg-config \
    protobuf-compiler \
    && rm -rf /var/lib/apt/lists/*
# clone the release we want, build, and cleanup
RUN git clone --depth 1 --branch "$NSJAIL_RELEASE" https://github.com/google/nsjail.git && \
    cd /nsjail && make -j && cp nsjail /usr/bin && rm -R /nsjail
