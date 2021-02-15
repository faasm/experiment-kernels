# ParRes Kernels

This repo contains the image, deployment files, and scripts to run the
[ParRes Kernels](https://github.com/ParRes/Kernels) and benchmark its execution
in the cloud.

First you will have to build the image (alternatively, you can skip this part and
rely on the version available in Docker Hub):
```
./docker/build/kernels.sh
```

## Run in Microk8s

Running in `microk8s` should be straightforward and just a matter of running:
```
microk8s kubectl apply -f ./k8s/deployment.yaml

./k8s/run_benchmark.sh
```

This should generate a data file under the results folder ready to be fed into
the `gnuplot` scripts.

## Running in Azure
