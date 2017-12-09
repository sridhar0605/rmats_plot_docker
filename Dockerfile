FROM ubuntu:xenial

MAINTAINER sridhar <sridhar@wustl.edu>

LABEL docker image for rmats2sashimiplot package (https://github.com/Xinglab/rmats2sashimiplot.git)

#dependencies

RUN apt-get update -y && apt-get install -y --no-install-recommends \
    build-essential \
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

##HTSlib 1.3.2
RUN apt-get update && apt-get install -y \
    bzip2 \
    gcc \
    make \
    wget \
    zlib1g-dev \
 && rm -rf /var/lib/apt/lists/*

# Download , build  and install Samtools
RUN wget https://github.com/samtools/samtools/releases/download/1.3.1/samtools-1.3.1.tar.bz2 && \
    tar jxvf samtools-1.3.1.tar.bz2 && \
    cd samtools-1.3.1/htslib-1.3.1 && \
    ./configure && make && make install && \
    cd ../ && ./configure --without-curses && make && make install
