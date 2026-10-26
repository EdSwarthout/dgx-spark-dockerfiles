# uses docker apt-cache and pip-cache

# https://catalog.ngc.nvidia.com/orgs/nvidia/containers/pytorch

ARG VER=26.07-py3
FROM nvcr.io/nvidia/pytorch:${VER}

ARG USERID=ed
ENV USERID=${USERID}
ARG RENDERGID=993
ENV APT_PACKAGES="emacs-nox graphviz libxcb1"

COPY common /common

RUN --mount=type=cache,id=apt-cache,target=/var/cache/apt \
    --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
    /common/jp.sh

USER ${USERID}
WORKDIR /home/${USERID}/Downloads/python
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--no-browser"]
