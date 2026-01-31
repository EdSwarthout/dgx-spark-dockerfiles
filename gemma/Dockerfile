# docker build --progress plain -t gemma .

FROM transformers

USER root

RUN pip install \
    jax[cuda13] \
    gemma \
    keras \
    plotly

ARG USER=ed
USER ${USER}

RUN mkdir /home/${USER}/.gemma
WORKDIR /home/${USER}/Downloads/python

#CMD ["jupyter", "lab"]
