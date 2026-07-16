# docker build --progress plain -t comfyui .

FROM transformers AS comfyui

USER root

# pytest added in gemma, but it also installs xmanager
# xmanager 0.7.1 requires alembic==1.4.3, but you have alembic 1.18.5 which is incompatible.
# xmanager 0.7.1 requires sqlalchemy==1.2.19, but you have sqlalchemy 2.0.51 which is incompatible.

# triton-kernels 1.0.0+gitb4e20bb.nv26.5 requires pytest, which is not installed.
# cuda-python 13.2.0 requires cuda-bindings~=13.2.0, but you have cuda-bindings 13.3.1 which is incompatible.

RUN echo -e 'cuda-bindings==13.2.0' >> /workspace/constraints.txt

# Include:
# imageio-ffmpeg for https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git

# comfyui requirements:
RUN --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
    pip install -v --break-system-packages --ignore-installed \
    numpy>=1.25.0 \
    einops \
    transformers>=4.50.3 \
    tokenizers>=0.13.3 \
    sentencepiece \
    safetensors>=0.4.2 \
    aiohttp>=3.11.8 \
    yarl>=1.18.0 \
    pyyaml \
    Pillow \
    scipy \
    tqdm \
    psutil \
    alembic \
    SQLAlchemy>=2.0.0 \
    filelock \
    av>=16.0.0 \
    imageio-ffmpeg \
    requests \
    simpleeval>=1.0.0 \
    blake3 \
    pytest \
    -c /workspace/constraints.txt

RUN --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
    pip install -v --break-system-packages --ignore-installed \
    fastsafetensors \
    -c /workspace/constraints.txt

#non essential dependencies:
RUN --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
    pip install -v --break-system-packages --ignore-installed \
    pydantic~=2.0 \
    pydantic-settings~=2.0 \
    PyOpenGL>=3.1.8 \
    glfw \
    -c /workspace/constraints.txt

RUN --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
    pip show torch pydantic pydantic-settings PyOpenGL glfw

RUN --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
    pip install -v --break-system-packages --ignore-installed \
    comfyui-frontend-package==1.45.21 \
    comfyui-workflow-templates==0.11.9 \
    comfyui-embedded-docs==0.5.8 \
    comfyui_manager==4.2.2 \
    comfy-aimdo==0.4.10 \
    comfy-angle \
    -c /workspace/constraints.txt

RUN --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
    pip show torch comfy-angle

# for https://github.com/kijai/ComfyUI-KJNodes.git
RUN --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
    pip install -v --break-system-packages --ignore-installed \
    color-matcher \
    matplotlib \
    mss \
    opencv-python-headless \
    pillow>=10.3.0 \
    py7zr \
    scipy \
    -c /workspace/constraints.txt

RUN --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
    pip show torch opencv-python-headless

ARG CK=0.2.20
RUN --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
    pip install -v --break-system-packages --ignore-installed \
    comfy-kitchen[cublas]>=${CK} \
    -c /workspace/constraints.txt

RUN --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
    pip show torch comfy-kitchen

# prevent torch from being updated with no-deps:
RUN --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
    pip install --no-deps -v --break-system-packages --ignore-installed \
    kornia>=0.7.1 \
    kornia-rs \
    spandrel \
    -c /workspace/constraints.txt

RUN --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
    pip show torch kornia spandrel

# Both of these cause torch to be updated:

RUN --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
    pip install -v --no-deps --break-system-packages --ignore-installed \
    lovely_tensors \
    torchsde \
    -c /workspace/constraints.txt

RUN --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
    pip show torch torchsde lovely_tensors

RUN --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
    pip install -v --no-deps --break-system-packages --ignore-installed \
    trampoline \
    -c /workspace/constraints.txt

RUN --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
    pip show torch trampoline

# lovely_numpy
# Requires: fastcore, matplotlib, numpy
RUN --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
    pip install -v --no-deps --break-system-packages --ignore-installed \
    lovely_numpy \
    fastcore \
    -c /workspace/constraints.txt

RUN --mount=type=cache,id=pip-cache,target=/root/.cache/pip \
    pip show torch lovely_numpy


# Name: torch
# Version: 2.12.0a0+5aff3928d8.nv26.5.50603568
# Summary: Tensors and Dynamic neural networks in Python with strong GPU acceleration
# Home-page: https://pytorch.org
# Requires: filelock, fsspec, jinja2, networkx, setuptools, sympy, typing-extensions
# Required-by: accelerate, flash_attn, kornia, lovely-tensors, nvdlfw_inspect, nvidia-modelopt, nvidia-resiliency-ext, sentence-transformers, spandrel, torchdata, torchsde, torchvision, transformer_engine


# userid=ubuntu is uid 1000
# uid 1001
ARG USER=ed
USER ${USER}

RUN mkdir -p /home/${USER}/Downloads/ComfyUI/ComfyUI
WORKDIR /home/${USER}/Downloads/ComfyUI/ComfyUI

CMD ["python3", "main.py", "--listen", "0.0.0.0", "--disable-mmap"]
