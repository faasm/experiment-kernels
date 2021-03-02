ARG EXPERIMENTS_VERSION

FROM faasm/experiment-base-native:${EXPERIMENTS_VERSION}

# Download the ParRes Kernels code
WORKDIR /code
RUN git clone -b native https://github.com/faasm/Kernels

# Prepare code (the below trick ensures not caching and re-cloning)
ARG FORCE_RECREATE=unknown
RUN git clone https://github.com/faasm/experiment-kernels
WORKDIR /code/experiment-kernels

# Compile the Kernels code
RUN ./build/kernels_native.sh

# Start the SSH server for reachability
WORKDIR /home/mpirun
CMD ["/usr/sbin/sshd", "-D"]
