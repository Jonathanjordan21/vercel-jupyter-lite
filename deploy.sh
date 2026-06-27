#!/bin/bash
set -e

# 1. Unduh Micromamba biner untuk Linux 64-bit
wget -qO- https://mamba.pm | tar -xvj bin/micromamba

# 2. PENTING: Berikan izin eksekusi (chmod +x) agar Vercel bisa menjalankan micromamba
chmod +x bin/micromamba

# 3. Atur jalur Environment Variables
export MAMBA_ROOT_PREFIX="$PWD/micromamba"
export PATH="$PWD/bin:$PATH"

# 4. Buat environment conda-forge dan langsung instal JupyterLite + Xeus di dalamnya
# Menggabungkan instalasi di sini jauh lebih stabil untuk Vercel daripada lewat pip
bin/micromamba create -n jupyterenv python=3.12 jupyterlite-core jupyterlite-xeus jupyterlite-xeus-python -c conda-forge -y

# 5. Instal sisa paket tambahan dari requirements.txt jika ada (misal: pandas, matplotlib)
bin/micromamba run -n jupyterenv python -m pip install -r requirements.txt

# 6. Bangun JupyterLite dengan menyertakan semua ekstensi biner kernel Xeus
bin/micromamba run -n jupyterenv jupyter lite build --contents content --output-dir dist --federated-extensions
