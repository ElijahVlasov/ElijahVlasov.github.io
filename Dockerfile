# Use the latest debian as the base image
FROM rust:bullseye

# Set environment variables to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-c"]
# Update the package list and install necessary packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl wget \
    ruby-full \
    build-essential \
    zlib1g-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN gem install jekyll bundler 
COPY . /project/
COPY ./scripts/entrypoint.sh /entrypoint.sh
RUN chmod 777 /entrypoint.sh

# Install typst.
# RUN cargo install --locked typst-cli

ENV BASH_ENV=/.bash_env
RUN touch "${BASH_ENV}"
RUN echo '. "${BASH_ENV}"' >> ~/.bashrc

# Installing node-js.
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | PROFILE="${BASH_ENV}" bash
RUN echo node > /.nvmrc
RUN nvm install --lts 

WORKDIR /project

RUN bundle config set --local path '/.gem' \
    && bundle install 
EXPOSE 4000
ENTRYPOINT [ "/entrypoint.sh" ]