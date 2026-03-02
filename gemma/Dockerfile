# docker build --progress plain -t gemma .

FROM transformers

USER root

RUN pip install \
    jax[cuda13] \
    gemma \
    keras \
    plotly

RUN pip install \
    kagglehub

ARG USER=ed
USER ${USER}

RUN mkdir /home/${USER}/.gemma
