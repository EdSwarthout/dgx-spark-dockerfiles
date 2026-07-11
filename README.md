# dgx-spark-dockerfiles

This repository contains a set of layered Dockerfiles designed for machine learning, local LLM inference, and AI workflows.
The containers build upon each other to create specialized environments.

## Container Hierarchy & Purposes

* **`jupyter/`**
    * **Base:** `nvcr.io/nvidia/pytorch`
    * **Purpose:** The foundational PyTorch environment. It customizes the base NVIDIA PyTorch image by adding JupyterLab, Emacs (nox), `ipywidgets`, and basic graphing tools (`graphviz`, `pydot`).
* **`torchaudio/`**
    * **Base:** `jupyter`
    * **Purpose:** Audio processing base. Installs system dependencies like `ffmpeg` and compiles `torchaudio` directly from source with CUDA support.
* **`transformers/`**
    * **Base:** `torchaudio`
    * **Purpose:** The Hugging Face ecosystem environment. Installs core ML libraries including `transformers`, `diffusers`, `accelerate`, and `sentence-transformers`, along with `librosa` for audio manipulation and OpenAI's API client.
* **`cudnn/`**
    * **Base:** `transformers`
    * **Purpose:** Deep learning optimization. Adds the `nvidia-cudnn-frontend` Python API for direct access to cuDNN graph optimizations.
* **`gemma/`**
    * **Base:** `transformers`
    * **Purpose:** Specialized environment for Google's Gemma models. Adds JAX (with CUDA support), Keras, KaggleHub, and quantization packages like `auto-round` and `gptqmodel`.
* **`aifoundations/`**
    * **Base:** `gemma`
    * **Purpose:** Project-specific runtime. Configured to run the local `ai-foundations` codebase, managing specific dependency versions for `gemma` and `gptqmodel`.
* **`comfyui/`**
    * **Base:** `transformers`
    * **Purpose:** Generative image workflow. Installs all requirements necessary to run a full ComfyUI server, including various custom nodes, extensions, and the ComfyUI-Manager.
* **`llamacpp/`**
    * **Base:** `cudnn` (via a build prep stage)
    * **Purpose:** Local LLM inference server. Compiles `llama-cpp-python` and its server components from source with `GGML_CUDA=on` for hardware-accelerated inference, alongside tools for web sockets and vision (OpenCV).
