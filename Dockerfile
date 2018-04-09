FROM rocketchat/base:8

ENV RC_VERSION 0.64.0-develop

LABEL maintainer=sdatta

RUN mkdir -p /tmp \
    && mkdir -p /app \
    && mkdir -p /app/uploads \
    && mkdir -p /app/bundle

ADD Rocket.Chat.tar.gz /app

RUN cd /app/bundle/programs/server \
    && npm install \
    && npm cache clear --force \
    && chown -R rocketchat:rocketchat /app

USER rocketchat

VOLUME /app/uploads

WORKDIR /app/bundle

ENV DEPLOY_METHOD=docker \
    NODE_ENV=production \
    MONGO_URL=mongodb://bglr-mongodb-01.rnd.projectplace.com/rocketchat_sdatta \
    HOME=/tmp \
    PORT=3000 \
    ROOT_URL=http://localhost:3000 \
    Accounts_AvatarStorePath=/app/uploads

EXPOSE 3000

CMD ["node", "main.js"]
