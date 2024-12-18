FROM nvidia/cuda:11.2.2-cudnn8-runtime-ubuntu20.04

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /app

RUN apt-get update && apt-get install -y \
    wget \
    bzip2 \
    curl \
    ca-certificates \
    python3.9 \
    python3.9-distutils \
    python3-pip \
    python3-dev \
    build-essential \
    git \
    && ln -fs /usr/share/zoneinfo/UTC /etc/localtime \
    && dpkg-reconfigure --frontend noninteractive tzdata

RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda3-latest-Linux-x86_64.sh -b -p /opt/conda && \
    rm Miniconda3-latest-Linux-x86_64.sh

ENV PATH=/opt/conda/bin:$PATH

RUN conda create -y -n tf_env python=3.9.20

RUN conda init

SHELL ["conda", "run", "-n", "tf_env", "/bin/bash", "-c"]

RUN conda install -y conda-forge::cudatoolkit=11.2.2 \
    && conda install -y conda-forge::cudnn=8.1.0.77 \
    && conda install -y jupyter

COPY requirements.txt /app/requirements.txt

RUN pip install --prefer-binary --upgrade pip && \
    pip install typing-extensions==3.7.4.3 && \
    pip install --no-cache-dir -r /app/requirements.txt --no-deps && \
    pip install jupyter

COPY *.ipynb /app/

COPY *.tar.gz /app/

RUN for file in /app/*.tar.gz; do \
     tar -xvzf "$file" -C /app/ && \
     rm "$file"; \
 done

EXPOSE 8888

CMD ["bash", "-c", "source /opt/conda/etc/profile.d/conda.sh && conda activate tf_env && jupyter notebook --ip=0.0.0.0 --no-browser --allow-root --notebook-dir=/app"]

