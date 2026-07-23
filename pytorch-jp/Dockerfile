# uses docker apt-cache and pip-cache

# https://catalog.ngc.nvidia.com/orgs/nvidia/containers/pytorch

ARG VER=26.05-py3
FROM nvcr.io/nvidia/pytorch:${VER}

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

# Prevent:
# ERROR: pip's dependency resolver does not currently take into account all the packages that are installed. This behaviour is the source of the following dependency conflicts.
# nvidia-dali-cuda130 2.1.0 requires packaging<=26.0, but you have packaging 26.2 which is incompatible.
# numba 0.64.0 requires numpy<2.5,>=1.22, but you have numpy 2.5.1 which is incompatible.
# torch 2.12.0a0+5aff3928d8.nv26.5.50603568 requires setuptools<82, but you have setuptools 83.0.0 which is incompatible.
# datasets 4.8.5 requires fsspec[http]<=2026.2.0,>=2023.1.0, but you have fsspec 2026.6.0 which is incompatible.

RUN echo -e 'numpy<2.5\npackaging<=26.0\nsetuptools<82\nfsspec<=2026.2.0' > /workspace/constraints.txt

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
