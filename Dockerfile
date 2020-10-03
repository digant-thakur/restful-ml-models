FROM ubuntu

RUN apt-get -y update && apt-get install -y --no-install-recommends \
         nginx \    
         && rm -rf /var/lib/apt/lists/* 