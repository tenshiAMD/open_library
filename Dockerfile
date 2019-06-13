FROM ruby:2.6-stretch

USER root

ENV TZ=UTC \
    DEBIAN_FRONTEND=noninteractive \
    DEBIAN_VERSION=stretch

## Set LOCALE to UTF8
RUN apt-get update -qq \
    && apt-get install --no-install-recommends -y locales \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
    && locale-gen en_US.UTF-8 \
    && dpkg-reconfigure locales \
    && /usr/sbin/update-locale LANG=en_US.UTF-8
ENV LC_ALL en_US.UTF-8

## Install required packages
RUN apt-get update -qq \
    && apt-get install --no-install-recommends -y \
        libpq-dev \
        curl \
        gnupg1 \
        apt-transport-https \
        ca-certificates \
        sudo \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

## Install Nginx
# Based on https://github.com/nginxinc/docker-nginx/blob/master/stable/stretch/Dockerfile,
# but adapted for Debian, because the Ruby image is using this.
ENV NGINX_VERSION="1.14.2-1~${DEBIAN_VERSION}" \
    NJS_VERSION="1.14.2.0.2.6-1~${DEBIAN_VERSION}"
RUN set -x; \
	NGINX_GPGKEY=573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62; \
	found=''; \
	for server in \
        ha.pool.sks-keyservers.net \
    	hkp://keyserver.ubuntu.com:80 \
    	hkp://p80.pool.sks-keyservers.net:80 \
    	pgp.mit.edu \
    ; do \
    	echo "Fetching GPG key $NGINX_GPGKEY from $server"; \
    	apt-key adv --batch --keyserver "$server" --keyserver-options timeout=10 --recv-keys "$NGINX_GPGKEY" && found=yes && break; \
    done; \
	test -z "$found" && echo >&2 "error: failed to fetch GPG key $NGINX_GPGKEY" && exit 1; \
	exit 0
RUN echo "deb http://nginx.org/packages/debian/ ${DEBIAN_VERSION} nginx" >> /etc/apt/sources.list \
	&& apt-get update -qq \
	&& apt-get install --no-install-recommends --no-install-suggests -y \
						nginx=${NGINX_VERSION} \
						nginx-module-xslt=${NGINX_VERSION} \
						nginx-module-geoip=${NGINX_VERSION} \
						nginx-module-image-filter=${NGINX_VERSION} \
						nginx-module-njs=${NJS_VERSION} \
						gettext-base \
	&& rm -rf /var/lib/apt/lists/*
# Forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log
EXPOSE 80

## Install Node.js
# Based on https://github.com/nodejs/docker-node/blob/master/11/stretch/Dockerfile
# gpg keys listed at https://github.com/nodejs/node#release-team
RUN groupadd --gid 1000 node \
    && useradd --uid 1000 --gid node --shell /bin/bash --create-home node
RUN set -x; \
  for key in \
    94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
    FD3A5288F042B6850C66B31F09FE44734EB7990E \
    71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
    DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
    C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
    B9AE9905FFD7803F25714661B63B535A4C206CA9 \
    77984A986EBC2AA786BC0F66B01FBB92821C587A \
    8FCCA13FEF1D0C2E91008E09770F7A9A5AE15600 \
    4ED778F539E3634C779C87C6D7062848A1AB005C \
    A48C2BEE680E841632CD4E44F07496B3EB3C1762 \
    B9E2F5981AA6E0CD28160D9FF13993A75599653C \
  ; do \
    gpg --batch --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" || \
    gpg --batch --keyserver hkp://ipv4.pool.sks-keyservers.net --recv-keys "$key" || \
    gpg --batch --keyserver hkp://pgp.mit.edu:80 --recv-keys "$key" ; \
  done
ENV NODE_VERSION 11.9.0
RUN ARCH= && dpkgArch="$(dpkg --print-architecture)" \
  && case "${dpkgArch##*-}" in \
    amd64) ARCH='x64';; \
    ppc64el) ARCH='ppc64le';; \
    s390x) ARCH='s390x';; \
    arm64) ARCH='arm64';; \
    armhf) ARCH='armv7l';; \
    i386) ARCH='x86';; \
    *) echo "unsupported architecture"; exit 1 ;; \
  esac \
  && curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-$ARCH.tar.xz" \
  && curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
  && gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \
  && grep " node-v$NODE_VERSION-linux-$ARCH.tar.xz\$" SHASUMS256.txt | sha256sum -c - \
  && tar -xJf "node-v$NODE_VERSION-linux-$ARCH.tar.xz" -C /usr/local --strip-components=1 --no-same-owner \
  && rm "node-v$NODE_VERSION-linux-$ARCH.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt \
  && ln -s /usr/local/bin/node /usr/local/bin/nodejs

## Install Yarn
# Based on https://github.com/nodejs/docker-node/blob/master/11/stretch/Dockerfile
ENV YARN_VERSION 1.13.0
RUN set -ex \
  && for key in \
    6A010C5166006599AA17F08146C2130DFD2497F5 \
  ; do \
    gpg --batch --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys "$key" || \
    gpg --batch --keyserver hkp://ipv4.pool.sks-keyservers.net --recv-keys "$key" || \
    gpg --batch --keyserver hkp://pgp.mit.edu:80 --recv-keys "$key" ; \
  done \
  && curl -fsSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz" \
  && curl -fsSLO --compressed "https://yarnpkg.com/downloads/$YARN_VERSION/yarn-v$YARN_VERSION.tar.gz.asc" \
  && gpg --batch --verify yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz \
  && mkdir -p /opt \
  && tar -xzf yarn-v$YARN_VERSION.tar.gz -C /opt/ \
  && ln -s /opt/yarn-v$YARN_VERSION/bin/yarn /usr/local/bin/yarn \
  && ln -s /opt/yarn-v$YARN_VERSION/bin/yarnpkg /usr/local/bin/yarnpkg \
  && rm yarn-v$YARN_VERSION.tar.gz.asc yarn-v$YARN_VERSION.tar.gz

## Install activestorage required dependencies
ENV IMAGEMAGIC_VERSION="8:6.9.7.4+dfsg-11+deb9u7" \
    POPPLER_VERSION="0.48.0-2+deb9u2" \
    MUPDF_VERSION="1.9a+ds1-4+deb9u4" \
    FFMPEG_VERSION="7:3.2.12-1~deb9u1"
RUN apt-get update -qq \
    && apt-get install --no-install-recommends -y \
        imagemagick=${IMAGEMAGIC_VERSION} \
        poppler-utils=${POPPLER_VERSION} \
        mupdf-tools=${MUPDF_VERSION} \
        ffmpeg=${FFMPEG_VERSION} \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

## Install dockerize
ENV DOCKERIZE_VERSION v0.6.1
RUN curl -fsSLO --compressed "https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz" \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

## Cleanup
RUN apt-get clean autoclean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/

## Create user and group
ENV APP_HOME=/home/app \
    APP_USER=app
RUN mkdir -p ${APP_HOME}
WORKDIR $APP_HOME
RUN groupadd --gid 9999 ${APP_USER} \
    && useradd --uid 9999 --gid ${APP_USER} ${APP_USER} \
    && usermod -a -G www-data,nginx,node ${APP_USER} \
    && chown -R ${APP_USER}:${APP_USER} ${APP_HOME}

## Setup
COPY docker/*.sh docker/liquid /usr/local/bin/
COPY docker/nginx/nginx.liquid /etc/nginx/
COPY docker/nginx/conf.d /etc/nginx/conf.d
RUN chmod +x /usr/local/bin/*.sh /usr/local/bin/liquid \
    && rm -rf /etc/nginx/sites-available/* /etc/nginx/sites-enabled/* \
    && chown -R nginx:nginx /etc/nginx \
    && chown -R node:node /usr/local/lib/node_modules \
    && chmod -R 774 /etc/nginx /usr/local/lib/node_modules \
    && echo "${APP_USER} ALL=(ALL) NOPASSWD: /usr/sbin/nginx" >> /etc/sudoers \
    && mkdir -p /var/${APP_USER}/bundle \
        /var/${APP_USER}/node_modules \
        /var/${APP_USER}/files \
        /var/${APP_USER}/tmp \
        /var/${APP_USER}/run \
    && chown -R ${APP_USER}:${APP_USER} /var/${APP_USER}
VOLUME ["/var/${APP_USER}"]

## Install bundler & update gem
ENV RUBYGEMS_VERSION="3.0.2" \
    BUNDLER_VERSION="1.17.3"
RUN echo "gem: --no-document" >> /usr/local/etc/gemrc
RUN gem update --system ${RUBYGEMS_VERSION} \
    && gem install -v ${BUNDLER_VERSION} bundler \
    && chmod -R 777 "${GEM_HOME}"

## Install liquid
ENV LIQUID_VERSION="4.0.1"
RUN gem install -v ${LIQUID_VERSION} liquid

## Set default environment
ENV BUNDLE_GITHUB__HTTPS=true \
    BUNDLE_JOBS=20 \
    BUNDLE_RETRY=3 \
    BUNDLE_WITHOUT="development test" \
    RAILS_LOG_TO_STDOUT=true \
    BUNDLE_PATH=/var/${APP_USER}/bundle \
    RAILS_TMP=/var/${APP_USER}/tmp \
    NPM_CONFIG_PREFIX=/var/${APP_USER}/node_modules \
    WEB_CONCURRENCY=1 \
    RAILS_MAX_THREADS=25 \
    SIDEKIQ_CONCURRENCY=10 \
    SIDEKIQ_TIMEOUT=8 \
    SIDEKIQ_QUEUES="default,mailers,low_priority" \
    PATH=${BUNDLE_PATH}/bin:${NPM_CONFIG_PREFIX}/bin:${PATH}

STOPSIGNAL SIGTERM

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

## Web Application Setup

COPY docker/app/*.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/*.sh

## Copy the code
RUN rm -rf ${APP_HOME}/*
COPY . ${APP_HOME}/
RUN mkdir -p log tmp \
    && rm -rf log/* tmp/* \
    && mkdir -p tmp/pids \
    && chown -R ${APP_USER}:${APP_USER} \
        ${APP_HOME}

USER ${APP_USER}

HEALTHCHECK --interval=1m --start-period=1m CMD /usr/local/bin/check-app.sh

CMD ["/usr/local/bin/start-app.sh"]

## Set default environment
ENV APP_NAME="Open Library" \
    APP_ID=open_library \
    RAILS_ENV=production \
    RACK_ENV=production \
    BUNDLE_PATH=${APP_HOME}/vendor/bundle
RUN bundle config --global frozen 1
RUN bundle config --local path ${BUNDLE_PATH}

ARG BUILD_CREATED
ARG BUILD_REVISION
ENV REVISION=${BUILD_REVISION}
