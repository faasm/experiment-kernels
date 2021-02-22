ARG EXPERIMENTS_VERSION
ARG FAASM_VERSION

FROM faasm/cli:${FAASM_VERSION}

# Python set up
# TODO - include via multi-stage build
WORKDIR /usr/local/code/faasm-toolchain
RUN pip3 install -e .
WORKDIR /usr/local/code/faasm
RUN pip3 install -r faasmcli/requirements.txt
RUN pip3 install -e faasmcli/

# Download the ParRes Kernels code
WORKDIR /code
RUN git clone -b faasm https://github.com/faasm/Kernels

# Prepare code (the below trick ensures not caching and re-cloning)
ARG FORCE_RECREATE=unknown
RUN git clone https://github.com/faasm/experiment-kernels
WORKDIR /code/experiment-kernels

# Compile the ParRes Kernels
RUN ./build/kernels.py
