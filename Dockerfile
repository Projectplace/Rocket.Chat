FROM node:latest

LABEL maintainer=sdatta

RUN apt-get update && apt-get install -y curl ca-certificates imagemagick --no-install-recommends \
    && groupadd -g 99999 -r rocketchat \
    && useradd -u 99999 -r -g rocketchat rocketchat \
    && mkdir -p /tmp/tarfile \
    && mkdir -p /app \
    && mkdir -p /app/uploads \
    && mkdir -p /app/bundle

ADD ./build-output-rcchat/Rocket.Chat.tar /tmp/tarfile

RUN tar -zxf /tmp/tarfile/Rocket.Chat.tar /app

WORKDIR /app/bundle

RUN chown -R rocketchat:rocketchat /app \
    && chmod +x ./meteor_install \
    && sh ./meteor_install \
    && npm install \
    && npm cache clear --force

USER rocketchat

VOLUME /app/uploads

ENV DEPLOY_METHOD=docker \
    NODE_ENV=production \
    MONGO_URL=mongodb://bglr-mongodb-02.rnd.projectplace.com/rocketchat_sdatta \
    HOME=/tmp \
    PORT=3000 \
    ROOT_URL=http://localhost:3000 \
    Accounts_AvatarStorePath=/app/uploads

EXPOSE 3000

CMD ["node", "main.js"]
