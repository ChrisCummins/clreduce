#!/usr/bin/env bash
# TODO: reduce a single test case
export CREDUCE_TEST_CASE=example.cl

export CREDUCE_TEST_PLATFORM=1
export CREDUCE_TEST_DEVICE=0

./scripts/reduction_helper.py \
    --output example_chk \
    --test wrong-code-bug \
    --reduce \
    --verbose \
    --preprocess \
    --test-cases ../../data/clreduce/NVIDIA-GTX-1080/2017-07-08T11:05+01:00/CLProg_58.cl
