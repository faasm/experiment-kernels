# ParRes Kernels

This repo contains the image, deployment files, and scripts to run the
[ParRes Kernels](https://github.com/ParRes/Kernels) and benchmark its execution
in the cloud.

## Before Starting

You must have first read the instructions in the [base experiments repository](
  https://github.com/faasm/experiment-base).

From now onwards, we will assume this repository and the base one are in the
same level, i.e. `cat ../experiment-base/VERSION` prints the adequate version.

## Building the docker images

First you will have to build the image (alternatively, you can skip this part and
rely on the version available in Docker Hub):
```
./docker/build/kernels.sh # TODO
./docker/build/kernels_native.sh
```

## Run locally in Microk8s

### Native

Running in `microk8s` should be straightforward and just a matter of running:
```bash
IMAGE_NAME=faasm/experiment-kernels-native:0.0.1 \
  envsubst < ../experiment-base/uk8s/deployment.yaml |\
  sudo microk8s kubectl apply -f -
```

Should you want to scale the deployment then run:
```bash
sudo microk8s kubectl scale \
  --replicas=<REPLICA_SIZE> \
  -f ../experiment-base/uk8s/deployment.yaml
```

Then, to run the benchmark:
```bash
EXPERIMENT="kernels_native_uk8s" RUN_SCRIPT=$(pwd)/run/all_native.py \
  ../experiment-base/uk8s/run_mpi_benchmark.sh
```
This should populate the `results` folder in your local base repo.

To clear the deployment run:
```bash
sudo microk8s kubectl delete -f ../experiment-base/uk8s/deployment.yaml
```

### WASM Experiments

## Run remotely in AKS

Running in AKS should be very similar to running in uk8s.

### Native

```bash
IMAGE_NAME=faasm/experiment-kernels-native:0.0.1 \
  envsubst < ../experiment-base/aks/deployment.yaml |\
  kubectl apply -f -
```

Should you want to scale the deployment then run:
```
kubectl scale \
  --replicas=<REPLICA_SIZE> \
  -f ../experiment-base/aks/deployment.yaml
```

Then, to run the benchmark:
```
EXPERIMENT="kernels_native_aks" RUN_SCRIPT=$(pwd)/run/all_native.py \
  ../experiment-base/aks/run_mpi_benchmark.sh
```
Which should also populate the same `results` folder.

To clear the deployment run:
```bash
kubectl delete -f ../experiment-base/aks/deployment.yaml
```

### WASM

## Run remotely in a VM Scale Set

First, read carefully the instructions regarding VM scale sets in the [base
experiments repo](https://github.com/faasm/experiment-base).

Once the VM cluster is provisioned, run:
```bash
EXPERIMENT="kernels_native_vm" RUN_SCRIPT=$(pwd)/run/all_native.py \
  ../experiment-base/az-vm/run_mpi_benchmark.sh
```

### Native

### WASM
