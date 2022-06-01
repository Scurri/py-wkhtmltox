FROM ubuntu:14.04.5
WORKDIR /app

RUN apt-get update && apt-get install -y \
    curl \
    make \
    ghostscript \
    build-essential \
    zlib1g-dev \
    libncurses5-dev \
    libgdbm-dev \
    libnss3-dev \
    libssl-dev \
    libreadline-dev \
    libffi-dev \
    fontconfig \
    xfonts-75dpi \
    xfonts-base \
    libfontconfig1 \
    libfreetype6-dev \
    libjpeg8-dev \
    libjpeg-turbo8 \
    libx11-6 \
    libxext6 \
    libxrender1 \
    python \
    python-pip \
    python-dev

RUN curl --silent -q https://s3-eu-west-1.amazonaws.com/scurri-requirement-debs/wkhtmltox-0.12.2.1_linux-trusty-amd64.deb -o wkhtmltox-0.12.2.1_linux-trusty-amd64.deb
RUN dpkg -i wkhtmltox-0.12.2.1_linux-trusty-amd64.deb && ldconfig

COPY ./*.py ./*.pyx ./*.toml ./*.cfg ./*.c LICENSE ./
COPY tests/*.py tests/simple.* tests/*.html tests/
COPY pip-cache pip-cache
COPY requirements/* requirements/
RUN pip install --user --no-index --find-links=file:///app/pip-cache -qr requirements/build.txt
RUN pip install --user --no-index --find-links=file:///app/pip-cache -qU tox==3.14.0
