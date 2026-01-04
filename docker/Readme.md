# Docker Quick Start Guide

This guide provides simple instructions for building and running RoboTwin using Docker.

## Prerequisites

- Docker installed
- NVIDIA Container Toolkit installed
- NVIDIA GPU with driver >= 470 (for ray tracing) or >= 520 (for denoising)

## Quick Start

### 1. Build the Docker Image

```bash
sudo ./docker/build.sh
```

This will build a Docker image named `robotwin:latest` with:
- CUDA 12.1
- Python 3.10
- PyTorch 2.4.1
- All RoboTwin dependencies

### 2. Start the Container with GUI Support

```bash
./docker/start_gui.sh
```

This will:
- Enable X11 forwarding for GUI applications
- Mount the current directory to `/root/workspace/main` inside the container
- Start the container in detached mode with GPU support

### 3. Access the Container

```bash
./docker/into.sh
```

This opens a bash shell inside the running container.

## Available Scripts

- **`build.sh`** - Build the Docker image
- **`start_gui.sh`** - Start container with GUI/X11 support
- **`into.sh`** - Enter the running container
- **`fix_permission.sh`** - Fix file permission issues (if needed)

## Notes

- The container runs with `--rm` flag, so it will be automatically removed when stopped
- Your workspace is mounted at `/root/workspace/main` inside the container
- All GPU capabilities are enabled including graphics rendering
- The conda environment is automatically activated via the entrypoint script

## Stopping the Container

```bash
docker stop robotwin
```

The container will be automatically removed after stopping.
