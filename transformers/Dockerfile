# docker build --progress plain -t transformers .

FROM torchaudio AS transformers

USER root

RUN --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
    pip install \
    accelerate \
    diffusers \
    openai openai[aiohttp] \
    transformers>=4.51.3 \
    && \
    find /root/.cache -type f -ls

ARG USER=ed
USER ${USER}
WORKDIR /home/${USER}/Downloads/python/pytorch
