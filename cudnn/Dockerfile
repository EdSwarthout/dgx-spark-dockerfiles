# https://docs.nvidia.com/deeplearning/cudnn/latest/

FROM transformers

USER root

RUN --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
    pip install --break-system-packages --ignore-installed \
    nvidia-cudnn-frontend \
    -c /workspace/constraints.txt

# Install requirements for sample notebooks
RUN --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
    pip install --break-system-packages --ignore-installed \
    -r https://raw.githubusercontent.com/NVIDIA/cudnn-frontend/refs/heads/develop/requirements.txt \
    -c /workspace/constraints.txt

ARG USER=ed
USER ${USER}
