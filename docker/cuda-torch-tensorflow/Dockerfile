# Initialize base image.
FROM nvidia/cuda:12.6.0-cudnn-devel-ubuntu24.04

# Update apt repositories.
RUN apt update -y

# Install apt dependencies.
RUN yes | DEBIAN_FRONTEND=noninteractive apt install -y \
    python3 \
    python3-pip

# Install torch
RUN pip3 install torch torchvision torchaudio --index-url=https://download.pytorch.org/whl/cu124 --use-feature=fast-deps --break-system-packages

# Install tensorflow
RUN pip3 install tensorflow[and-cuda] --use-feature=fast-deps --break-system-packages
