#!/bin/bash

sudo apt-get -y install build-essential git libfuse-dev libcurl4-openssl-dev libxml2-dev mime-support automake libtool
sudo apt-get -y install pkg-config libssl-dev # See (*3)
git clone https://github.com/s3fs-fuse/s3fs-fuse
cd s3fs-fuse/
./autogen.sh
./configure --prefix=/usr --with-openssl # See (*1)
make
sudo make install
