# Dockerfile for dag unit testing with PR patches
# Usage: docker build -t dag-test .

FROM golang:1.21-alpine

# Install system dependencies
RUN apk add --no-cache \
    git \
    curl \
    ca-certificates \
    bash

# Set working directory
WORKDIR /app

# Clone the repository
ARG REPO_URL=https://github.com/wmcxwh/dag.git
ARG BRANCH=master
RUN git clone --depth=100 ${REPO_URL} . && git checkout ${BRANCH}

# Apply PR #2 (Golden solution) patch
RUN curl -fsSL https://github.com/wmcxwh/dag/pull/2.patch | git apply --3way || true

# Apply PR #1 (Test_Patch) patch
RUN curl -fsSL https://github.com/wmcxwh/dag/pull/1.patch | git apply --3way || true

# Download Go dependencies
RUN go mod download

CMD ["bash"]
