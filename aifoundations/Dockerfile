# docker build --progress plain -t aifoundations .

FROM gemma

USER root

COPY ai-foundations /workspace/ai-foundations

# gptqmodel 6.0.3 requires numpy==2.2.6; python_version < "3.14", but you have numpy 2.0.2 which is incompatible.

RUN cd /workspace/ai-foundations && \
pip uninstall -y gptqmodel; \
pip install .

RUN pip install \
    gemma==3.0.0

ARG USER=ed
USER ${USER}
