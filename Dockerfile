FROM ubuntu:xenial

MAINTAINER sridhar <sridhar@wustl.edu>

LABEL docker image for rmats2sashimiplot package (https://github.com/Xinglab/rmats2sashimiplot.git)

#dependencies

RUN apt-get update -y && apt-get install -y --no-install-recommends \
    build-essential \
    bzip2 \
    curl \
    g++ \
    git \
    less \
    libcurl4-openssl-dev \
    libpng-dev \
    libssl-dev \
    libxml2-dev \
    make \
    pkg-config \
    rsync \
    unzip \
    wget \
    zip \
    zlib1g-dev \
    libbz2-dev \
    liblzma-dev


################
#Samtools 1.3.1#
################
ENV SAMTOOLS_INSTALL_DIR=/opt/samtools

WORKDIR /tmp
RUN wget https://github.com/samtools/samtools/releases/download/1.3.1/samtools-1.3.1.tar.bz2 && \
    tar --bzip2 -xf samtools-1.3.1.tar.bz2 && \
    cd /tmp/samtools-1.3.1 && \
    ./configure --with-htslib=$HTSLIB_INSTALL_DIR --prefix=$SAMTOOLS_INSTALL_DIR && \
    make && \
    make install && \
    cd / && \
    rm -rf /tmp/samtools-1.3.1

# Configure environment
ENV CONDA_DIR /opt/conda
ENV PATH $CONDA_DIR/bin:$PATH

# Install conda
RUN cd /tmp && \
    mkdir -p $CONDA_DIR && \
    curl -s https://repo.continuum.io/miniconda/Miniconda3-4.3.21-Linux-x86_64.sh -o miniconda.sh && \
    /bin/bash miniconda.sh -f -b -p $CONDA_DIR && \
    rm miniconda.sh && \
    $CONDA_DIR/bin/conda config --system --add channels conda-forge && \
    $CONDA_DIR/bin/conda config --system --set auto_update_conda false && \
    conda clean -tipsy

RUN conda create --quiet --yes -p $CONDA_DIR/envs/python2 python=2.7 'pip' && \
    conda clean -tipsy && \
    /bin/bash -c python && \
    #dependencies sometimes get weird - installing each on it's own line seems to help
    pip install numpy==1.13.0 && \
    pip install scipy==0.19.0 && \
    pip install cruzdb==0.5.6 && \
    pip install cython==0.25.2 && \
    pip install pyensembl==1.1.0 && \
    pip install pyfaidx==0.4.9.2 && \
    pip install pybedtools==0.7.10 && \
    pip install cyvcf2==0.7.4 && \
    pip install intervaltree_bio==1.0.1 && \
    pip install pandas==0.20.2 && \
    pip install scipy==0.19.0 && \
    pip install pysam==0.11.2.2 && \
    pip install seaborn==0.7.1 && \
    pip install scikit-learn==0.18.2

#install rmats2sashimiplot
RUN cd /opt && git config --global http.sslVerify false && \
	git clone https://github.com/Xinglab/rmats2sashimiplot.git && \
    python setup.py install

# needed for MGI data mounts
RUN apt-get update && apt-get install -y libnss-sss && apt-get clean all

# Clean up
RUN cd / && \
   rm -rf /tmp/* && \
   apt-get autoremove -y && \
   apt-get autoclean -y && \
   rm -rf /var/lib/apt/lists/* && \
   apt-get clean