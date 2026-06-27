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

# micromamba install -n jupyterenv -c conda-forge jupyterlite-xeus

# Build JupyterLite
micromamba run -n jupyterenv jupyter lite --version

# Debug: confirm files are present
echo "Current directory: $(pwd)"
ls -la environment.yml jupyter_lite_config.json || true

micromamba run -n jupyterenv python -m pip show jupyterlite-xeus
micromamba run -n jupyterenv python -m pip show empack
micromamba run -n jupyterenv python -m pip show jupyterlite-xeus | grep Requires

micromamba run -n jupyterenv python - <<'PY'
import inspect
import jupyterlite_xeus.add_on

print(jupyterlite_xeus.add_on.__file__)
PY

grep -n "DEFAULT_CONFIG_PATH" \
$(micromamba run -n jupyterenv python - <<'PY'
import jupyterlite_xeus.add_on
print(jupyterlite_xeus.add_on.__file__)
PY
)

grep -n "pkg_file_filter_from_yaml" \
$(micromamba run -n jupyterenv python - <<'PY'
import jupyterlite_xeus.add_on
print(jupyterlite_xeus.add_on.__file__)
PY
)

micromamba run -n jupyterenv python - <<'PY'
import empack
import empack.file_patterns

print(empack.__file__)
print(empack.file_patterns.__file__)
print(dir(empack.file_patterns))
PY

sed -n '1,60p' /vercel/path0/.vercel_python_packages/jupyterlite_xeus/add_on.py
grep -n "DEFAULT_CONFIG_PATH" \
/vercel/path0/.vercel_python_packages/empack/file_patterns.py

micromamba run -n jupyterenv python - <<'PY'
import empack.pack
print(empack.pack.__file__)
print("DEFAULT_CONFIG_PATH =", empack.pack.DEFAULT_CONFIG_PATH)
PY

rm -rf dist .jupyterlite
# micromamba run -n jupyterenv jupyter lite build --contents content --output-dir dist

# Build with explicit config file
# micromamba run -n jupyterenv jupyter lite build \
#     --contents content \
#     --output-dir dist \
#     --config "$PWD/jupyter_lite_config.json"
# micromamba run -n jupyterenv jupyter lite build \
#     --contents content \
#     --output-dir dist \
#     --XeusPythonEnv.environment_file=environment.yml \
#     --XeusPythonEnv.kernel_name=python
# micromamba run -n jupyterenv jupyter lite build --help-all | grep -i "environment"
# micromamba run -n jupyterenv jupyter lite build --contents content --output-dir dist
# Build with explicit config file
micromamba run -n jupyterenv \
    jupyter lite build \
    --contents content \
    --output-dir dist \
    --XeusAddon.environment_file=environment.yml
# micromamba run -n jupyterenv jupyter lite build \
#     --contents content \
#     --output-dir dist \
#     --config "$PWD/lite_config.py"
