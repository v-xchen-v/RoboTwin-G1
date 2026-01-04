# Python version: 3.10
# CUDA version: 12.1 (Recommended)
# Software Requirements:
#   - Ray tracing: NVIDIA Driver >= 470
#   - Denoising (OIDN): NVIDIA Driver >= 520
#
# Additional Requirements for Docker:
#   When running this container, ensure the following environment variable is set:
#     -e NVIDIA_DRIVER_CAPABILITIES=compute,utility,graphics
#   
#   IMPORTANT: The 'graphics' capability is essential. 
#   Omitting it may result in segmentation faults due to missing Vulkan support.

FROM nvidia/cuda:12.1.0-cudnn8-devel-ubuntu22.04

# Set required NVIDIA driver capabilities
ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility,graphics

# Set Python version
ENV PYTHON_VERSION=3.10

# Install Vulkan (required for graphics rendering)
RUN apt-get update && apt-get install -y \
    libvulkan1 \
    mesa-vulkan-drivers \
    vulkan-tools \
    && rm -rf /var/lib/apt/lists/*

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    wget \
    curl \
    ffmpeg \
    unzip \
    x11-apps \
    libx11-6 \
    libxext6 \
    libxrender1 \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libegl1-mesa \
    libgl1-mesa-dri \
    libglvnd0 \
    libglvnd-dev \
    && rm -rf /var/lib/apt/lists/*

# Create EGL vendor directory for NVIDIA
RUN mkdir -p /usr/share/glvnd/egl_vendor.d

# Install Miniforge
# We download the latest script and install it to /opt/conda
RUN wget --quiet https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh -O ~/miniforge.sh && \
    /bin/bash ~/miniforge.sh -b -p /opt/conda && \
    rm ~/miniforge.sh && \
    # Initialize conda for shell interaction
    /opt/conda/bin/conda init bash

# Install Python 3.10 via mamba
RUN /opt/conda/bin/mamba install -n base \
    python=3.10 \
    -y && \
    /opt/conda/bin/mamba clean -afy

# Git clone RoboTwin repository
# Note: If you are not using 3D data, a failed installation of pytorch3d 
# will not affect the functionality of the project.
RUN cd /tmp && \
    git clone https://github.com/RoboTwin-Platform/RoboTwin.git

# Adapted from script/_install.sh to work in Docker with Miniforge
RUN echo "Installing the necessary packages ..." && \
    cd /tmp/RoboTwin && \
    /opt/conda/bin/pip install -r script/requirements.txt

RUN echo "Installing pytorch3d ..." && \
    /opt/conda/bin/pip install --no-build-isolation "git+https://github.com/facebookresearch/pytorch3d.git@stable"

RUN echo "Installing Curobo ..." && \
    cd /tmp/RoboTwin/envs && \
    git clone https://github.com/NVlabs/curobo.git && \
    cd curobo && \
    /opt/conda/bin/pip install -e . --no-build-isolation && \
    cd ../..
    
# Copy installation script and execute
COPY docker/_install.sh /tmp/RoboTwin/docker/_install.sh
RUN cd /tmp/RoboTwin && bash docker/_install.sh || true
    
# Update CuRobo embodiment config path if needed
RUN cd /tmp/RoboTwin && /opt/conda/bin/python script/update_embodiment_config_path.py || true

# Default Command
WORKDIR /root/workspace/main
CMD ["/bin/bash"]

# Build command:
#   docker build -t robotwin:latest -f docker/Dockerfile .
#
# Run command with X11 support:
#   xhost +local:docker
#   docker run -it --rm \
#     --gpus all \
#     -e NVIDIA_DRIVER_CAPABILITIES=compute,utility,graphics \
#     -e DISPLAY=$DISPLAY \
#     -v /tmp/.X11-unix:/tmp/.X11-unix:rw \
#     -v ${PWD}:/workspace \
#     --name robotwin \
#     robotwin:latest \
#     /bin/bash
#
# After exiting, restore X11 security:
#   xhost -local:docker
