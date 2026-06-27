#!/bin/bash
set -e

# vercel: Amazon Linux 2023
# netlify: Ubuntu 24.04

# Install wget
# yum is not available on netlify, but it´s not a problem because wget is already installed, this validation is just to avoid errors on build step.
if command -v yum &> /dev/null; then
    yum install wget -y
fi

# Download and extract Micromamba
wget -qO- https://micro.mamba.pm/api/micromamba/linux-64/latest | tar -xvj bin/micromamba

# Set up environment variables
export MAMBA_ROOT_PREFIX="$PWD/micromamba"
export PATH="$PWD/bin:$PATH"

# Create the environment
micromamba create -n jupyterenv python=3.12 -c conda-forge -y

# Install dependencies via pip in the micromamba environment
micromamba run -n jupyterenv python -m pip install -r requirements.txt

# Build JupyterLite
micromamba run -n jupyterenv jupyter lite --version

# Debug: confirm files are present
echo "Current directory: $(pwd)"
ls -la environment.yml jupyter_lite_config.json || true

# Build with explicit config file
micromamba run -n jupyterenv jupyter lite build --help-all | grep -i xeus \
    --contents content \
    --output-dir dist \
    --config "$PWD/jupyter_lite_config.json"
# micromamba run -n jupyterenv jupyter lite build \
#     --contents content \
#     --output-dir dist \
#     --XeusPythonEnv.environment_file=environment.yml \
#     --XeusPythonEnv.kernel_name=python
# micromamba run -n jupyterenv jupyter lite build --contents content --output-dir dist
