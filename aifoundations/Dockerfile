# docker build --progress plain -t aifoundations .

FROM gemma

USER root

#COPY ai-foundations /workspace/ai-foundations

# gptqmodel 6.0.3 requires numpy==2.2.6; python_version < "3.14", but you have numpy 2.0.2 which is incompatible.

# triton-kernels 1.0.0+gitb4e20bb.nv26.5 requires pytest, which is not installed.  (fixed by adding pytest to gemma)

# nvidia-dali-cuda130 2.1.0 requires packaging<=26.0, but you have packaging 26.2 which is incompatible.
# torchvision 0.27.0a0+6214cb20.nv26.5.50603568 requires torch==2.12.0a0+5aff3928d8.nv26.5.50603568, but you have torch 2.13.0 which is incompatible.


RUN --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
    mkdir -p /workspace/ai-foundations && cd /workspace/ai-foundations && \
    pip uninstall -y gptqmodel; \
    pip install pip-tools && \
    wget https://raw.githubusercontent.com/google-deepmind/ai-foundations/refs/heads/main/pyproject.toml && \
    pip-compile pyproject.toml

#RUN --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
#    cat /workspace/ai-foundations/requirements.txt

#COPY requirements.txt /workspace/ai-foundations
RUN --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
    cd /workspace/ai-foundations && \
    pip install --no-deps --break-system-packages --ignore-installed -r requirements.txt

ARG USER=ed
USER ${USER}
