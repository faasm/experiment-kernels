FROM faasm/grpc-root:0.0.16

# Download and install OpenMPI
WORKDIR /tmp
RUN wget https://download.open-mpi.org/release/open-mpi/v4.1/openmpi-4.1.0.tar.bz2
RUN tar xf openmpi-4.1.0.tar.bz2
WORKDIR /tmp/openmpi-4.1.0
RUN ./configure --prefix=/usr/local
RUN make -j `nproc`
RUN make install
# The previous steps takes a lot, so don't move these lines

# Add an mpirun user
ENV USER mpirun
RUN adduser --disabled-password --gecos "" ${USER} && \
    echo "${USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
RUN apt update 
# Dev tools delete eventually
RUN apt install -y gdb vim 

USER mpirun

# Download LAMMPS code
WORKDIR /code
RUN git clone -b native https://github.com/faasm/Kernels

# Prepare code (the below trick ensures not caching and re-cloning)
ARG FORCE_RECREATE=unknown
RUN git clone https://github.com/faasm/experiment-kernels
WORKDIR /code/experiment-kernels

# Compile LAMMPS
RUN ./build/kernels.sh

ENTRYPOINT ./run/all.sh
