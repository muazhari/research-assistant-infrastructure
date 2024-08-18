# Initialize the base image.
FROM muazhari/research-assistant-backend:latest

# SSH server setup.
RUN apt update -y

RUN yes | DEBIAN_FRONTEND=noninteractive apt install -y \
    openssh-server

RUN mkdir /var/run/sshd

RUN echo 'root:root' | chpasswd

RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config

# Copy the requirements.txt file to the working directory.
COPY ./requirements.txt $WORKDIR/requirements-dev.txt

# Install python dependencies from requirements.txt.
RUN pip3 install -r requirements-dev.txt --use-feature=fast-deps --break-system-packages


