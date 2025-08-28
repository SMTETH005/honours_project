#!/bin/bash

# setup_adcp_env.sh
# Sets up a clean ADCP processing environment on Ubuntu using Conda and pip
# Logs output to setup_adcp_env.log

set -e  # Exit immediately on error
exec > >(tee -a setup_adcp_env.log) 2>&1  # Log everything to file

echo "========================================"
echo " Starting ADCP Processing Environment Setup"
echo "========================================"

# PRE-CHECKS
echo "--- Checking prerequisites"

command -v conda >/dev/null 2>&1 || {
    echo "ERROR: Conda is not installed or not found in PATH. Please install Miniconda first."
    exit 1
}

command -v git >/dev/null 2>&1 || {
    echo "ERROR: Git is not installed. Install with: sudo apt install git"
    exit 1
}

command -v hg >/dev/null 2>&1 || {
    echo "Mercurial not found. Installing via apt..."
    sudo apt update && sudo apt install -y mercurial
}

# Ensure conda is initialized for bash
if ! grep -q "conda.sh" ~/.bashrc; then
    echo "--- Initializing conda for bash"
    conda init bash
    echo "Please restart your terminal or run 'source ~/.bashrc' to apply changes."
fi

# STEP 1: Create working directory
echo "--- Creating ~/adcp working directory"
mkdir -p ~/adcp
cd ~/adcp

# STEP 2: Create Conda environment
echo "--- Creating conda environment 'adcp37' with Python 3.7"
conda create -y -n adcp37 python=3.7

# STEP 3: Activate environment
echo "--- Activating conda environment"
source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate adcp37

# STEP 4: Configure channels
echo "--- Configuring conda channels"
conda config --add channels conda-forge
conda config --set channel_priority strict

# STEP 5: Install required packages
echo "--- Installing core Python packages"
conda install -y numpy scipy pip pandas netCDF4 xarray gsw matplotlib=3.5 shapely cython

echo "--- Installing specific versions of JupyterLab and webcolors"
pip install jupyterlab==3.0.17 webcolors==1.11.1
pip install ruamel.yaml

# STEP 6: Create a Jupyter kernel
echo "--- Registering 'adcp37' Jupyter kernel"
python -m ipykernel install --user --name adcp37 --display-name "Python (adcp37)"

# STEP 7: Clone and install ttide_py
echo "--- Cloning and installing ttide_py"
git clone https://github.com/moflaher/ttide_py.git
pip install -e ./ttide_py

# STEP 8: Clone and install pycurrents
echo "--- Cloning and installing pycurrents"
hg clone http://currents.soest.hawaii.edu/hg/pycurrents
pip install -e ./pycurrents

# STEP 9: Clone and install pycurrents_ADCP_processing
echo "--- Cloning and installing pycurrents_ADCP_processing"
git clone https://github.com/IOS-OSD-DPG/pycurrents_ADCP_processing.git
pip install -e ./pycurrents_ADCP_processing

# STEP 10: Optionally start JupyterLab
echo "--- Launching JupyterLab in background (optional)"
cd ~/adcp/pycurrents_ADCP_processing/pycurrents_ADCP_processing
nohup jupyter lab --port 8888 --no-browser > jupyter_lab.log 2>&1 &
echo "JupyterLab is running in the background. Access via http://localhost:8888"

# DONE
echo "========================================"
echo " ADCP Environment Setup Complete!"
echo " Environment name: adcp37"
echo " JupyterLab log: $(pwd)/jupyter_lab.log"
echo " Log saved to: ~/adcp/setup_adcp_env.log"
echo "========================================"
