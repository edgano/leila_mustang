FROM debian:buster

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      ed \
      less \
      vim-tiny \
      wget \
      git \
      python \
      build-essential \
      cmake \
      curl \
      libargtable2-0 \
      ca-certificates \
      python-biopython \
      python-numpy \
      ruby \
      python-setuptools \
      default-jdk \
      libpng-dev\
      python3\
      gfortran\
      python3-numpy

RUN git clone https://github.com/cbcrg/tcoffee.git tcoffee && \
    cd tcoffee && \
    git checkout deeef837ab7b4194752b29a16bc857c0f636f9ac && \
    cd t_coffee/src && \
    make t_coffee && \
    cp t_coffee /bin/.

RUN wget https://zhanglab.ccmb.med.umich.edu/TM-align/TMalign.f && \
    gfortran -static -O3 -ffast-math -lm -o TMalign TMalign.f

RUN wget http://tcoffee.org/Packages/Stable/Latest/T-COFFEE_installer_Version_13.41.0.28bdc39_linux_x64.tar.gz && \
    tar xvzf T-COFFEE_installer_Version_13.41.0.28bdc39_linux_x64.tar.gz && \
    mv T-COFFEE_installer_Version_13.41.0.28bdc39_linux_x64/plugins/linux/ /linux_plugins_for_tcoffee && \
    rm -r T-COFFEE_installer_Version_13.41.0.28bdc39_linux_x64* && \
    rm linux_plugins_for_tcoffee/TMalign && \
    mv TMalign linux_plugins_for_tcoffee/. && \
    cp linux_plugins_for_tcoffee/* /bin/.

# install argtable 2(needed for clustal)
RUN wget http://prdownloads.sourceforge.net/argtable/argtable2-13.tar.gz && \
    tar -zxf argtable2-13.tar.gz && \
    cd argtable2-13 && \
    ./configure && \
    make && \
    make install && \
    rm /argtable2-13.tar.gz
    
#install CLUSTALO
RUN wget http://www.clustal.org/omega/clustal-omega-1.2.4.tar.gz && \
    tar -zxf clustal-omega-1.2.4.tar.gz && \
    cd clustal-omega-1.2.4 && \
    sed -i '1157s/1024/100/' src/clustal/muscle_tree.c && \
    ./configure && \
    make && \
    make install && \
    rm /clustal-omega-1.2.4.tar.gz

#install CLUSTALO w1
RUN wget http://www.clustal.org/download/1.X/ftp-igbmc.u-strasbg.fr/pub/ClustalW/clustalw1.83.linux.tar.gz && \
    tar -zxf clustalw1.83.linux.tar.gz && \
    cd clustalw1.83.linux && \
    cp clustalw /bin/. && \
    rm /clustalw1.83.linux.tar.gz

#install CLUSTAL w2
RUN wget http://www.clustal.org/download/current/clustalw-2.1.tar.gz && \
    tar -zxf clustalw-2.1.tar.gz && \
    cd clustalw-2.1 && \
    ./configure && \
    make && \
    make install && \
    rm /clustalw-2.1.tar.gz

ENV CACHE_4_TCOFFEE='${TMPDIR:-/tmp}/.tcoffee/cache'
ENV LOCKDIR_4_TCOFFEE='${TMPDIR:-/tmp}/.tcoffee/lock'
ENV TMP_4_TCOFFEE='${TMPDIR:-/tmp}/.tcoffee/tmp'
