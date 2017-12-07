# Pull base image
FROM resin/rpi-raspbian:wheezy
MAINTAINER Dieter Reuter <dieter@hypriot.com>


# install apt packages
RUN apt-get update && apt-get install -yq \
    python3 \
    python3-dev \
    python3-pip \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*



# install python modules
ADD requirements.txt /
RUN pip3 install --upgrade pip
RUN pip3 install -r requirements.txt


# setup juptyer
RUN jupyter nbextension enable --py --sys-prefix widgetsnbextension
RUN jupyter contrib nbextension install --user
RUN jupyter nbextension enable codefolding/main
RUN echo "c.NotebookApp.ip = '*'" >> /root/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.port = 8080" >> /root/.jupyter/jupyter_notebook_config.py
RUN echo "c.NotebookApp.token = ''" >> /root/.jupyter/jupyter_notebook_config.py

# Define working directory
WORKDIR /data

# Define default command
EXPOSE 8080
CMD ["jupyter", "notebook", "--no-browser", "--allow-root"]