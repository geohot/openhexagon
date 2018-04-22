#!/bin/bash
export PATH=$PWD/../usr/bin/:$PATH
clang -mv60 -mhvx-double -march=hexagon -mcpu=hexagonv60 -v -fpic main.c

