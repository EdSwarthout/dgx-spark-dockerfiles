# docker build --progress plain -t cudnn .

FROM transformers

USER root

RUN --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
    pip install --break-system-packages --ignore-installed \
    nvidia-cudnn-frontend

ARG USER=ed
USER ${USER}
