FROM alpine:3.6
MAINTAINER theslydetector@gmail.com

# Configure Timezone
ENV TIMEZONE "America/Chicago"
RUN rm -f /etc/localtime && \
  ln -s "/usr/share/zoneinfo/${TIMEZONE}" /etc/localtime && \
  echo "${TIMEZONE}" > /etc/timezone

RUN apk add --update \
  bash bwm-ng \
  coreutils curl \
  ffmpeg file findutils \
  git \
  htop \
  iproute2 \
  lame less \
  make mariadb-client memcached musl \
  nginx \
  p7zip php7-ctype php7-curl php7-dev php7-exif php7-fpm php7-gd php7-iconv \
  php7-imagick php7-json php7-mcrypt php7-opcache php7-openssl php7-pcntl \
  php7-pdo php7-pdo_mysql php7-pear php7-phar php7-posix php7-redis \
  php7-session php7-simplexml php7-sockets php7-xmlwriter php7-zlib pigz \
  proxychains-ng pstree py2-pip python \
  s6 strace \
  tar tig tree tzdata \
  unrar unzip util-linux \
  vim \
  wget \
  zendframework \
  && \
  rm -rf /var/cache/apk/*

# vnstat in testing repo

# mytop + deps
RUN apk add --update \
  mariadb \
  perl \
  perl-dbd-mysql \
  perl-term-readkey \
  && \
  rm -rf /var/cache/apk/*

# Install composer
RUN curl https://getcomposer.org/installer | php7 -- --install-dir=/usr/bin --filename=composer

# Build and install mediainfo
ENV MEDIAINFO_VERSION 17.10
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
RUN sed -ri 's/(max_execution_time =) ([0-9]+)/\1 120/' /etc/php7/php.ini && \
  sed -ri "s/(memory_limit =) (.*$)/\1 -1/" /etc/php7/php.ini && \
  sed -ri 's/;(date.timezone =)/\1 America\/Chicago/' /etc/php7/php.ini && \
  sed -ri 's/listen\s*=\s*127.0.0.1:9000/listen = 9000/g' /etc/php7/php-fpm.d/www.conf && \
  sed -ri 's|;include_path = ".:/php/includes"|include_path = ".:/usr/share/php7"|g' /etc/php7/php.ini && \
  mkdir -p /var/log/php-fpm/

# Install and configure nginx.
RUN mkdir -p /var/log/nginx && \
    mkdir -p /etc/nginx && \
    mkdir -p /tmp/nginx && \
    chmod 755 /var/log/nginx && \
    chmod 777 /tmp && \
    touch /var/log/nginx/nginx-error.log

# Clone nZEDb and set directory permissions
ENV NZEDB_VERSION "v0.8.2.1"
RUN mkdir -p /var/www && \
  cd /var/www && \
  git clone https://github.com/nZEDb/nZEDb.git && \
  cd /var/www/nZEDb && \
  git checkout --quiet --force $NZEDB_VERSION && \
  composer install && \
  chmod -R 777 /var/www/nZEDb/ && \
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

# Build and install php-yenc
ENV PHP_ZEPHIR_PARSER_VERSION v1.1.0
RUN cd /tmp && \
  apk --update add gcc re2c libc-dev sudo && \
  mkdir -p /tmp/zephir && \
  cd /tmp/zephir && \
  composer require phalcon/zephir && \
  cd /tmp && \
  git clone git://github.com/phalcon/php-zephir-parser.git && \
  cd php-zephir-parser && \
  git checkout --quiet --force $PHP_ZEPHIR_PARSER_VERSION && \
  ./install && \
  echo "extension=zephir_parser.so" > /etc/php7/conf.d/98_zephir_parser.ini && \
  cd /tmp && \
  git clone https://github.com/niel/php-yenc.git && \
  cd php-yenc && \
  /tmp/zephir/vendor/bin/zephir install && \
  echo "extension=yenc.so" > /etc/php7/conf.d/99_yenc.ini && \
  composer clear-cache && \
  cd /tmp && \
  rm -rf zephir php-yenc php-zephir-parser && \
  apk del --purge gcc re2c libc-dev sudo

# Build and install par2
ENV PAR2_VERSION "v0.7.4"
RUN apk --update add gcc autoconf automake g++ python-dev openssl-dev libffi-dev && \
  git clone https://github.com/Parchive/par2cmdline.git /tmp/par2 && \
  cd /tmp/par2 && \
  git checkout --quiet --force $PAR2_VERSION && \
  ./automake.sh && \ 
  ./configure --prefix=/usr && \
  make && \
  make install && \
  cd / && \
  rm -rf /tmp/par2 && \
  apk del --purge automake gcc autoconf g++ python-dev openssl-dev libffi-dev && \
  apk add libgomp

# Create dir for importing nzbs
RUN mkdir -p /var/www/nZEDb/resources/import

# Switch out php executable to instrument invocations
RUN mv /usr/bin/php /usr/bin/php.real
COPY php.proxy /usr/bin/php

# Use pigz (parallel gzip) instead of gzip to speed up db backups
RUN mv /bin/gzip /bin/gzip.real && \
  ln -s /usr/bin/pigz /bin/gzip

# iconv has issues in musl which affects NFO conversion to include
# cool ascii chars. Remove the problematic parts - TRANSLIT and IGNORE
# See https://github.com/slydetector/simply-nzedb/issues/31
RUN sed -i "s|UTF-8//IGNORE//TRANSLIT|UTF-8|g" /var/www/nZEDb/nzedb/utility/Text.php

LABEL nzedb=$NZEDB_VERSION \
  maintainer=theslydetector@gmail.com \
  url=https://github.com/slydetector/simply-nzedb

RUN mkdir -p /var/www/nZEDb/resources/tmp && chmod 777 /var/www/nZEDb/resources/tmp

ENV TERM tmux
EXPOSE 8800
ADD s6 /etc/s6
CMD ["/bin/s6-svscan","/etc/s6"]
WORKDIR /var/www/nZEDb/misc/update
