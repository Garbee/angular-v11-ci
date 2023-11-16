# hadolint global ignore=DL3008,SC2239,DL3015
FROM ubuntu:22.04

ARG NODE_MAJOR=14
ARG hadolintArm="https://github.com/hadolint/hadolint/releases/download/v2.12.0/hadolint-Linux-arm64"
ARG hadolintAmd="https://github.com/hadolint/hadolint/releases/download/v2.12.0/hadolint-Linux-x86_64"
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/New_York

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
# hadolint shell=bash

RUN apt-get update \
  && apt-get install ca-certificates curl gnupg build-essential make -y \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN if [ "${BUILDARCH}" = "amd64" ]; then \
  curl -o /usr/bin/hadolint "${hadolintAmd}"; \
  else \
  curl -o /usr/bin/hadolint "${hadolintArm}"; \
  fi

RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
  && curl -sL https://deb.nodesource.com/setup_14.x | bash - \
  && apt-get update \
  && apt-get install gh yamllint jq shellcheck nodejs chromium-browser -y \
  && npm install -g @ls-lint/ls-lint @angular/cli@11 \
  && npx playwright install-deps \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

