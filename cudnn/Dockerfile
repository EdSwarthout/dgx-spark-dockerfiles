# https://docs.nvidia.com/deeplearning/cudnn/latest/

FROM transformers

USER root

RUN --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
    pip install --break-system-packages --ignore-installed \
    nvidia-cudnn-frontend

# Install requirements for sample notebooks
RUN --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
    pip install --break-system-packages --ignore-installed \
    -r https://raw.githubusercontent.com/NVIDIA/cudnn-frontend/refs/heads/develop/requirements.txt

# jupyter
# numpy<2.0.0
# pybind11[global]>=2.13,<3
# pytest
# pytest-xdist
# looseversion
# black==26.3.1
# clang-format==21.1.6

# Breaks scipy:
# scipy 1.18.0 requires numpy<2.8,>=2.0.0, but you have numpy 1.26.4 which is incompatible.

ARG USER=ed
USER ${USER}
