FROM mariadb:10.1.19
MAINTAINER theslydetector@gmail.com

# MariaDB Configuration
RUN sed -i -r 's/bind-address.*$/bind-address = 0.0.0.0/' /etc/mysql/my.cnf  
RUN sed -i -r 's/port.*$/port = 3306'/ /etc/mysql/my.cnf

# To avoid mysql whining about this variable
ENV TERM dumb 

# Install hook to change mysql user id on startup
COPY moduser-entrypoint.sh /usr/local/bin
ENTRYPOINT ["moduser-entrypoint.sh"]
CMD ["mysqld"]
