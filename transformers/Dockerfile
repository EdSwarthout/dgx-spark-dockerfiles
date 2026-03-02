# docker build --progress plain -t transformers .

FROM torchaudio AS transformers

USER root

RUN pip install \
    accelerate \
    diffusers \
    transformers>=4.51.3

ARG USER=ed
USER ${USER}
WORKDIR /home/${USER}/Downloads/python/pytorch
