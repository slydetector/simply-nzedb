FROM alpine:edge
MAINTAINER theslydetector@gmail.com

# Configure Timezone
ENV TIMEZONE "America/Chicago"
RUN rm -f /etc/localtime && \
  ln -s "/usr/share/zoneinfo/${TIMEZONE}" /etc/localtime && \
  echo "${TIMEZONE}" > /etc/timezone

# Install Dependancies and Application
RUN apk add --update \
  bwm-ng \
  curl \
  wget \
  git \
  unzip \
  tar \
  lame \
  p7zip \
  file \
  ffmpeg \
  iproute2 \
  mariadb-client \
  php7-fpm \
  php7-dev \
  php7-pear \
  php7-gd \
  php7-curl \
  php7-json \
  php7-iconv \
  php7-pdo \
  php7-exif \
  php7-phar \
  php7-openssl \
  php7-pcntl \
  php7-pdo_mysql \
  proxychains-ng \
  py2-pip \
  python \
  php7-ctype \
  s6 \
  nginx \
  memcached \
  musl \
  tree \
  htop \
  bash \
  make \
  php7-mcrypt \
  php7-opcache \
  php7-sockets \
  php7-zlib \
  unrar \
  zendframework \
  && \
  rm -rf /var/cache/apk/*

# vnstat in testing repo

# mytop + deps
R UN apk add --update \
  mariadb \
  perl \
  perl-dbd-mysql \
  perl-term-readkey \
  && \
  rm -rf /var/cache/apk/*

# Dev tools
RUN apk add --update strace tig vim

# Install composer
RUN curl https://getcomposer.org/installer | php7 -- --install-dir=/usr/bin --filename=composer

# Build and install simple_php_yenc_decode
# Blocked: needs PHP7 support pending SWIG 3.1.0
RUN apk --update add boost-dev boost-regex gcc g++ php7-dev swig && \
  cd /tmp && \
  git clone https://github.com/kevinlekiller/simple_php_yenc_decode && \
  cd simple_php_yenc_decode/source && \
  swig -php -c++ yenc_decode.i && \
  g++ `php-config7 --includes` -fpic -c yenc_decode_wrap.cpp && \
  g++ -fpic -c yenc_decode.cpp -lboost_regex && \
  g++ -shared *.o -o simple_php_yenc_decode.so -lboost_regex && \
  mkdir -p /usr/lib64/php/extensions && \
  cp -p simple_php_yenc_decode.so /usr/lib64/php/extensions && \
  sed -ri s,extension=,extension=/usr/lib64/php/extensions/simple_php_yenc_decode.so,g /etc/php5/php.ini && \
  cd ~ && \
  rm -rf /tmp && \
  apk del --purge boost-dev boost-regex gcc g++ php7-dev swig && \
  rm -rf /var/cache/apk/*

# Build and install mediainfo
ENV MEDIAINFO_VERSION 0.7.91
RUN apk --update add gcc g++ && \
  mkdir -p /tmp && \
  cd /tmp && \
  curl -s -o mediainfo.tar.gz \
    https://mediaarea.net/download/binary/mediainfo/${MEDIAINFO_VERSION}/MediaInfo_CLI_${MEDIAINFO_VERSION}_GNU_FromSource.tar.gz && \
  tar xzvf mediainfo.tar.gz && \
  cd MediaInfo_CLI_GNU_FromSource && \
  ./CLI_Compile.sh && \
  cd MediaInfo/Project/GNU/CLI && \
  make install && \
  cd / && \
  rm -rf /tmp && \
  apk del --purge gcc g++ && \
  rm -rf /var/cache/apk/*


# Install Python MySQL Modules
RUN pip install --upgrade pip && \
  pip install --upgrade setuptools && \
  pip install cymysql pynntp socketpool

# Configure PHP
RUN sed -ri 's/(max_execution_time =) ([0-9]+)/\1 120/' /etc/php5/php.ini && \
  sed -ri 's/(memory_limit =) ([0-9]+)/\1 -1/' /etc/php5/php.ini && \
  sed -ri 's/;(date.timezone =)/\1 America\/Chicago/' /etc/php5/php.ini && \
  sed -ri 's/;*listen\s*=\s*127.0.0.1:9000/listen = 9000/g' /etc/php5/php-fpm.conf && \
  mkdir -p /var/log/php-fpm/

# Install and configure nginx.
RUN mkdir -p /var/log/nginx && \
    mkdir -p /etc/nginx && \
    mkdir -p /tmp/nginx && \
    chmod 755 /var/log/nginx && \
    chmod 777 /tmp && \
    touch /var/log/nginx/nginx-error.log

# Clone nZEDb and set directory permissions
ENV NZEDB_VERSION "v0.6.6.2"
RUN mkdir -p /var/www && \
  cd /var/www && \
  git clone https://github.com/nZEDb/nZEDb.git && \
  cd /var/www/nZEDb && \
  git checkout --quiet --force $NZEDB_VERSION && \
  composer install && \
	chmod -R 777 /var/www/nZEDb/ && \
	cp /var/www/nZEDb/nzedb/config/settings.example.php /var/www/nZEDb/nzedb/config/settings.php && \
  # nuke all git repos' .git dir except for nzedb's .git dir to save space
  find . -name ".git" -type d | grep -v "\.\/\.git" | xargs rm -rf && \
  # nuke ~350MB of composer cache
  composer clear-cache

# Build tmux 2.0 since tmux 2.2 has issues: https://github.com/nZEDb/nZEDb/issues/2182 
ENV TMUX_VERSION 2.0
RUN apk --update add gcc g++ ncurses-dev libevent-dev bsd-compat-headers && \
  mkdir -p /tmp/tmux && \
  cd /tmp/tmux && \
  curl --location -o tmux.tar.gz https://github.com/tmux/tmux/releases/download/${TMUX_VERSION}/tmux-${TMUX_VERSION}.tar.gz && \
  tar xzvf tmux.tar.gz && \
  cd tmux-${TMUX_VERSION} && \
  ./configure --prefix /usr && \
  make && \
  make install && \
  cd / && \
  rm -rf /tmp/tmux && \
  apk del --purge gcc g++ ncurses-dev libevent-dev bsd-compat-headers && \
  rm -rf /var/cache/apk/*

# Create dir for importing nzbs
RUN mkdir -p /var/www/nZEDb/resources/import

# Switch out php executable to instrument invocations
RUN mv /usr/bin/php /usr/bin/php.real
COPY php.proxy /usr/bin/php

# iconv has issues in musl which affects NFO conversion to include
# cool ascii chars. Remove the problematic parts - TRANSLIT and IGNORE
# See https://github.com/slydetector/simply-nzedb/issues/31
RUN sed -i "s|UTF-8//IGNORE//TRANSLIT|UTF-8|g" /var/www/nZEDb/nzedb/utility/Text.php

# Build phpredis
ENV PHPREDIS_VERSION 2.2.8
RUN apk --update add gcc g++ autoconf && \
  mkdir -p /tmp/phpredis && \
  cd /tmp/phpredis && \
  curl --location -o phpredis.tar.gz https://github.com/phpredis/phpredis/archive/${PHPREDIS_VERSION}.tar.gz && \
  tar xzvf phpredis.tar.gz && \
  cd phpredis-${PHPREDIS_VERSION} && \
  phpize && \
  ./configure && \
  make && \
  make install && \
  echo "extension=redis.so" > /etc/php5/conf.d/redis.ini && \
  cd / && \
  rm -rf /tmp/phpredis && \
  apk del --purge gcc g++ autoconf && \
  rm -rf /var/cache/apk/*

ENV TERM tmux
EXPOSE 8800
ADD s6 /etc/s6
CMD ["/bin/s6-svscan","/etc/s6"]
WORKDIR /var/www/nZEDb/misc/update
