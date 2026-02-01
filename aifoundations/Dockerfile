# docker build --progress plain -t aifoundations .

FROM gemma

USER root

COPY ai-foundations /workspace/ai-foundations

RUN cd /workspace/ai-foundations && \
pip install .

ARG USER=ed
USER ${USER}
