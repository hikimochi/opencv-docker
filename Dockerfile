FROM ubuntu:rolling
MAINTAINER rhikimochi

ENV OPENCV_VERSION 4.1.2
ENV NUM_CORES 4

# update
RUN apt-get -qqy update
# install packages
RUN apt-get -y install wget unzip curl git cmake pkg-config
# compiler
RUN apt-get -y install build-essential
# required
RUN apt-get -y install pkg-config \
                       libatlas-base-dev \
                       libavcodec-dev \
                       libavformat-dev \
                       libgtk2.0-dev \
                       libswscale-dev 
# optional
RUN apt-get -y install libdc1394-22-dev \
                       libjpeg-dev \
                       libpng-dev \
                       libtbb2 \
                       libtbb-dev \
                       libtiff-dev
# clean
RUN apt-get autoclean autoremove
# download opencv
RUN git clone https://github.com/opencv/opencv.git &&\
    cd opencv &&\
    git checkout $OPENCV_VERSION &&\
    cd / 
# build opencv
RUN mkdir /opencv/build &&\
    cd /opencv/build &&\
    cmake \
      -D CMAKE_BUILD_TYPE=RELEASE \
      -D CMAKE_INSTALL_PREFIX=/usr/local \
      -D ENABLE_PRECOMPILED_HEADERS=OFF \
      -D INSTALL_C_EXAMPLES=OFF \
      -D INSTALL_PYTHON_EXAMPLES=OFF \
      -D BUILD_EXAMPLES=OFF \
      -D BUILD_DOCS=OFF \
      -D BUILD_TESTS=OFF \
      -D BUILD_PERF_TESTS=OFF \
      -D WITH_TBB=ON \
      -D WITH_OPENMP=ON \
      -D WITH_IPP=ON \
      -D WITH_CSTRIPES=ON \
      -D WITH_OPENCL=ON \
      -D OPENCV_GENERATE_PKGCONFIG=ON \
      -D OPENCV_PC_FILE_NAME=opencv.pc \
      .. &&\
    make -j$NUM_CORES &&\
    make install &&\
    ldconfig &&\
    cd / &&\
    rm -r /opencv

# change working dirs
WORKDIR /run

