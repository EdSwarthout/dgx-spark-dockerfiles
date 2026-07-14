# docker build --progress plain -t transformers .

FROM torchaudio AS transformers

USER root

RUN --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
    pip install \
    accelerate \
    diffusers \
    openai openai[aiohttp] \
    transformers>=4.51.3

# for gemma model examples <https://huggingface.co/google/gemma-4-26B-A4B-it>
RUN --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
    pip install \
    librosa \
    sentence-transformers

# Install GPT-QModel (gptqmodel)
# https://huggingface.co/docs/transformers/en/quantization/gptq
RUN --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
    pip install --no-deps --break-system-packages --ignore-installed \
    TokeNicer \
    defuser \
    device-smi \
    gptqmodel \
    logbar \
    optimum \
    pypcre \
    safetensors

ARG USER=ed
USER ${USER}
WORKDIR /home/${USER}/Downloads/python/pytorch
