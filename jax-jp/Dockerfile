# uses docker apt-cache and pip-cache

# https://catalog.ngc.nvidia.com/orgs/nvidia/containers/jax
# https://docs.jax.dev/en/latest/index.html

ARG VER=26.07-py3
FROM nvcr.io/nvidia/jax:${VER}

ARG USERID=ed
ENV USERID=${USERID}
ARG RENDERGID=993
ENV APT_PACKAGES="emacs-nox graphviz libxcb1"

COPY common /common

RUN --mount=type=cache,id=apt-cache,target=/var/cache/apt \
    --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
    /common/jp.sh

# JAX-specific test requirements
# https://raw.githubusercontent.com/jax-ml/jax/refs/heads/main/build/test-requirements.txt
RUN --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
    pip install -U --break-system-packages \
    absl-py auditwheel cloudpickle filelock flatbuffers \
    hypothesis==6.142.1 matplotlib mpmath==1.3.0 pillow>=11.3 \
    portpicker pytest pytest-xdist rich scipy-stubs

USER ${USERID}
WORKDIR /home/${USERID}/Downloads/python
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--no-browser"]
