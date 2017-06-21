# -*- mode: ruby -*-
# vi: set ft=ruby :

FROM aquabiota/phusion-base:16.04

LABEL maintainer "Aquabiota Solutions AB <mapcloud@aquabiota.se>"

# configuring environment
ENV CONDA_DIR /opt/conda
ENV PATH $CONDA_DIR/bin:$PATH
ENV NOTEBOOK_DIR /opt/notebooks
# ENV JUPYTER_CONFIG_DIR /root/.ipython/profile_default/

# Install required packages

# Solving installation-of-package-devtools-had-non-zero-exit-status
# if R-Kernel would be used
RUN apt-get update --fix-missing && \
    apt-get install -yq libssl-dev libcurl4-gnutls-dev libxml2-dev

RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/archive/Anaconda3-4.4.0-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh

RUN conda config --system --add channels conda-forge && \
    conda config --system --set auto_update_conda false

RUN mkdir -p /opt/notebooks

# installing jupyterlab
RUN conda install -y -c conda-forge jupyterlab=0.24.1 && \
    conda install -y -c conda-forge geopy=1.11.0 && \
    conda install -y bcrypt=3.1.2 passlib=1.7.1 yaml=0.1.6 && \
    conda clean -tipsy

ENV LANG=C.UTF-8

# Install Python Packages & Requirements (Done near end to avoid invalidating cache)
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

#RUN mkdir -p $JUPYTER_CONFIG_DIR && \
#    ipython profile create && echo $(ipython locate)
#COPY ipython_config.py $(ipython locate)/profile_default

# Expose Jupyter port & cmd
EXPOSE 8899
EXPOSE 443

VOLUME ["/opt/notebooks"]

WORKDIR $NOTEBOOK_DIR
# relax the permissions on NOTEBOOK_DIR and files by making them world-readable
# See security in https://github.com/phusion/baseimage-docker
RUN chmod 755 $NOTEBOOK_DIR

## Adding orientdb daemon
RUN mkdir /etc/service/jupyterlab
ADD jupyterlab.sh /etc/service/jupyterlab/run
# run should be executable. Making sure it is
RUN chmod +x /etc/service/jupyterlab/run

# HEALTHCHECK CMD curl --fail http://localhost:2480/ || exit 1
