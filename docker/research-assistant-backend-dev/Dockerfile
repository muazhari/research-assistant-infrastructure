# Initialize the base image.
FROM muazhari/research-assistant-backend:latest

# Copy the requirements.txt file to the working directory.
COPY ./requirements.txt $WORKDIR/requirements-dev.txt

# Install python dependencies from requirements.txt.
RUN pip3 install -r requirements-dev.txt --use-feature=fast-deps


