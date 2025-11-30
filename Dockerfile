# Use NVIDIA CUDA base image with Python
FROM nvidia/cuda:11.8.0-cudnn8-runtime-ubuntu22.04

# Disable Python output buffering for real-time logs
ENV PYTHONUNBUFFERED=1

# Set working directory
WORKDIR /workspace

# Install system dependencies
RUN apt-get update && apt-get install -y \
    python3.10 \
    python3-pip \
    git \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements file first for better caching
COPY requirements.txt /tmp/requirements.txt



# Install Python dependencies using Tsinghua mirror
RUN pip3 install -r /tmp/requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple

# Install Uni-Core (torch already installed from requirements.txt)
RUN git clone https://github.com/dptech-corp/Uni-Core.git /tmp/Uni-core \
    && cd /tmp/Uni-core \
    && python3 setup.py install \
    && rm -rf /tmp/Uni-core

# Fix lmdb permission issues
RUN chmod -R 777 /usr/local/lib/python3.10/dist-packages/ || true

# Copy LigUnity code
COPY . /workspace/

# Set Python path
ENV PYTHONPATH="/workspace:/workspace/HGNN:/workspace/unimol:${PYTHONPATH}"

# Set default command
CMD ["bash"]
