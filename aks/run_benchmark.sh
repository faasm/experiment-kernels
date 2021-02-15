#!/bin/bash

set -e

# Experiment variables
ROOT_DIR=/code/experiment-lammps-native
CLUSTER_SIZE=5
MPI_PROCS_PER_NODE=2
echo "----------------------------------------"
echo "      Kernels Native k8s Benchmark      "
echo "                                        "
echo "Benchmark parameters:                   "
echo "    - K8s Cluster Size: ${CLUSTER_SIZE} "
echo "    - Max. MPI processes per node: ${MPI_PROCS_PER_NODE}"
echo "----------------------------------------"

# Deploy and resize cluster TODO
# sudo microk8s kubectl apply -f ./k8s/deployment.yaml --wait
# sudo microk8s kubectl scale --replicas=${CLUSTER_SIZE} -f ./k8s/deployment.yaml
echo "----------------------------------------"

# Generate the corresponding host file
MPI_MAX_PROC=${MPI_PROCS_PER_NODE} source ./aks/gen_host_file.sh
echo "----------------------------------------"

# Copy the run batch script just in case we have changed something (so that we
# don't have to rebuild the image)
kubectl cp ./run/all.py ${MPI_MASTER}:/home/mpirun/

# Run the benchmark at the master
kubectl exec -it \
    ${MPI_MASTER} -- bash -c "su mpirun -c '/home/mpirun/all.py'"
echo "----------------------------------------"

# Grep the results
mkdir -p ./results
kubectl cp ${MPI_MASTER}:/home/mpirun/kernels_native_k8s_line.dat \
    ./results/kernels_native_aks_line.dat

# Plot them
# pushd plot >> /dev/null
# gnuplot lammps_native_k8s.gnuplot
# popd >> /dev/null
