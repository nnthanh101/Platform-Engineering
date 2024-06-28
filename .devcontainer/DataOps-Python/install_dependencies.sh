#!/usr/bin/env bash

## Install dependencies packages: 
    # imagemagick graphviz \
    # postgresql-client \
apt-get update && apt-get install -y --no-install-recommends \
    git curl wget jq make \
    gcc build-essential python3-dev \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*