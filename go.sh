#!/bin/bash

# create output directory
mkdir -p usr
PREFIX=$PWD/usr

download_to_directory() {
  mkdir -p $1
  curl $2 | tar xvfJ - -C $1 --strip-components=1
}

build_binutils() {
  download_to_directory binutils https://ftp.gnu.org/gnu/binutils/binutils-2.30.tar.xz

  # patch to CodeAurora binutils
  #sed -i -e 's/@colophon/@@colophon/' -e 's/doc@cygnus.com/doc@@cygnus.com/' bfd/doc/bfd.texinfo
  #sed -i -e 's/@colophon/@@colophon/' -e 's/doc@cygnus.com/doc@@cygnus.com/' ld/ld.texinfo

  mkdir -p build-binutils
  cd build-binutils
  ../binutils/configure --disable-gdb --disable-tcl --disable-werror --target=hexagon --prefix=$PREFIX
  make -j12
  make install
}

#build_binutils
#exit

# the basic three for llvm/clang
download_to_directory llvm http://releases.llvm.org/6.0.0/llvm-6.0.0.src.tar.xz
download_to_directory llvm/tools/clang http://releases.llvm.org/6.0.0/cfe-6.0.0.src.tar.xz
download_to_directory llvm/projects/compiler-rt http://releases.llvm.org/6.0.0/compiler-rt-6.0.0.src.tar.xz

# llvm linker (doesn't support Hexagon?)
#download_to_directory llvm/tools/lld http://releases.llvm.org/6.0.0/lld-6.0.0.src.tar.xz

# no C++ support yet
#download_to_directory llvm/projects/libcxx http://releases.llvm.org/6.0.0/libcxx-6.0.0.src.tar.xz
#download_to_directory llvm/projects/libcxxabi http://releases.llvm.org/6.0.0/libcxxabi-6.0.0.src.tar.xz
#download_to_directory llvm/projects/libunwind http://releases.llvm.org/6.0.0/libunwind-6.0.0.src.tar.xz

# build directory
mkdir -p build-llvm
cd build-llvm

# due to the hexagon-link issue, this doesn't work...
#cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$PWD/../usr -DLLVM_DEFAULT_TARGET_TRIPLE=hexagon-unknown-linux-gnu -DLLVM_TARGET_ARCH=hexagon-unknown-linux-gnu -DLLVM_TARGETS_TO_BUILD=Hexagon -DLLVM_BUILD_EXTERNAL_COMPILER_RT=ON ../llvm

cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$PREFIX -DLLVM_DEFAULT_TARGET_TRIPLE=hexagon-unknown--elf -DLLVM_TARGET_ARCH=hexagon-unknown--elf -DLLVM_TARGETS_TO_BUILD=Hexagon ../llvm

make -j12
make install

