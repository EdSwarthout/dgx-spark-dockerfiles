FROM jax-jp

USER root

COPY ai-foundations-requirements.patch /workspace/ai-foundations/

RUN --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
    pip install pip-tools && \
    cd /workspace/ai-foundations && \
    wget https://raw.githubusercontent.com/google-deepmind/ai-foundations/refs/heads/main/pyproject.toml && \
    pip-compile pyproject.toml && \
    echo "pyproject based requirements" && cat /workspace/ai-foundations/requirements.txt && \
    patch -i ai-foundations-requirements.patch

RUN --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
    pip install --break-system-packages \
    -r  /workspace/ai-foundations/requirements.txt

USER ${USERID}
