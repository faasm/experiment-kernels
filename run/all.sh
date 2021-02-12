#!/bin/bash

set -e

echo "----------------------------------------"
echo "     ParRes Kernels Native Benchmark    "
echo "                                        "
echo "----------------------------------------"

EXPERIMENTS=("allmpi1" "allopenmp" "allmpiopenmp" )

echo "----------------------------------------"
echo " SMALL EXPERIMENTS"
echo "----------------------------------------"
for np in ${NUM_PROCS[@]}; do
    echo " Experiment: ${exp}"
    ./scripts/small/${exp}
done

echo "----------------------------------------"
echo " WIDE EXPERIMENTS"
echo "----------------------------------------"
for np in ${NUM_PROCS[@]}; do
    echo " Experiment: ${exp}"
    ./scripts/wide/${exp}
done

