FROM alpine:3.7

ENV DOCKER_CHANNEL=stable \
    DOCKER_VERSION=17.12.1-ce \
    DOCKER_COMPOSE_VERSION=1.19.0 \
    DOCKER_SQUASH=0.2.0

# Install Docker, Docker Compose, Docker Squash
RUN apk --update --no-cache add \
        bash \
        curl \
        device-mapper \
        # gcc \
        # musl-dev \
        # python3 \
        # python3-dev \
        iptables \
        ca-certificates \
        nodejs \
        nodejs-npm \
        yarn \
        util-linux \
        && \
    apk upgrade && \
    curl -fL "https://download.docker.com/linux/static/${DOCKER_CHANNEL}/x86_64/docker-${DOCKER_VERSION}.tgz" | tar zx && \
    mv /docker/* /bin/ && chmod +x /bin/docker* && \
    npm i -g snyk --unsafe-perm && \
    curl -fL "https://github.com/jwilder/docker-squash/releases/download/v${DOCKER_SQUASH}/docker-squash-linux-amd64-v${DOCKER_SQUASH}.tar.gz" | tar zx && \
    mv /docker-squash* /bin/ && chmod +x /bin/docker-squash* && \
    # pip3 install --upgrade pip && \
    # ln -s /usr/bin/python3 /usr/bin/python && \
    # ln -s /usr/bin/pip3 /usr/bin/pip && \
    rm -rf /var/cache/apk/* && \
    rm -rf /root/.cache && \
    snyk config set disableSuggestions=true

COPY entrypoint.sh /bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
