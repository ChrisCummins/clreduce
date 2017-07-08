#!/usr/bin/env bash
#
# For i in 1 ... 1000:
#   1. Generate a program using CLSmith
#   2. Preprocess
#   3. Reduce workgroup size
#   4. Difftest using oclgrind oracle
#   5. If 'interesting', reduce using creduce
#
usage() {
    echo "usage: $0 <platform-id> <device-id> <output-dir>"
}

if [ $# -ne 3 ]; then
    usage >&2
    exit 1
fi

set -eux

export CREDUCE_TEST_PLATFORM=$1
export CREDUCE_TEST_DEVICE=$2
export OUTPUT_DIR=$3

echo "Testing platform $CREDUCE_TEST_PLATFORM, device $CREDUCE_TEST_DEVICE"

# Paths
export PATH=$(pwd)/build_oclgrind:$(pwd)/build_clsmith:$(pwd)/build_llvm/bin:$PATH
export PYTHONPATH=$(pwd)
export CLSMITH_PATH=$(pwd)/build_clsmith
export CLSMITH_INCLUDE_PATH=$(pwd)/build_clsmith
export CREDUCE_LIBCLC_INCLUDE_PATH=$(pwd)/libclc/generic/include
export CREDUCE_TEST_CL_LAUNCHER=$(pwd)/build_clsmith/cl_launcher
export CREDUCE_TEST_CLANG=$(pwd)/build_llvm/bin/clang

# 60 seconds for device being tested, oclgrind is hardcoded at 300 seconds
export CREDUCE_TEST_TIMEOUT=60

# Use Oclgrind as Oracle (1) or compare optimised vs. unoptimised (0)
export CREDUCE_TEST_USE_ORACLE=1
# Only if oracle is used: Which optimisation level should be checked and
# has to be miscompiled to make the test case interesting
export CREDUCE_TEST_OPTIMISATION_LEVEL=either
# Check result access and get_linear_global_id
export CREDUCE_TEST_CONSERVATIVE=1
# Enable static checks in the interestingness test
export CREDUCE_TEST_STATIC=1

python3 ./scripts/reduction_helper.py \
    --generate 1000 \
    --modes barriers atomics atomic_reductions vectors inter_thread_comm \
    --preprocess \
    --reduce-work-sizes-unchecked \
    --output $OUTPUT_DIR \
    --test wrong-code-bug \
    --check \
    --reduce \
    -n 4 \
    --verbose
