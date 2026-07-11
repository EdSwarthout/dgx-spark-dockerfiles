# docker build --progress plain -t jupyter .
# uses docker apt-cache and pip-cache

# https://catalog.ngc.nvidia.com/orgs/nvidia/containers/pytorch

ARG VER=26.05-py3
FROM nvcr.io/nvidia/pytorch:${VER}

# Keep /var/cache/apt.  Note: apt-get keeps debs, add config so apt also keeps
RUN rm /etc/apt/apt.conf.d/docker-clean
RUN echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/01keep-debs

ENV DEBIAN_FRONTEND=noninteracive

RUN --mount=type=cache,id=apt-cache,target=/var/cache/apt \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    emacs-nox \
    graphviz \
    libxcb1 \
    && \
    rm -rf /var/lib/apt/lists/*

COPY .emacs /root

RUN --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
    pip install -U pip

RUN --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
    pip install \
    ipywidgets \
    jupyterlab_execute_time \
    pydot

RUN jupyter labextension disable "@jupyterlab/apputils-extension:announcements"

# userid=ubuntu is uid 1000
# uid 1001
ARG USER=ed
RUN useradd -m -s /bin/bash ${USER}

USER ${USER}
RUN mkdir /home/${USER}/.cache

COPY --chown=${USER}:${USER} .emacs /home/${USER}/

WORKDIR /home/${USER}/Downloads/python/pytorch

CMD ["jupyter", "lab"]
