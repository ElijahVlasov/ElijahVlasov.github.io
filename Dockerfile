# Use the latest debian as the base image
FROM rust:bullseye

RUN useradd -ms /bin/bash debian 

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
COPY . /home/debian/project/
RUN chown -R debian /home/debian/project/
USER debian

# Install typst.
RUN cargo install --locked typst-cli

ENV BASH_ENV=/home/debian/.bash_env
RUN touch "${BASH_ENV}"
RUN echo '. "${BASH_ENV}"' >> ~/.bashrc

# Installing node-js.
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | PROFILE="${BASH_ENV}" bash
RUN echo node > /home/debian/.nvmrc
RUN nvm install --lts 

WORKDIR /home/debian/project

RUN bundle config set --local path '/home/debian/.gem' \
    && bundle install 
EXPOSE 4000
ENTRYPOINT [ "/bin/bash" ]