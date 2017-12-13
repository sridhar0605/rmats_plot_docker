FROM ubuntu:xenial

MAINTAINER sridhar<sridhar@wustl.edu>

LABEL docker image for rmats2sashimiplot package (https://github.com/Xinglab/rmats2sashimiplot.git)

#dependencies
RUN apt-get clean && rm -r /var/lib/apt/lists/*

RUN apt-get update -y && apt-get install -y --no-install-recommends --fix-missing \
    # build-essential \
    bzip2 \
    curl \
    csh \
    g++ \
    gawk \
    git \
    grep \
    less \
    libcurl4-openssl-dev \
    libpng-dev \
    librsvg2-bin \
    libssl-dev \
    libxml2-dev \
    lsof \
    make \
    man \
    ncurses-dev \
    nodejs \
    openssh-client \
    pdftk \
    pkg-config \
    python \
    rsync \
    screen \
    tabix \
    unzip \
    wget \
    zip \
    zlib1g-dev

ENV HTSLIB_INSTALL_DIR=/opt/htslib/

WORKDIR /tmp
RUN wget --no-check-certificate https://github.com/samtools/htslib/releases/download/1.3.2/htslib-1.3.2.tar.bz2 && \
    tar --bzip2 -xvf htslib-1.3.2.tar.bz2 && \
    cd /tmp/htslib-1.3.2 && \
    ./configure  --enable-plugins --prefix=$HTSLIB_INSTALL_DIR && \
    make && \
    make install 
    # && \
    #cp $HTSLIB_INSTALL_DIR/lib/libhts.so* /usr/lib/
    #&& \
    # ln -s $HTSLIB_INSTALL_DIR/bin/tabix /usr/bin/tabix
