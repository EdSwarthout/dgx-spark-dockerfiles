# uses docker apt-cache and pip-cache

# https://catalog.ngc.nvidia.com/orgs/nvidia/containers/cuda-dl-base
# https://developer.nvidia.com/cuda/toolkit

# Does not include PyTorch

ARG VER=26.07-cuda13.3-devel-ubuntu24.04
FROM nvcr.io/nvidia/cuda-dl-base:${VER}

# Keep /var/cache/apt.  Note: apt-get keeps debs, add config so apt also keeps
RUN rm /etc/apt/apt.conf.d/docker-clean || true
RUN echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/01keep-debs

ENV DEBIAN_FRONTEND=noninteracive

RUN --mount=type=cache,id=apt-cache,target=/var/cache/apt \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    emacs-nox \
    libxcb1 \
    python3 \
    python3-pip \
    && \
    rm -rf /var/lib/apt/lists/*

COPY .emacs /root

ENV PIP_ROOT_USER_ACTION=ignore
# fixes:
# Use the --root-user-action option if you know what you are doing and want to suppress this warning.

RUN --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
    pip install -U --break-system-packages --ignore-installed pip && \
    pip config set global.break-system-packages true

RUN --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
    pip install -U --break-system-packages \
    ipykernel \
    ipython \
    ipywidgets \
    jupyter_client \
    jupyter_core \
    jupyter_server==v2.19.0 \
    jupyterlab \
    jupyterlab_execute_time \
    notebook \
    pydot

RUN jupyter labextension disable "@jupyterlab/apputils-extension:announcements"

# Remove noisy startup messages
RUN rm /opt/nvidia/entrypoint.d/*.txt

# https://raw.githubusercontent.com/jax-ml/jax/refs/heads/main/build/test-requirements.txt
RUN --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
    pip install --break-system-packages \
    nvidia-cudnn-frontend


# You are not required to use PyTorch; cuDNN also supports other dlpack tensors on the GPU
RUN --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
    pip install --break-system-packages \
    cupy-cuda13x

# userid=ubuntu is uid 1000
# uid 1001
ARG USERID=ed
ENV USERID=${USERID}

RUN useradd -m -s /bin/bash ${USERID}

USER ${USERID}

RUN mkdir /home/${USERID}/.cache

COPY --chown=${USERID}:${USERID} .emacs /home/${USERID}/

WORKDIR /home/${USERID}/Downloads/python/cuda

CMD ["jupyter", "lab"]
