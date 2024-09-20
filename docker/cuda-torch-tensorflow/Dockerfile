# Initialize base image.
FROM nvidia/cuda:12.6.1-cudnn-devel-ubuntu24.04
COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/uv

# Setup apt.
ENV DEBIAN_FRONTEND=noninteractive
RUN rm -f /etc/apt/apt.conf.d/docker-clean; echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache

# Install apt dependencies.
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt update -y \
    && \
    yes | apt install -y \
    software-properties-common \
    && \
    add-apt-repository ppa:apt-fast/stable -y \
    && \
    yes | apt install -y \
    apt-fast \
    aria2 \
    && \
    yes | apt-fast install -y \
    python3 \
    python3-pip

# Install pip dependencies.
RUN --mount=type=cache,target=/root/.cache/pip \
    --mount=type=cache,target=/root/.cache/uv \
    uv pip install --system \
    torch==2.4.1+cu124 \
    torchvision==0.19.1+cu124 \
    torchaudio==2.4.1+cu124 \
    --index-url=https://download.pytorch.org/whl/cu124 \
    --break-system-packages \
    && \
    uv pip install --system \
    tensorflow[and-cuda] \
    --break-system-packages
