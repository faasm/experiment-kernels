ARG EXPERIMENTS_VERSION
ARG FAASM_VERSION

FROM faasm/cli:${FAASM_VERSION}

# Download the ParRes Kernels code
WORKDIR /code
RUN git clone -b faasm https://github.com/faasm/Kernels

# Prepare code (the below trick ensures not caching and re-cloning)
ARG FORCE_RECREATE=unknown
RUN git clone https://github.com/faasm/experiment-kernels
WORKDIR /code/experiment-kernels

# Compile LAMMPS
RUN ./build/kernels.py

WORKDIR /usr/local/code/faasm
