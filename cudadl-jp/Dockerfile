# uses docker apt-cache and pip-cache

# https://catalog.ngc.nvidia.com/orgs/nvidia/containers/cuda-dl-base
# https://developer.nvidia.com/cuda/toolkit

# Does not include PyTorch

ARG VER=26.07-cuda13.3-devel-ubuntu24.04
FROM nvcr.io/nvidia/cuda-dl-base:${VER}

ARG USERID=ed
ENV USERID=${USERID}
ENV APT_PACKAGES="emacs-nox libxcb1 python3 python3-pip"

COPY common /common

RUN --mount=type=cache,id=apt-cache,target=/var/cache/apt \
    --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
    /common/jp.sh

# https://github.com/NVIDIA/cudnn-frontend
# cuDNN frontend (cudadl-specific)
# https://raw.githubusercontent.com/jax-ml/jax/refs/heads/main/build/test-requirements.txt
RUN --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
    pip install --break-system-packages --root-user-action=ignore \
    nvidia-cudnn-frontend

# You are not required to use PyTorch; cuDNN also supports other dlpack tensors on the GPU
RUN --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
    pip install --break-system-packages --root-user-action=ignore \
    cupy-cuda13x

RUN --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
    pip install --break-system-packages --root-user-action=ignore \
    jupytext \
    jupyter-ai

RUN --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
    pip install --break-system-packages --root-user-action=ignore \
    mistral-vibe


USER ${USERID}
WORKDIR /home/${USERID}/Downloads/python/cuda
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--no-browser"]
