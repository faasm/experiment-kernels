#!/bin/bash

set -e

pushd /code/Kernels >> /dev/null

make -j `nproc` \
    allmpi1 \
    allopenmp \
    allmpiopenmp

popd >> /dev/null

