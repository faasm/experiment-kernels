#!/usr/bin/python3

from os import mkdir
from os.path import dirname, exists, join, realpath
from shutil import copy
from subprocess import run
import sys

PRK_DIR = "/code/Kernels"
WASM_DIR = "/usr/local/code/faasm/wasm"


def build(clean=False):
    """
    Compile and install the ParRes kernels
    """

    make_targets = [
        ("MPI1/Synch_global", "global"),
        ("MPI1/Synch_p2p", "p2p"),
        ("MPI1/Sparse", "sparse"),
        ("MPI1/transpose", "transpose"),
        ("MPI1/stencil", "stencil"),
        ("MPI1/dgemm", "dgemm"),
        ("MPI1/nstream", "nstream"),
        ("MPI1/reduce", "reduce"),
        ("MPI1/random", "random"),
    ]

    if clean:
        run("make clean", shell=True, cwd=PRK_DIR)

    # Compile the kernels
    for subdir, make_target in make_targets:
        make_cmd = "make {}".format(make_target)
        make_dir = join(PRK_DIR, subdir)
        res = run(make_cmd, shell=True, cwd=make_dir)

        if res.returncode != 0:
            print(
                "Making kernel in {} with target {} failed.".format(subdir, make_target)
            )
            return

    # Copy the kernels in place
    prk_wasm_dest = join(WASM_DIR, "prk")
    if not exists(prk_wasm_dest):
        mkdir(prk_wasm_dest)
    prk_wasm_src = join(PRK_DIR, "wasm")

    for target in [t[1] for t in make_targets]:
        wasm_src = join(prk_wasm_src, "{}.wasm".format(target))
        wasm_dest = join(prk_wasm_dest, target)
        if not exists(wasm_dest):
            mkdir(wasm_dest)

        copy(wasm_src, join(wasm_dest, "function.wasm"))


if __name__ == "__main__":
    if (len(sys.argv) > 1) and (sys.argv[1] == "clean"):
        build(clean=True)
    else:
        build()
