# docker build --progress plain -t aifoundations .

FROM gemma

USER root

COPY ai-foundations /workspace/ai-foundations

RUN cd /workspace/ai-foundations && \
pip install .

RUN pip install \
    gemma==3.0.0

ARG USER=ed
USER ${USER}
