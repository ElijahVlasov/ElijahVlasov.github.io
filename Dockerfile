# Use the latest Ubuntu as the base image
FROM ubuntu:latest

# Set environment variables to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-c"]
# Update the package list and install necessary packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    ruby-full \
    build-essential \
    zlib1g-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Verify Ruby installation
RUN gem install jekyll bundler 
COPY . /home/ubuntu/project/
RUN chown -R ubuntu /home/ubuntu/project/
USER ubuntu

ENV BASH_ENV=/home/ubuntu/.bash_env
RUN touch "${BASH_ENV}"
RUN echo '. "${BASH_ENV}"' >> ~/.bashrc

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | PROFILE="${BASH_ENV}" bash
RUN echo node > /home/ubuntu/.nvmrc
RUN nvm install --lts 

WORKDIR /home/ubuntu/project
RUN bundle config set --local path '/home/ubuntu/.gem' \
    && bundle install 
EXPOSE 4000
ENTRYPOINT [ "/bin/bash" ]