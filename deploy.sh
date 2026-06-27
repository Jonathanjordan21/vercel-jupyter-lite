#!/bin/bash
set -e

# 1. Instal dependensi standar langsung menggunakan pip bawaan Vercel
pip install -r requirements.txt

# 2. Bangun JupyterLite standar
jupyter lite build --contents content --output-dir dist
