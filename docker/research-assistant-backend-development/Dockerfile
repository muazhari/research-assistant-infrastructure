# Initialize the base image.
FROM muazhari/research-assistant-backend:latest

# Install apt dependencies.
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-fast update -y \
    && \
    yes | apt-fast install -y \
    openssh-server \
    git

# Setup sshd.
RUN mkdir /var/run/sshd
RUN echo 'root:root' | chpasswd
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config

# Copy the requirements.txt file to the working directory.
COPY ./requirements.txt $WORKDIR/requirements-dev.txt

# Install python dependencies from requirements.txt.
RUN --mount=type=cache,target=/root/.cache/pip \
    --mount=type=cache,target=/root/.cache/uv \
    uv pip install --system \
    -r requirements-dev.txt \
    --break-system-packages \
    --no-build-isolation


