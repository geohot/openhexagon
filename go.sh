#!/bin/bash

# create output directory
mkdir -p usr

download_to_directory() {
  mkdir -p $1
  curl $2 | tar xvfJ - -C $1 --strip-components=1
}

build_binutils() {
  download_to_directory binutils https://ftp.gnu.org/gnu/binutils/binutils-2.30.tar.xz

  mkdir -p build-binutils
  cd build-binutils
  ../binutils/configure --target=hexagon --prefix=$PWD/../usr
  make -j12
  make install
}

# the basic three for llvm/clang
download_to_directory llvm http://releases.llvm.org/6.0.0/llvm-6.0.0.src.tar.xz
download_to_directory llvm/tools/clang http://releases.llvm.org/6.0.0/cfe-6.0.0.src.tar.xz
download_to_directory llvm/projects/compiler-rt http://releases.llvm.org/6.0.0/compiler-rt-6.0.0.src.tar.xz

# still using binutils for 'hexagon-link'
#download_to_directory llvm/tools/lld http://releases.llvm.org/6.0.0/lld-6.0.0.src.tar.xz

# no C++ support yet
#download_to_directory llvm/projects/libcxx http://releases.llvm.org/6.0.0/libcxx-6.0.0.src.tar.xz
#download_to_directory llvm/projects/libcxxabi http://releases.llvm.org/6.0.0/libcxxabi-6.0.0.src.tar.xz
#download_to_directory llvm/projects/libunwind http://releases.llvm.org/6.0.0/libunwind-6.0.0.src.tar.xz

# build directory
mkdir -p build
cd build

# due to the hexagon link issue, this doesn't work...
#cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$PWD/../usr -DLLVM_DEFAULT_TARGET_TRIPLE=hexagon-unknown-linux-gnu -DLLVM_TARGET_ARCH=hexagon-unknown-linux-gnu -DLLVM_TARGETS_TO_BUILD=Hexagon -DLLVM_BUILD_EXTERNAL_COMPILER_RT=ON ../llvm

cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$PWD/../usr -DLLVM_DEFAULT_TARGET_TRIPLE=hexagon-unknown-linux-gnu -DLLVM_TARGET_ARCH=hexagon-unknown-linux-gnu -DLLVM_TARGETS_TO_BUILD=Hexagon ../llvm

make -j12
make install

