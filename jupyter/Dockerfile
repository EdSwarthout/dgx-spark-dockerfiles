# docker build --progress plain -t jupyter .
# docker run --user=${USER}:${USER}
# https://catalog.ngc.nvidia.com/orgs/nvidia/containers/pytorch

ARG VER=26.02-py3
FROM nvcr.io/nvidia/pytorch:${VER}

ENV DEBIAN_FRONTEND=noninteracive
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    emacs-nox \
    graphviz \
    libxcb1 \
    && \
    rm -rf /var/lib/apt/lists/*

COPY .emacs /root

RUN pip install -U pip

RUN pip install \
    ipywidgets \
    pydot

RUN jupyter labextension disable "@jupyterlab/apputils-extension:announcements"

# userid=ubuntu is uid 1000
# uid 1001
ARG USER=ed
RUN useradd -m -s /bin/bash ${USER}

USER ${USER}
RUN mkdir /home/${USER}/.cache

COPY --chown=${USER}:${USER} .emacs /home/${USER}/

WORKDIR /home/${USER}/Downloads/python/pytorch

CMD ["jupyter", "lab"]
