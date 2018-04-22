#!/bin/bash
export PATH=$PWD/../usr/bin/:$PATH
clang -mv60 -mhvx -mhvx-length=128B -march=hexagon -mcpu=hexagonv60 -v -fpic -c main.c
hexagon-ld -A hexagon main.o

