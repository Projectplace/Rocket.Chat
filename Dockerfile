FROM rocketchat/base:8

ENV RC_VERSION 0.64.0-develop

LABEL maintainer=sdatta

RUN mkdir -p /tmp \
    && mkdir -p /app \
    && mkdir -p /app/uploads \
    && mkdir -p /app/bundle \
    && mkdir -p /app/config

ADD pp_config /app/config

ADD Rocket.Chat.tar.gz /app

RUN apt-get update \
    && apt-get install -y \
       build-essential \
       gcc \
       git \
       make \
       python-pip \
       python2.7 \
       python2.7-dev \
       ssh \
    && apt-get autoremove \
    && apt-get clean

RUN pip install -U "setuptools==3.4.1" \
    && pip install "Jinja2==2.6" \
    && pip install "requests==2.18.4" 

RUN cd /app/bundle/programs/server \
    && npm install --unsafe-perm \
    && npm cache clear --force \
    && chown -R rocketchat:rocketchat /app

USER rocketchat

VOLUME /app/uploads

WORKDIR /app/bundle

ADD start_server /app/bundle

RUN chmod +x /app/bundle/start_server

ENV DEPLOY_METHOD=docker \
    NODE_ENV=production \
    HOME=/tmp \
    PORT=3000 \
    ROOT_URL=http://localhost:3000 \
    Accounts_AvatarStorePath=/app/uploads

EXPOSE 3000

