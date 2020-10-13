FROM ubuntu:latest

# INSTALL  NGINX AND REMOVE DEFAULT CONF 
RUN apt-get -y update && apt-get install -y --no-install-recommends \
         nginx \    
         && rm -rf /var/lib/apt/lists/* 
RUN rm -f /etc/nginx/sites-enabled/default

#INSTALL SUPERVISOR DAEMON
RUN apt-get -y update && apt-get -y install supervisor && \
  mkdir -p /var/log/supervisor && \
  mkdir -p /etc/supervisor/conf.d

# INSTALL CONDA AND PYTHON 
ARG CONDA_VERSION=4.7.12
ARG PYTHON_VERSION=3.7
ENV PATH /opt/miniconda/bin:$PATH
RUN apt-get install -y wget bzip2 && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

# CREATE USER
RUN useradd --create-home mluser
WORKDIR /home/mluser
USER mluser

# SETUP MINICONDA ENVIRONMENT
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-${CONDA_VERSION}-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p ~/miniconda && \
    rm ~/miniconda.sh && \
    ~/miniconda/bin/conda clean -tipsy
ENV PATH "/home/mluser/miniconda/bin:${PATH}"
RUN conda install -y conda=${CONDA_VERSION} python=${PYTHON_VERSION} && \
    conda clean -aqy && \
    rm -rf ~/miniconda/pkgs
RUN pip install Flask Flask-JWT gunicorn

# INSTALL APP DEPENDENCY
COPY app/requirements.txt /home/mluser/app/requirements.txt
COPY app/conda-requirements.txt /home/mluser/app/conda-requirements.txt
RUN pip install -r app/requirements.txt
RUN conda install --yes --file app/conda-requirements.txt

# PLACE CONFIG FILES FOR NGINX AND SUPERVISORD
COPY config/supervisord/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY config/nginx/mlapp.conf config/nginx/mlapp-tls.conf /etc/nginx/sites-enabled/
COPY config/nginx/ssl.conf /config/nginx/common.conf config/nginx/common_location.conf /etc/nginx/
COPY config/nginx/cert.crt  config/nginx/key.key config/nginx/dhparams.pem /etc/ssl/private/

# PLACE MODEL, CODE and RUN AS REST API
COPY app/ /home/mluser/app/
COPY entrypoint.sh /home/mluser/

USER root
ENTRYPOINT ["/home/mluser/entrypoint.sh"]
CMD ["-https", "true", "-timeout", "60"]