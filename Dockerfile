FROM codercom/enterprise-base:latest

USER root

RUN apt-get update

# utils
RUN apt-get install -y --no-install-recommends \
    zip \
    unzip \
    net-tools \
    inetutils-ping \
    telnet \
    dnsutils \
    tree \
    jq \
    rsync \
    traceroute \
    ncdu \
    xz-utils \
    httpie \
    rclone \
    fuse

# dev tools
RUN apt-get install -y --no-install-recommends \
    build-essential \
    make \
    cmake \
    g++ \
    gcc \
    llvm \
    git \
    gnupg

# dev libraries
RUN apt install -y --no-install-recommends \
    libssl-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libsqlite3-dev \
    libreadline-dev \
    libtk8.6 \
    libgdm-dev \
    libpcap-dev \
    libbz2-dev \
    libffi-dev \
    liblzma-dev \
    zlib1g-dev \
    tk-dev \
    libpq-dev \
    libxmlsec1-dev

# Docker client
RUN curl -fsSL https://get.docker.com | sh

# Docker Compose
RUN mkdir -p /usr/local/lib/docker/cli-plugins
RUN curl -fsSL "https://github.com/docker/compose/releases/download/v2.35.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/lib/docker/cli-plugins/docker-compose && chmod +x /usr/local/lib/docker/cli-plugins/docker-compose


# kubectl
# RUN wget -P /usr/local/bin https://storage.googleapis.com/kubernetes-release/release/v1.19.1/bin/linux/amd64/kubectl
# RUN chmod +x /usr/local/bin/kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm kubectl

# Go
COPY --from=golang:1.17 /usr/local/go /usr/local/go
ENV PATH=$PATH:/usr/local/go/bin

# Postgres Client
RUN apt-get install -y --no-install-recommends postgresql

# terraform
RUN wget https://releases.hashicorp.com/terraform/1.9.8/terraform_1.9.8_linux_amd64.zip && \
    unzip *.zip && \
    mv terraform /usr/local/bin && \
    rm *.zip

# k9s
RUN wget -O - https://github.com/derailed/k9s/releases/download/v0.29.1/k9s_Linux_amd64.tar.gz | tar zx && \
    mv k9s /usr/local/bin

# awscli
RUN wget https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip && \
    unzip *.zip && \
    ./aws/install && \
    rm *.zip && \
    rm -rf aws

# helm
COPY --from=alpine/helm /usr/bin/helm /usr/bin/helm

# jwt-cli
RUN wget -O - https://github.com/mike-engel/jwt-cli/releases/download/6.2.0/jwt-linux.tar.gz | tar zx && \
    mv jwt /usr/local/bin

# uv
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/



USER coder
