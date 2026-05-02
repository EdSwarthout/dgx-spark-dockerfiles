# docker build --progress plain -t gemma .

FROM transformers

USER root

RUN --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
    pip install \
    jax[cuda13] \
    gemma \
    keras \
    plotly \
    kagglehub \
    auto-round>0.5 \
    jupyterlab_execute_time \
    mamba-ssm

# gptqmodel for Intel Auto-round
# mamba-ssm for Nvidia-Nemotron-3-Nano-30B0A3B-NVFP4
RUN --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
    pip install --no-deps \
    gptqmodel>=2.0

ARG USER=ed
USER ${USER}

RUN mkdir /home/${USER}/.gemma
