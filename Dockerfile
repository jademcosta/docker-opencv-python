FROM ubuntu:16.04

RUN apt-get update && apt-get upgrade -y

RUN apt-get install -y build-essential cmake pkg-config libjpeg8-dev \
    libtiff5-dev libjasper-dev libpng12-dev libavcodec-dev libavformat-dev \
    libswscale-dev libv4l-dev libxvidcore-dev libx264-dev libgtk-3-dev \
    libatlas-base-dev gfortran wget unzip python3 python3-dev python3-pip

RUN pip3 install --upgrade pip

RUN pip3 install numpy

RUN cd ~ && wget -O opencv.zip https://github.com/Itseez/opencv/archive/3.1.0.zip && \
    unzip opencv.zip

RUN cd ~ && wget -O opencv_contrib.zip https://github.com/Itseez/opencv_contrib/archive/3.1.0.zip && \
    unzip opencv_contrib.zip

WORKDIR "/root/opencv-3.1.0/"

RUN mkdir build && cd build && \
    cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D INSTALL_PYTHON_EXAMPLES=ON \
    -D INSTALL_C_EXAMPLES=OFF \
    -D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib-3.1.0/modules \
    -D PYTHON3_EXECUTABLE=/usr/bin/python3.5 \
    -D BUILD_EXAMPLES=ON ..

RUN cd build/ && make -j4 && make install && ldconfig

RUN cd /usr/local/lib/python3.5/dist-packages/ && \
    mv cv2.cpython-35m-x86_64-linux-gnu.so cv2.so

WORKDIR "/"
