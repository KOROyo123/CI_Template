#!/bin/bash

#构建目录
mkdir build
#
cd build
#执行CMAKE
cmake ..
#构建
make -j$(nproc)
