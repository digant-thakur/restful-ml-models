FROM ubuntu:latest
# INSTALL  NGINX
RUN apt-get -y update && apt-get install -y --no-install-recommends \
         nginx \    
         && rm -rf /var/lib/apt/lists/* 
#INSTALL SUPERVISOR DAEMON
RUN apt-get -y update && apt-get -y install supervisor && \
  mkdir -p /var/log/supervisor && \
  mkdir -p /etc/supervisor/conf.d

# IINSTALL CONDA AND PYTHON
ARG CONDA_VERSION=4.7.12
ARG PYTHON_VERSION=3.7
ENV PATH /opt/miniconda/bin:$PATH
RUN apt-get install -y wget bzip2 && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

# CREATE USER
RUN useradd --create-home mluser
WORKDIR /home/mluser
#USER mluser

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-${CONDA_VERSION}-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p ~/miniconda && \
    rm ~/miniconda.sh && \
    ~/miniconda/bin/conda clean -tipsy

ENV PATH "/root/miniconda/bin:${PATH}"
RUN conda install -y conda=${CONDA_VERSION} python=${PYTHON_VERSION} && \
    conda clean -aqy && \
    rm -rf ~/miniconda/pkgs

# INSTALL APP REQUIREMENTS
COPY app/requirements.txt /home/mluser/app/requirements.txt
COPY app/conda-requirements.txt /home/mluser/app/conda-requirements.txt
#ENV VIRTUAL_ENV "/home/mluser/app-env"
#RUN python -m venv $VIRTUAL_ENV
#ENV PATH "${VIRTUAL_ENV}/bin:${PATH}"
RUN pip install -r app/requirements.txt
RUN conda install --yes --file app/conda-requirements.txt

# PLACE CONFIG FILES
COPY app/config/supervisord/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY app/config/nginx/app.conf /etc/nginx/sites-enabled/default
COPY app/ /home/mluser/app


RUN ln -sf /dev/stdout /var/log/nginx/access.log && ln -sf /dev/stderr /var/log/nginx/error.log
CMD ["supervisord"]

