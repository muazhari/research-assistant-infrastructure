# Initialize base image.
FROM nvidia/cuda:12.3.2-cudnn9-devel-ubuntu22.04

# Update apt repositories.
RUN apt update -y

# Install apt dependencies.
RUN yes | DEBIAN_FRONTEND=noninteractive apt install -y \
    libopencv-dev \
    python3 \
    python3-pip

# Upgrade pip.
RUN pip3 install --upgrade pip

# Install torch
RUN pip3 install torch==2.2.0 torchvision torchaudio

# Install tensorflow
RUN pip3 install tensorflow[and-cuda]==2.15.1

# Copy entrypoint.sh to image.
COPY ./entrypoint.sh /entrypoint.sh

# Set the entrypoint.
ENTRYPOINT ["/entrypoint.sh"]
