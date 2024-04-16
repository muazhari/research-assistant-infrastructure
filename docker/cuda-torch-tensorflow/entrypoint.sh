#!/bin/sh

# Tensorflow 2.16.1 GPU bug fix: https://github.com/tensorflow/tensorflow/issues/63362#issuecomment-2016019354
export NVIDIA_DIR=$(dirname $(dirname $(python3 -c "import nvidia.cudnn;print(nvidia.cudnn.__file__)")))
export LD_LIBRARY_PATH=$(echo ${NVIDIA_DIR}/*/lib/ | sed -r 's/\s+/:/g')${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}

# TensorRT not found error fix: https://github.com/tensorflow/tensorflow/issues/61468#issuecomment-1981455966
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/TensorRT-8.6.1.6/lib
export TF_ENABLE_ONEDNN_OPTS=0

exec "$@"