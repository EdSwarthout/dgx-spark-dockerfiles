# https://build.nvidia.com/spark/vllm/agent-ready-models
# for spark links to:
# https://recipes.vllm.ai/Qwen/Qwen3.6-35B-A3B?hardware=dgx_spark_gb10&features=tool_calling%2Creasoning

ARG VER=latest
FROM vllm/vllm-openai:${VER}

# NVIDIA Container Toolkit adds host's render gid to user when using --gpus
ARG RENDERGID=991
RUN groupadd -g ${RENDERGID} render

# userid=vllm is uid 2000:0
# uid 1001
ARG USERID=ed
ENV USERID=${USERID}

RUN groupadd -g 1001 ${USERID}
RUN useradd -u 1001 -g 1001 -m -s /bin/bash ${USERID}

#RUN uv pip install --system vllm[audio]==v0.30.1rc1.dev558+g0cbac6cd1.d20261002.cu134
#Causes downgrades
#...
#8 8.336  - nvidia-cusolver==12.3.1.12rc1
#8 8.336  + nvidia-cusolver==12.0.4.66
#8 8.336  - nvidia-cusparse==12.8.6.46rc1
#8 8.336  + nvidia-cusparse==12.6.3.3
#8 8.336  ~ nvidia-cusparselt-cu13==0.8.1
#8 8.337  - nvidia-nvtx==13.4.46rc1
#8 8.337  + nvidia-nvtx==13.0.85
#8 8.337  + scipy==1.18.1
#8 8.337  + soundfile==0.14.0
#8 8.337  + soxr==1.1.0
#8 8.337  - torch==2.15.0.dev20260908+cu134
#8 8.337  + torch==2.14.1

RUN uv pip install --system \
    av \
    scipy \
    soundfile \
    soxr \
    mistral_common[audio]

USER ${USERID}
RUN mkdir /home/${USERID}/.cache
