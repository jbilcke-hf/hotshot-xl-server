# Use an official PyTorch image with CUDA support as the base image
FROM pytorch/pytorch:2.0.1-cuda11.7-cudnn8-runtime

# Install Git and system libraries required for OpenGL without interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install Git and OpenGL libraries, and libglib2.0
RUN apt-get update && apt-get install -y git libgl1-mesa-glx libglib2.0-0

# Set up a new user named "user" with user ID 1000
RUN useradd -m -u 1000 user

# Switch to the "user" user
USER user

ENV HOME=/home/user \
	PATH=/home/user/.local/bin:$PATH \
    PYTHONPATH=$HOME/app \
	PYTHONUNBUFFERED=1 \
	GRADIO_ALLOW_FLAGGING=never \
	GRADIO_NUM_PORTS=1 \
	GRADIO_SERVER_NAME=0.0.0.0 \
	GRADIO_THEME=huggingface \
    GRADIO_SHARE=False \
	SYSTEM=spaces

# Set the working directory to the user's home directory
WORKDIR $HOME/app

# Clone your repository or add your code to the container
RUN git clone -b main https://github.com/jbilcke-hf/Hotshot-XL-Gradio-API $HOME/app

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt gradio accelerate

RUN find $HOME/app

# Set the environment variable to specify the GPU device
ENV CUDA_DEVICE_ORDER=PCI_BUS_ID
ENV CUDA_VISIBLE_DEVICES=0

# Run your app.py script
CMD ["python", "app.py"]