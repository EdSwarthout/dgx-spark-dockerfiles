# uses docker apt-cache and pip-cache

# https://catalog.ngc.nvidia.com/orgs/nvidia/containers/jax
# https://docs.jax.dev/en/latest/index.html

ARG VER=26.05-py3
FROM nvcr.io/nvidia/jax:${VER}

# Keep /var/cache/apt.  Note: apt-get keeps debs, add config so apt also keeps
RUN rm /etc/apt/apt.conf.d/docker-clean || true
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

ENV PIP_ROOT_USER_ACTION=ignore
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
    pip install -U --break-system-packages \
    absl-py \
    auditwheel \
    cloudpickle \
    filelock \
    flatbuffers \
    hypothesis==6.142.1 \
    matplotlib \
    mpmath==1.3.0 \
    pillow>=11.3 \
    portpicker \
    pytest \
    pytest-xdist \
    rich \
    scipy-stubs

# userid=ubuntu is uid 1000
# uid 1001
ARG USERID=ed
ENV USERID=${USERID}

RUN useradd -m -s /bin/bash ${USERID}

USER ${USERID}

RUN mkdir /home/${USERID}/.cache

COPY --chown=${USERID}:${USERID} .emacs /home/${USERID}/

WORKDIR /home/${USERID}/Downloads/python

CMD ["jupyter", "lab"]
