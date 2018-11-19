FROM mariadb:10.1
MAINTAINER theslydetector@gmail.com

# MariaDB Configuration
RUN sed -i -r 's/bind-address.*$/bind-address = 0.0.0.0/' /etc/mysql/my.cnf \
  && sed -i -r 's/port.*$/port = 3306'/ /etc/mysql/my.cnf

# To avoid mysql whining about this variable
ENV TERM dumb 

RUN apt-get update \
  && apt-get install -y wget \
  && rm -rf /var/lib/apt/lists/*

ENV MYSQL_TUNER_VERSION 1.7.2
RUN wget -O /mysqltuner.tar.gz https://github.com/major/MySQLTuner-perl/archive/${MYSQL_TUNER_VERSION}.tar.gz \
  && cd / \
  && tar xzvf mysqltuner.tar.gz \
  && mv MySQLTuner-perl-${MYSQL_TUNER_VERSION} mysqltuner \
  && rm /mysqltuner.tar.gz \
  && chmod +x /mysqltuner/mysqltuner.pl

# Install hook to change mysql user id on startup
COPY moduser-entrypoint.sh /usr/local/bin
ENTRYPOINT ["moduser-entrypoint.sh"]
CMD ["mysqld"]
