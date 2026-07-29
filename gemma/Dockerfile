# https://github.com/google/gemma_pytorch
# https://deepmind.google/models/gemma/

FROM jax-jp

USER root

RUN --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
    pip install pip-tools && \
    mkdir -p /workspace/gemma && cd /workspace/gemma && \
    wget https://raw.githubusercontent.com/google-deepmind/gemma/refs/tags/v4.0.1/pyproject.toml

# main causes:
# ERROR: Could not find a version that satisfies the requirement bagz (from versions: none)
#    wget https://raw.githubusercontent.com/google-deepmind/gemma/refs/heads/main/pyproject.toml

RUN --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
    cd /workspace/gemma && \
    pip-compile pyproject.toml && \
    echo "pyproject based requirements" && cat /workspace/gemma/requirements.txt


# /usr/local/lib/python3.12/dist-packages/jaxlib/plugin_support.py:92:
# RuntimeWarning: JAX plugin jax_cuda13_plugin version 0.10.1.dev20260728 is installed, but it is not compatible with the installed jaxlib version 0.11.0, so it will not be used.

# Add no-deps to fix:
# Collecting jax>=0.7.0 (from chex==0.1.92->-r requirements-fixed.txt (line 93))

COPY requirements-fixed.txt /workspace/gemma

RUN --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
    cd /workspace/gemma && \
    pip install --no-deps -v --break-system-packages --ignore-installed \
    -r requirements-fixed.txt

RUN --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
    pip install --no-deps -v --break-system-packages --ignore-installed \
    gemma==v4.0.1

# Need for gemma/examples:
RUN --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
    pip install -v --break-system-packages --ignore-installed \
    importlib_resources \
    plotly

ARG USER=ed
USER ${USER}
WORKDIR /home/${USER}/Downloads/python/pytorch
RUN mkdir /home/${USER}/.gemma
