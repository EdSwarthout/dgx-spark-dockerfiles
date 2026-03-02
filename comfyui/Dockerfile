# docker build --progress plain -t comfyui .

FROM transformers AS comfyui

USER root

# imageio-ffmpeg for https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git

# comfyui requirements:
RUN pip install \
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
SQLAlchemy \
av>=14.2.0 \
imageio-ffmpeg \
requests

RUN pip install \
fastsafetensors

#non essential dependencies:
RUN pip install \
kornia>=0.7.1 \
spandrel \
pydantic~=2.0 \
pydantic-settings~=2.0 \
PyOpenGL \
glfw

RUN pip install \
comfyui-frontend-package==1.39.19 \
comfyui-workflow-templates==0.9.5 \
comfyui-embedded-docs==0.4.3 \
comfyui_manager==4.1b1 \
comfy-aimdo>=0.2.4

# for https://github.com/kijai/ComfyUI-KJNodes.git
RUN pip install \
pillow>=10.3.0 \
scipy \
color-matcher \
matplotlib \
mss \
opencv-python-headless

# including huggingface-hub causes:
#13 2.414 ERROR: pip's dependency resolver does not currently take into account all the packages that are installed. This behaviour is the source of the following dependency conflicts.
#13 2.414 transformers 4.57.3 requires huggingface-hub<1.0,>=0.34.0, but you have huggingface-hub 1.2.3 which is incompatible.
# Transformers 4.57.3 needs older huggingface-hub #42670
# https://github.com/huggingface/transformers/issues/42670

ARG CK=0.2.7
# comfy-kitchen>=0.2.7
RUN pip install comfy-kitchen[cublas]>=${CK}

#COPY comfy_kitchen-${CK}-cp312-abi3-linux_aarch64.whl .
#RUN pip install comfy_kitchen-${CK}-cp312-abi3-linux_aarch64.whl && \
#    rm comfy_kitchen-${CK}-cp312-abi3-linux_aarch64.whl

RUN pip install \
lovely_tensors \
torchsde \
py7zr

#RUN pip install --no-deps \
#    accelerate \
#    diffusers \
#    transformers \
#    torchaudio

#RUN pip cache purge

# userid=ubuntu is uid 1000
# uid 1001
ARG USER=ed
USER ${USER}

RUN mkdir -p /home/${USER}/Downloads/ComfyUI/ComfyUI
WORKDIR /home/${USER}/Downloads/ComfyUI/ComfyUI

CMD ["python3", "main.py", "--listen", "0.0.0.0", "--disable-mmap"]
