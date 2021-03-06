# Download and install ZeroMQ 3.2.5 inside a docker container.
# Name it dongjaek/zmq3.2.5:latest
FROM dongjaek/dev:base
MAINTAINER Dongjae Kim (david.kim9325@gmail.com)
# The vast majority of the documentation of zeromq is for version 3xx so it would be best to use that version until we are comfortable enough to use 4xx.
# to link: g++ -o hello main.cc -lzmq

# Setup 
USER root 
# Grab the zeromq 3xx tarball
WORKDIR /home/docker
RUN curl -L https://github.com/zeromq/zeromq3-x/releases/download/v3.2.5/zeromq-3.2.5.tar.gz > zeromq-3.2.5.tar.gz
RUN tar -xvf zeromq-3.2.5.tar.gz
# Install zeromq 3xx
WORKDIR /home/docker/zeromq-3.2.5
RUN ./configure 
RUN make 
RUN make install 
# Grab the C++ headers
WORKDIR /home/docker
RUN mkdir headers  
WORKDIR /home/docker/headers
RUN git clone https://github.com/zeromq/cppzmq
RUN mv /home/docker/headers/cppzmq/zmq.hpp /usr/local/include	
RUN mv /home/docker/headers/cppzmq/zmq_addon.hpp /usr/local/include
# Cleanup the tarball, the untarred directory and the headers
WORKDIR /home/docker
RUN rm -rf /home/docker/headers
RUN rm -rf /home/docker/zeromq-3.2.5
RUN rm -rf /home/docker/zeromq-3.2.5.tar.gz
# Set library environment variable to allow linking
ENV LD_LIBRARY_PATH /usr/local/lib

USER docker 
CMD /bin/bash
