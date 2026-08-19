# dgx-spark-dockerfiles

This repository contains a set of layered Dockerfiles designed for machine
learning, local LLM inference, and AI workflows. The "base" containers are
built independently from official NVIDIA NGC images, and the "addon"
containers build on top of them to create specialized environments.

Based on <https://docs.nvidia.com/deeplearning/frameworks/index.html>

The top-level `env.rc` provides helper functions (`d_build`, `d_build_all`,
`d_run`, `d_run_all`, `d_pip_list_all`, ...) that `cd` into each subdirectory,
`source` its `env.rc`, and run the corresponding `docker build` / `docker run`
command. Each subdirectory's `env.rc` defines `d_image`, `d_name`, `d_build`,
`d_build_extra`, `d_run`, and (for the base images) `d_0` (which pulls the
base NGC image).

## Base Images

These are built directly from official NVIDIA NGC containers and are the
starting point for the addon layers. Each customizes the NVIDIA base image by
adding a JupyterLab/Emacs (nox) development environment.

* **`pytorch-jp/`**
    * **Base:** `nvcr.io/nvidia/pytorch:26.07-py3`
    * **Purpose:** The foundational PyTorch environment. Adds JupyterLab,
        `jupyterlab_execute_time`, `ipywidgets`, Emacs (nox), `graphviz`,
        `pydot`, and `libxcb1`. Freezes `jupyter_server==2.19.0`. Adds a
        non-root user (`USERID`, default `ed`) and defaults to `jupyter lab`.
* **`jax-jp/`**
    * **Base:** `nvcr.io/nvidia/jax:26.07-py3`
    * **Purpose:** The JAX environment. Same JupyterLab/Emacs/graphviz tooling
        as `pytorch-jp`, plus JAX test/dev requirements (`pytest`,
        `matplotlib`, `rich`, `scipy-stubs`, and others).
* **`cudadl-jp/`**
    * **Base:** `nvcr.io/nvidia/cuda-dl-base:26.07-cuda13.3-devel-ubuntu24.04`
    * **Purpose:** A CUDA deep-learning base *without* PyTorch. Installs
        `python3`/`python3-pip`, the JupyterLab/Emacs tooling, the
        `nvidia-cudnn-frontend` Python API (which supports dlpack tensors on
        the GPU, not just PyTorch), and `cupy-cuda13x`.

## Addon Layers

These build on top of the base images to add specific frameworks and
workflows.

* **`torchaudio/`**
    * **Base:** `pytorch-jp`
    * **Purpose:** Audio processing. Installs `ffmpeg` (and `libxcb1`) and
        builds `torchaudio` from source (branch `release/2.11`) with CUDA
        support (`USE_CUDA=1`), then installs `torchcodec` (no deps).
* **`transformers/`**
    * **Base:** `torchaudio`
    * **Purpose:** The Hugging Face ecosystem. Installs `transformers`,
        `diffusers`, `accelerate`, `openai`/`openai[aiohttp]`, plus `librosa`
        and `sentence-transformers` for the Gemma model examples.
* **`cudnn/`**
    * **Base:** `transformers`
    * **Purpose:** Deep-learning optimization. Adds the
        `nvidia-cudnn-frontend` Python API for direct access to cuDNN graph
        optimizations, along with the requirements for the official sample
        notebooks.
* **`gemma/`**
    * **Base:** `jax-jp`
    * **Purpose:** Specialized environment for Google's Gemma models.
        Compiles the `google-deepmind/gemma` (v4.0.1) `pyproject.toml` into a
        pinned `requirements.txt` (via `pip-tools`) and installs it along
        with `gemma==v4.0.1`, plus `importlib_resources` and `plotly` needed
        by the Gemma examples. JAX/CUDA is provided by the `jax-jp` base.
* **`aifoundations/`**
    * **Base:** `jax-jp`
    * **Purpose:** Project-specific runtime for the local
        `google-deepmind/ai-foundations` course codebase. Compiles that
        project's `pyproject.toml` into requirements, applies
        `ai-foundations-requirements.patch`, and installs the result.
* **`comfyui/`**
    * **Base:** `transformers`
    * **Purpose:** Generative image/video workflow. Installs the full set of
        requirements to run a ComfyUI server, including the ComfyUI
        frontend, workflow templates, embedded docs, ComfyUI-Manager,
        `comfy-kitchen`, `kornia`, `spandrel`, and the dependencies for
        common custom nodes (e.g. KJNodes, VideoHelperSuite). Uses a
        `constraints.txt` to pin `numpy`/`fsspec`. Starts
        `python3 main.py --listen 0.0.0.0 --disable-mmap`.
* **`llamacpp/`**
    * **Base:** `transformers` (via a build prep stage, `llamacpp_build`)
    * **Purpose:** Local LLM inference server. The prep stage
        (`Dockerfile_prep`) installs `inspireface`, `opencv-python`, the
        FastAPI/uvicorn server dependencies, and `websockets`. The main stage
        (`Dockerfile`) installs `llama-cpp-python` and
        `llama-cpp-python[server]` compiled with `CMAKE_ARGS="-DGGML_CUDA=on"`
        (from the `cu132` wheel index) for hardware-accelerated inference.
* **`vllm-vllm-openai/`**
    * **Base:** `vllm/vllm-openai:latest`
    * **Purpose:** A standalone (not layered) vLLM serving image tuned for the
        NVIDIA DGX Spark. Adds a non-root `ed` user. The `env.rc` defines
        ready-made `vllm serve` command lines (e.g. Qwen3.6-35B-A3B with
        NVFP4/FP8, flashinfer attention, tool-calling and reasoning parsers)
        and mounts the `huggingface`/`vllm` caches. See
        <https://build.nvidia.com/spark/vllm> and
        <https://recipes.vllm.ai>.
