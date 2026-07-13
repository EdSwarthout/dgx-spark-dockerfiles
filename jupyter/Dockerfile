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

ENV  PIP_ROOT_USER_ACTION=ignore
# fixes:
# Use the --root-user-action option if you know what you are doing and want to suppress this warning.

RUN --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
    pip install -U --break-system-packages pip && \
    pip config set global.break-system-packages true
# fixes:
#  WARNING: Running pip as the 'root' user can result in broken permissions and conflicting behaviour with the system package manager, possibly rendering your system unusable


# Freeze jupyter_server at v2.19.0 because of:
# https://github.com/jupyter-server/jupyter_server/issues/1672

RUN --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
    pip install -U --break-system-packages \
    ipykernel \
    ipywidgets \
    jupyter_client \
    jupyter_server==v2.19.0 \
    jupyter_core \
    jupyterlab \
    jupyterlab_execute_time \
    notebook \
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
