# Home Manager Configuration

Nix Home Manager configuration with GPU-aware Ollama setup for local AI/LLM inference.

## Quick Start

```bash
# AMD GPU (default — Framework Laptop 13, Radeon 780M)
home-manager switch --flake ~/.config/home-manager#stephan

# NVIDIA GPU
home-manager switch --flake ~/.config/home-manager#stephan-nvidia

# CPU-only (no GPU acceleration)
home-manager switch --flake ~/.config/home-manager#stephan-cpu
```

## GPU Configuration

The `gpuType` parameter (set in `flake.nix`) controls which Ollama build and environment variables are used:

| `gpuType` | Ollama Package   | GPU Backend | Extra Env Vars                                    |
|-----------|------------------|-------------|---------------------------------------------------|
| `"amd"`   | `ollama-rocm`    | ROCm/HIP    | `HSA_OVERRIDE_GFX_VERSION`, `GPU_MAX_ALLOC_PERCENT` |
| `"nvidia"`| `ollama-cuda`    | CUDA        | _(none)_                                          |
| `"cpu"`   | `ollama`         | _(none)_    | _(none)_                                          |

### How It Works

`flake.nix` defines a `mkHome` helper that passes `gpuType` into `home.nix`:

```nix
# flake.nix
mkHome = gpuType: home-manager.lib.homeManagerConfiguration {
  # ...
  extraSpecialArgs = { inherit gpuType; /* ... */ };
};

homeConfigurations = {
  stephan        = mkHome "amd";
  stephan-nvidia = mkHome "nvidia";
  stephan-cpu    = mkHome "cpu";
};
```

`home.nix` uses `gpuType` to:
1. Select the correct Ollama package (`ollama-rocm` / `ollama-cuda` / `ollama`)
2. Conditionally set AMD-specific environment variables

### Adding a New Machine

1. Add a new entry in `flake.nix` → `homeConfigurations`:
   ```nix
   my-new-machine = mkHome "nvidia";  # or "amd" or "cpu"
   ```
2. Apply: `home-manager switch --flake .#my-new-machine`

## Ollama Settings

These environment variables are set for **all** GPU types (in `home.nix`):

| Variable                   | Value     | Purpose                                    |
|----------------------------|-----------|--------------------------------------------|
| `OLLAMA_CONTEXT_LENGTH`    | `32768`   | 32K token context window                   |
| `OLLAMA_FLASH_ATTENTION`   | `true`    | Reduces KV cache memory usage              |
| `OLLAMA_KV_CACHE_TYPE`     | `q8_0`    | Quantized KV cache (~36% less memory)      |
| `OLLAMA_MAX_LOADED_MODELS` | `1`       | Single model loaded at a time              |
| `OLLAMA_NUM_PARALLEL`      | `1`       | Single concurrent request                  |
| `OLLAMA_HOST`              | `0.0.0.0:11434` | Listen on all interfaces (LAN access) |
| `OLLAMA_ORIGINS`           | `*`       | Allow requests from any origin             |

### AMD-only Variables (set when `gpuType == "amd"`)

| Variable                     | Value    | Purpose                                         |
|------------------------------|----------|-------------------------------------------------|
| `HSA_OVERRIDE_GFX_VERSION`   | `11.0.0` | gfx1103 → gfx1100 compatibility (Phoenix APUs)  |
| `GPU_MAX_ALLOC_PERCENT`      | `70`     | Reserve 30% shared VRAM for system/display       |

## Available Models

Models are managed imperatively (not declaratively via Nix):

```bash
ollama pull gemma4:e2b    #  7.2 GB — fastest, fits 8 GB VRAM
ollama pull gemma4:e4b    #  9.6 GB — good balance of speed/quality
ollama pull gemma4:26b    # 17   GB — best quality, needs 24+ GB VRAM
ollama pull gemma4:31b    # 19   GB — largest, needs 24+ GB VRAM
```

### Performance on AMD Radeon 780M (ROCm, 48 GiB shared)

| Model       | GPU Layers | Total Memory | Gen Speed | Prompt Eval |
|-------------|------------|-------------|-----------|-------------|
| gemma4:e2b  | 36/36      | ~7.2 GiB    | ~9.3 t/s  | ~99 t/s     |
| gemma4:e4b  | 43/43      | ~10.1 GiB   | ~9.3 t/s  | ~99 t/s     |
| gemma4:26b  | 31/31      | ~18.5 GiB   | ~9.1 t/s  | ~37-76 t/s  |
| gemma4:31b  | _untested_ | ~20+ GiB    | _tbd_     | _tbd_       |

All models configured in OpenCode (`~/.config/opencode/opencode.json`) and Ollama integrations (`~/.ollama/config.json`).

## Network Access

Ollama binds to `0.0.0.0:11434` and accepts requests from any origin. Access from other machines on your LAN:

```bash
# From another machine
curl http://<your-ip>:11434/api/generate -d '{"model":"gemma4:e4b","prompt":"Hello"}'
```

> **Security note**: `OLLAMA_ORIGINS=*` allows any origin. If you're on an untrusted network, restrict this to specific origins or bind to `127.0.0.1` instead.

## File Structure

```
~/.config/home-manager/
├── flake.nix            # Flake inputs + mkHome helper + homeConfigurations
├── home.nix             # Main config (accepts gpuType, GPU-conditional logic)
├── zsh.nix              # Zsh shell configuration
├── nixvim.nix           # Nixvim configuration
├── opencode-custom.nix  # Custom opencode package override
├── vscode.nix           # VS Code wrapped package
├── handy-wrapped.nix    # Handy wrapped package
└── README.md            # This file

~/.config/opencode/
├── opencode.json        # OpenCode base config (all gemma4 models registered)
└── oh-my-openagent.json # OmO agent/category model assignments (cloud models)

~/.ollama/
├── config.json          # Ollama integration config (model list)
└── models/              # Downloaded model files
```
