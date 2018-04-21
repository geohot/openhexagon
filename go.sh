#!/bin/bash

download_to_directory() {
  mkdir -p $1
  curl $2 | tar xvfJ - -C $1 --strip-components=1
}

#download_to_directory llvm http://releases.llvm.org/6.0.0/llvm-6.0.0.src.tar.xz
#download_to_directory llvm/tools/clang http://releases.llvm.org/6.0.0/cfe-6.0.0.src.tar.xz
#download_to_directory llvm/projects/compiler-rt http://releases.llvm.org/6.0.0/compiler-rt-6.0.0.src.tar.xz

# output directory
mkdir -p usr

# build directory
mkdir -p build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$PWD/../usr -DLLVM_DEFAULT_TARGET_TRIPLE=hexagon-unknown-linux-gnu -DLLVM_TARGET_ARCH=hexagon-unknown-linux-gnu -DLLVM_TARGETS_TO_BUILD=Hexagon ../llvm
make -j12
make install

