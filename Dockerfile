ARG BASE=python:alpine
FROM ${BASE}

ARG QL_MAINTAINER="whyour"
LABEL maintainer="${QL_MAINTAINER}"
ARG QL_URL=https://github.com/${QL_MAINTAINER}/qinglong.git
ARG QL_BRANCH=master
ARG QL_STATIC_BRANCH=master

ENV PNPM_HOME=/root/.local/share/pnpm \
    PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/root/.local/share/pnpm:/root/.local/share/pnpm/global/5/node_modules:$PNPM_HOME \
    LANG=zh_CN.UTF-8 \
    SHELL=/bin/bash \
    PS1="\u@\h:\w \$ " \
    QL_DIR=/ql \
    QL_BRANCH=${QL_BRANCH}

WORKDIR ${QL_DIR}

RUN set -x \
    && sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk update -f \
    && apk upgrade \
    && git clone -b ${QL_BRANCH} ${QL_URL} ${QL_DIR} \
    && cd ${QL_DIR} \
    && cp -f .env.example .env \
    && chmod 777 ${QL_DIR}/shell/*.sh \
    && chmod 777 ${QL_DIR}/docker/*.sh \
    && pnpm install --prod \
    && rm -rf /root/.pnpm-store \
    && rm -rf /root/.local/share/pnpm/store \
    && rm -rf /root/.cache \
    && rm -rf /root/.npm \
    && git clone -b ${QL_STATIC_BRANCH} https://github.com/${QL_MAINTAINER}/qinglong-static.git /static \
    && mkdir -p ${QL_DIR}/static \
    && cp -rf /static/* ${QL_DIR}/static \
    && rm -rf /static
    
ENTRYPOINT ["./docker/docker-entrypoint.sh"]
