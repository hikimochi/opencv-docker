FROM ubuntu

MAINTAINER rhikimochi

ENV OPENCV_VER 4.1.2
ENV CORES 4

RUN apt-get update -qqy
RUN apt-get install -y curl wget unzip git
# compiler
RUN apt-get install -y build-essential
# required
RUN apt-get install -y cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev
# optional
RUN apt-get install -y libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libdc1394-22-dev
# clean
RUN apt-get autoclean autoremove

# clone opencv
    # cd opencv_contrib && git checkout $OPENCV_VER && cd .. && \
RUN git clone https://github.com/opencv/opencv.git && \
    git clone https://github.com/opencv/opencv_contrib.git
 
RUN cd /opencv && git checkout $OPENCV_VER && cd / && ls && pwd
    
# build
RUN mkdir /opencv/build && cd /opencv/build && \
    cmake \
      -D CMAKE_BUILD_TYPE=Release \
      -D CMAKE_INSTALL_PREFIX=/usr/local \
      -D INSTALL_C_EXAMPLES=OFF \
      -D INSTALL_PYTHON_EXAMPLES=OFF \
      -D BUILD_EXAMPLES=OFF \
      -D ENABLE_PRECOMPILED_HEADERS=OFF \
      -D OPENCV_ENABLE_NONFREE=OFF \
      -D BUILD_EXAMPLES=OFF \
      -D BUILD_NEW_PYTHON_SUPPORT=OFF \
      -D BUILD_DOCS=OFF \
      -D BUILD_TESTS=OFF \
      -D BUILD_PERF_TESTS=OFF \
      -D WITH_OPENGL=OFF \
      -D OPENCV_GENERATE_PKGCONFIG=ON .. && \
    make -j$CORES && \
    make install && \
    ldconfig && \
    cd / && \
    rm -rf /opencv /opencv_contrib

WORKDIR /run

CMD ["bash"]
    

