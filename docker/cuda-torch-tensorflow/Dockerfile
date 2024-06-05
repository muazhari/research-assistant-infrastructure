# Initialize base image.
FROM nvidia/cuda:12.4.1-cudnn-devel-ubuntu22.04

# Update apt repositories.
RUN apt update -y

# Install apt dependencies.
RUN yes | DEBIAN_FRONTEND=noninteractive apt install -y \
    python3 \
    python3-pip

# Upgrade pip.
RUN pip3 install --upgrade pip --use-feature=fast-deps

# Install torch
RUN pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121 --use-feature=fast-deps

# Install tensorflow
RUN pip3 install tensorflow[and-cuda] --use-feature=fast-deps

# Download TensorRT 8.6.1.
RUN yes | DEBIAN_FRONTEND=noninteractive apt install -y aria2
RUN aria2c https://developer.nvidia.com/downloads/compute/machine-learning/tensorrt/secure/8.6.1/tars/TensorRT-8.6.1.6.Linux.x86_64-gnu.cuda-12.0.tar.gz
RUN tar -xzvf TensorRT-8.6.1.6.Linux.x86_64-gnu.cuda-12.0.tar.gz
RUN rm TensorRT-8.6.1.6.Linux.x86_64-gnu.cuda-12.0.tar.gz

# Copy entrypoint.sh to image.
COPY ./entrypoint.sh /entrypoint.sh

# Set the entrypoint.
ENTRYPOINT ["/entrypoint.sh"]
