# docker build --progress plain -t torchaudio .

# https://meta-pytorch.org/torchcodec/stable/index.html

FROM jupyter

#RUN git clone --depth 1 --branch release/2.10 https://github.com/pytorch/audio

#RUN cd audio && \
#    export USE_ROCM=0 && export USE_CUDA=1
# BUILD_RNNT: Enable/disable custom RNN-T loss function.
# USE_ROCM: Enable/disable AMD ROCm support.
# USE_CUDA: Enable/disable CUDA support.

#RUN export PYTORCH_VERSION=2.10.0

#RUN env && pip wheel -e . -v --no-build-isolation

USER root

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    ffmpeg

# need to uninstall 2.10.0a0+a36e1d39eb.nv26.1.42222806 because there is no matching torchaudio
RUN --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
    pip uninstall -y torch torchvision && \
    pip install --pre --index-url https://download.pytorch.org/whl/nightly/cu130 \
    torch \
    torchvision \
    torchaudio \
    torchcodec

ARG USER=ed
USER ${USER}
