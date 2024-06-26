#!/usr/bin/env bash

## Install dependencies packages
apt-get update && apt-get install -y --no-install-recommends \
    git curl wget jq \
    imagemagick graphviz \
    build-essential python3-dev \
    postgresql-client \
&& rm -rf /var/lib/apt/lists/* \
&& apt-get clean