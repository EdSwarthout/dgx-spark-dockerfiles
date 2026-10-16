# dgx-spark-dockerfiles

This repository contains a set of layered Dockerfiles designed for machine
learning, local LLM inference, and AI workflows. The "base" containers are
built independently from official NVIDIA NGC images, and the "addon"
containers build on top of them to create specialized environments.

Based on <https://docs.nvidia.com/deeplearning/frameworks/index.html>

The top-level `env.rc` provides helper functions (`d_build`, `d_build_all`,
`d_run`, `d_run_all`, `d_pip_list_all`, ...) that `cd` into each subdirectory,
`source` its `env.rc`, and run the corresponding `docker build` / `docker run`
command. Each subdirectory's `env.rc` defines `d_image`, `d_name`, and
overrides `d_build`, `d_run`, or both; the base images additionally define
`d_0` (which pulls the base NGC image) and `d_run0` (which runs the *raw*
base image).

## Prerequisites

* An NVIDIA DGX Spark (or other CUDA 13-capable GPU host) with a working
  Docker installation and `--gpus all` support.
* Access to NVIDIA NGC container registry images
  (<https://catalog.ngc.nvidia.com>).

Host paths are parameterized by shell variables in the top-level `env.rc`
(defaults in parentheses — override them in the shell before sourcing if
they differ):

* `D_USER` (`ed`) — non-root user created inside the images.
* `HOME_DIR` (`/home/$D_USER`) — host home directory; the huggingface (and
  gemma) caches are mounted from there.
* `MOUNT_ROOT` (`/mnt/spark`) — host mount base (shared packages).
* `WORK_ROOT` (`$MOUNT_ROOT/docker`) — repo/workspace root on the host.

## Quickstart

```sh
git clone <this-repo> && cd dgx-spark-dockerfiles
source env.rc

# Build every image: bases first (with d_0 pulling the NGC base),
# then addons in dependency order. Base Dockerfiles do `COPY common /common`,
# so bases are always built from the repo root (d_build_all handles this).
d_build_all

# Or build/run a single addon:
cd transformers && source env.rc
d_build      # build the layered image (from this subdirectory)
d_run        # run it (interactive, --rm, --gpus all)

# Or run one of the raw NGC/vllm base images (as user ubuntu):
cd pytorch-jp && source env.rc
d_run0
```

## Helper Functions

| Function           | What it does                                                        |
|--------------------|---------------------------------------------------------------------|
| `d_0`              | Pull the official base image (`d_base:d_base_ver`).                 |
| `d_build`          | Build the current directory's image (`d_image`).                    |
| `d_build_all`      | Build all bases (running `d_0` first, from the repo root since base Dockerfiles `COPY common`), then all addons, in order. |
| `d_run`            | Run the image interactively with GPU/cache mounts.                  |
| `d_run0`           | Run the raw base image (e.g. `pytorch0`, `jax0`, `cuda-dl0`) as user `ubuntu`. |
| `d_run_all`        | Run a command in every base and addon container in turn.            |
| `d_bash`           | `docker exec -it` into the running container as the default user.   |
| `d_bash0`          | Same, but as root (`--user 0`).                                     |
| `d_exec` / `d_exec0` | `docker exec -it` with arbitrary arguments (user / root).         |
| `d_pip_list_all`   | Dump `pip list` from every image into `logs/pip_list.<name>.log`.   |

Build order is driven by two lists in the top-level `env.rc`: `dirs_base`
(built first) and `dirs_addons` (built second, on top of their parents).

## Dependency Graph

```
pytorch-jp ──► torchaudio ──► transformers ──┬─► cudnn
                                             ├─► comfyui
                                             └─► llamacpp
jax-jp ──┬─► gemma
         └─► aifoundations
cudadl-jp, vllm-vllm-openai  (standalone bases)
```

## Base Images

These are built directly from official base containers and are the starting
point for the addon layers. The NGC-based ones all share `common/jp.sh`
(see below) and default to `jupyter lab`. Base tags live in each
subdirectory's `env.rc` (`d_base_ver`) and as `ARG VER` defaults in the
Dockerfiles — keep the two in sync when NVIDIA ships the next YY.MM
release.

* **`pytorch-jp/`**
    * **Base:** `nvcr.io/nvidia/pytorch:26.07-py3`
    * **Purpose:** The foundational PyTorch environment. Adds JupyterLab,
        `jupyterlab_execute_time`, `ipywidgets`, `notebook`, `jupytext`,
        Emacs (nox), `graphviz`, `pydot`, and `libxcb1`. Requires
        `jupyter_server>=2.21.1`. Adds a non-root user (`USERID`, default
        `ed`) and defaults to `jupyter lab`.
* **`jax-jp/`**
    * **Base:** `nvcr.io/nvidia/jax:26.07-py3`
    * **Purpose:** The JAX environment. Same JupyterLab/Emacs/graphviz tooling
        as `pytorch-jp`, plus JAX test/dev requirements (`absl-py`,
        `hypothesis`, `matplotlib`, `mpmath`, `portpicker`, `pytest`,
        `pytest-xdist`, `rich`, `scipy-stubs`, and others).
* **`cudadl-jp/`**
    * **Base:** `nvcr.io/nvidia/cuda-dl-base:26.07-cuda13.3-devel-ubuntu24.04`
      (the `env.rc` documents the four base variants:
      `inference-runtime`, `inference-devel`, `runtime`, `devel`; default is
      `devel`)
    * **Purpose:** A CUDA deep-learning base *without* PyTorch. Installs
        `python3`/`python3-pip`, the JupyterLab/Emacs tooling,
        `nvidia-cudnn-frontend` (which supports dlpack tensors on the GPU,
        not just PyTorch), `cupy-cuda13x`, `jupytext`, `jupyter-ai`, and
        `mistral-vibe`.
* **`vllm-vllm-openai/`**
    * **Base:** `vllm/vllm-openai:v0.31.0` (nightly `cu134` and
      `gemma4-cu130` variants are documented in the `env.rc`)
    * **Purpose:** A standalone vLLM serving image tuned for the NVIDIA DGX
        Spark. Creates a `render` group (GID matching the host, for the
        NVIDIA Container Toolkit) and a non-root `ed` user. Adds audio
        serving support via `uv pip install av scipy soundfile soxr
        mistral_common[audio]`. The `env.rc` defines ready-made
        `vllm_serve_args_*` presets — Qwen3.8-27B (default),
        Qwen3.6-35B-A3B (NVFP4/FP8, flashinfer attention, MTP spec
        decoding), Nemotron-3-Nano-Omni-30B (multimodal), and
        Granite-4.2-8B — and mounts the `huggingface`/`vllm` caches with
        `--shm-size=16g`, passing `HF_TOKEN` through. See
        <https://build.nvidia.com/spark/vllm> and <https://recipes.vllm.ai>.

## Addon Layers

These build on top of the base images to add specific frameworks and
workflows.

* **`torchaudio/`**
    * **Base:** `pytorch-jp`
    * **Purpose:** Audio processing. Installs `ffmpeg` (apt) and builds
        `torchaudio` from source (branch `release/2.11`) with CUDA support
        (`USE_CUDA=1`, editable install), then installs `torchcodec`
        (no deps).
* **`transformers/`**
    * **Base:** `torchaudio`
    * **Purpose:** The Hugging Face ecosystem. Installs `transformers`,
        `diffusers`, `accelerate`, `openai`/`openai[aiohttp]`, plus `librosa`
        and `sentence-transformers` for the Gemma model examples. Its
        `env.rc` adds a `~/.cache/gemma` mount for the Gemma models.
* **`cudnn/`**
    * **Base:** `transformers`
    * **Purpose:** Deep-learning optimization. Adds the
        `nvidia-cudnn-frontend` Python API for direct access to cuDNN graph
        optimizations, along with the requirements for the official sample
        notebooks.
* **`gemma/`**
    * **Base:** `jax-jp`
    * **Purpose:** Specialized environment for Google's Gemma models.
        Compiles the `google-deepmind/gemma` (v4.0.1) `pyproject.toml` into
        a pinned `requirements.txt` (via `pip-tools`), fixes JAX
        compatibility in `requirements-fixed.txt`, and installs the result
        (no-deps) along with `gemma==v4.0.1`, plus `importlib_resources`
        and `plotly` needed by the Gemma examples. JAX/CUDA is provided by
        the `jax-jp` base. Its `env.rc` adds a `~/.cache/gemma` mount.
* **`aifoundations/`**
    * **Base:** `jax-jp`
    * **Purpose:** Project-specific runtime for the local
        `google-deepmind/ai-foundations` course codebase. Compiles that
        project's `pyproject.toml` into requirements, applies
        `ai-foundations-requirements.patch`, and installs the result. Its
        `env.rc` overrides `d_run` with `--shm-size=1g`, a `~/.cache/gemma`
        mount, and the workdir set to the downloads directory (where the
        course repo is cloned).
* **`comfyui/`**
    * **Base:** `transformers`
    * **Purpose:** Generative image/video workflow. Installs the full set of
        requirements to run a ComfyUI server, including the ComfyUI
        frontend, workflow templates, embedded docs, ComfyUI-Manager,
        `comfy-aimdo`/`comfy-angle`, `fastsafetensors`, `comfy-kitchen`,
        `kornia`, `spandrel`, `torchsde`, `lovely_tensors`, `torchinfo`,
        and the dependencies for common custom nodes (e.g. KJNodes,
        VideoHelperSuite). Uses an inline `constraints.txt` to pin
        `numpy`/`fsspec` and keeps `torch` from being upgraded (via
        `--no-deps`). Its `env.rc` mounts the host ComfyUI directory and
        provides `gitupd1` (update the ComfyUI checkout) and `d_req_diff`
        (compare repo requirements against upstream). Starts
        `python3 main.py --listen 0.0.0.0 --disable-mmap`.
* **`llamacpp/`**
    * **Base:** `transformers` (via a build prep stage, `llamacpp_build`)
    * **Purpose:** Local LLM inference server. The prep stage
        (`Dockerfile_prep` stage) installs `inspireface`, `opencv-python`,
        the FastAPI/uvicorn server dependencies, and `websockets`. The main
        stage installs `llama-cpp-python` and
        `llama-cpp-python[server]` compiled with `CMAKE_ARGS="-DGGML_CUDA=on"`
        (from the `cu132` wheel index) for hardware-accelerated inference.
        The `env.rc` documents running the OpenAI-compatible
        `llama_cpp.server` against a mounted GGUF model.

## Shared Files (`common/`)

* **`jp.sh`** — common provisioning for the JP base images: apt packages
  (`emacs-nox` + per-image `APT_PACKAGES`), pip bootstrap, the Jupyter
  stack, the NGC entrypoint noise removal, Emacs config, and creation of
  the non-root user with its cache directories.
* **`.emacs`** — Emacs configuration copied into `/root` and the user's
  home by `jp.sh`.
* **`constraints.txt`** — consolidated pip pins (`numpy<2.5`,
  `fsspec<=2026.4.0`) that document the cross-addon constraints; addons
  currently apply them inline until they are rewired to `-c`.
