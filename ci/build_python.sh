#!/bin/bash
# Copyright (c) 2022, NVIDIA CORPORATION.

set -euo pipefail

source rapids-env-update

export CMAKE_GENERATOR=Ninja

rapids-print-env

rapids-logger "Begin py build"

CPP_CHANNEL=$(rapids-download-conda-from-s3 cpp)
PY_VER=${RAPIDS_PY_VERSION//./}
LIBCUDF_CHANNEL=$(rapids-get-artifact ci/cudf/pull-request/12587/046025a/cudf_conda_cpp_cuda11_$(arch).tar.gz)
CUDF_CHANNEL=$(rapids-get-artifact ci/cudf/pull-request/12587/046025a/cudf_conda_python_cuda11_${PY_VER}_$(arch).tar.gz)


# TODO: Remove `--no-test` flag once importing on a CPU
# node works correctly
rapids-mamba-retry mambabuild \
  --no-test \
  --channel "${CPP_CHANNEL}" \
  --channel "${LIBCUDF_CHANNEL}" \
  --channel "${CUDF_CHANNEL}" \
  conda/recipes/cuspatial

rapids-upload-conda-to-s3 python
