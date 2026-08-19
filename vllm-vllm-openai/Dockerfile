# https://build.nvidia.com/spark/vllm/agent-ready-models
# for spark links to:
# https://recipes.vllm.ai/Qwen/Qwen3.6-35B-A3B?hardware=dgx_spark_gb10&features=tool_calling%2Creasoning

ARG VER=latest
FROM vllm/vllm-openai:${VER}

# userid=vllm is uid 2000:0
# uid 1001
ARG USERID=ed
ENV USERID=${USERID}

RUN groupadd -g 1001 ${USERID}
RUN useradd -u 1001 -g 1001 -m -s /bin/bash ${USERID}

USER ${USERID}

RUN mkdir /home/${USERID}/.cache

#COPY --chown=${USERID}:${USERID} .emacs /home/${USERID}/

#WORKDIR /home/${USERID}/Downloads/python

#CMD ["jupyter", "lab"]
