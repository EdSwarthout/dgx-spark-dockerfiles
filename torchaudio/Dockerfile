# docker build --progress plain -t torchaudio .

# https://meta-pytorch.org/torchcodec/stable/index.html

FROM jupyter

USER root
RUN --mount=type=cache,id=apt-cache,target=/var/cache/apt \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    ffmpeg \
    && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /workspace/src

RUN pwd && \
    python -c "import torch; print(torch.version.cuda)"

RUN git clone --depth 1 --branch release/2.11 https://github.com/pytorch/audio

WORKDIR /workspace/src/audio

RUN export USE_ROCM=0 && \
    export USE_CUDA=1 && \
    env | sort

RUN --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
    pip install --editable . -vv --no-build-isolation

# RUN --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
#     pip install --pre --index-url https://download.pytorch.org/whl/nightly/cu130 \
#     torch \
#     torchvision \
#     torchaudio \
#     torchcodec
#
# #    torchao

ARG USER=ed
WORKDIR /home/${USER}/Downloads/python/pytorch
USER ${USER}
