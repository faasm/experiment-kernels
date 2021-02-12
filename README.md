# ParRes Kernels

This repo contains the image, deployment files, and scripts to run the
[ParRes Kernels](https://github.com/ParRes/Kernels) and benchmark its execution
in the cloud.

First you will have to build the image (alternatively, you can skip this part and
rely on the version available in Docker Hub):
```
./docker/build/kernels.sh
```

Then, to run the experiments locally:
```
docker run --rm faasm/experiment-kernels-native:0.0.1
```

## Running in Azure
