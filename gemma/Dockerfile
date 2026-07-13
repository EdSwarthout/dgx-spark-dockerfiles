# docker build --progress plain -t gemma .

FROM transformers

USER root

# Fix:
# ERROR: pip's dependency resolver does not currently take into account all the packages that are installed. This behaviour is the source of the following dependency conflicts.
# nvidia-dali-cuda130 2.1.0 requires packaging<=26.0, but you have packaging 26.2 which is incompatible.
# numba 0.64.0 requires numpy<2.5,>=1.22, but you have numpy 2.5.1 which is incompatible.

RUN echo -e 'numpy==2.1.0\npackaging==26.0' > /workspace/constraints.txt

# Add pytest to fix:
# triton-kernels 1.0.0+gitb4e20bb.nv26.5 requires pytest, which is not installed

RUN --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
    pip install -v --break-system-packages --ignore-installed \
    pytest \
    jax[cuda13] \
    -c /workspace/constraints.txt

# Fix:
# datasets 4.8.5 requires fsspec[http]<=2026.2.0,>=2023.1.0, but you have fsspec 2026.6.0 which is incompatible.
# torch 2.12.0a0+5aff3928d8.nv26.5.50603568 requires setuptools<82, but you have setuptools 83.0.0 which is incompatible.

RUN echo -e 'numpy==2.1.0\npackaging==26.0\nfsspec==2026.2.0\nsetuptools==81.0.0' > /workspace/constraints.txt

RUN --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
    pip install -v --break-system-packages --ignore-installed \
    gemma \
    -c /workspace/constraints.txt

# Need for gemma/examples:
RUN --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
    pip install -v --break-system-packages --ignore-installed \
    importlib_resources \
    plotly \
    -c /workspace/constraints.txt

ARG USER=ed
USER ${USER}
WORKDIR /home/${USER}/Downloads/python/pytorch
RUN mkdir /home/${USER}/.gemma
