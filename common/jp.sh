#!/bin/sh
set -e
# Common Jupyter + Emacs + non-root-user provisioning for the JP base images
#
# Env expected before RUN:
#   APT_PACKAGES  space-separated apt packages to install
#   USERID        non-root user name (default: ed)

USERID="${USERID:-ed}"
export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get upgrade -y
apt-get install -y --no-install-recommends ${APT_PACKAGES}
rm -rf /var/lib/apt/lists/*

# pip bootstrap (root)
export PIP_ROOT_USER_ACTION=ignore
pip install -U --break-system-packages --ignore-installed pip
pip config set global.break-system-packages true

# jupyter stack
pip install -U --break-system-packages \
    ipykernel \
    ipython \
    ipywidgets \
    jupyter_client \
    jupyter_core \
    jupyter_server>=2.21.1 \
    jupyterlab \
    jupyterlab_execute_time \
    jupytext \
    notebook \
    pydot

jupyter labextension disable "@jupyterlab/apputils-extension:announcements"

# remove noisy NGC startup messages
rm -f /opt/nvidia/entrypoint.d/*.txt

cp /common/.emacs /root/.emacs

useradd -m -s /bin/bash ${USERID}

# NVIDIA Container Toolkit adds host's render gid to user when using --gpus
groupadd -g ${RENDERGID} render

mkdir -p /home/${USERID}/.cache/huggingface
mkdir -p /home/${USERID}/.cache/gemma
mkdir -p /home/${USERID}/.local
cp /common/.emacs /home/${USERID}/.emacs
chown -R ${USERID}:${USERID} /home/${USERID}
