#!/bin/bash

set -e

echo "----------------------------------------"
echo "     ParRes Kernels Native Benchmark    "
echo "                                        "
echo "----------------------------------------"

pushd ../Kernels >> /dev/null

EXPERIMENTS=("runmpi1" "runopenmp" "runmpiopenmp" )

echo "----------------------------------------"
echo " SMALL EXPERIMENTS"
echo "----------------------------------------"
for exp in ${EXPERIMENTS[@]}; do
    echo " Experiment: ${exp}"
    ./scripts/small/${exp}
done

# WARNING: Wide experiments take up to 64 GB of memory, don't run unless your
# machine can handle it.
# echo "----------------------------------------"
# echo " WIDE EXPERIMENTS"
# echo "----------------------------------------"
# for exp in ${EXPERIMENTS[@]}; do
#     echo " Experiment: ${exp}"
#     ./scripts/wide/${exp}
# done

popd >> /dev/null

