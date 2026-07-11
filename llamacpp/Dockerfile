# docker build --progress plain -t llamacpp .

FROM llamacpp_build

USER root

# RUN --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
#     pip install \
#     inspireface \
#     opencv-python
#
# RUN --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
#     pip install \
#     pytest cmake scikit-build setuptools fastapi uvicorn sse-starlette pydantic-settings starlette-context

RUN --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
  CMAKE_ARGS="-DGGML_CUDA=on" pip install llama-cpp-python \
  --extra-index-url https://abetlen.github.io/llama-cpp-python/whl/cu132

RUN ls -l /usr/local/lib/python3.12/dist-packages/llama_cpp/lib

RUN --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
  CMAKE_ARGS="-DGGML_CUDA=on" pip install llama-cpp-python[server] \
  --extra-index-url https://abetlen.github.io/llama-cpp-python/whl/cu132


ARG USER=ed
USER ${USER}
