# A private npm registry based on Docker and Kappa
#
# Version: 0.1.0

MAINTAINER jwvdiermen

FROM stackbrew/ubuntu:12.04

ENV NPM_VHOST npm.justdeploy.eu
ENV COUCHDB_ADMIN_PASSWORD your_secret_password
ENV KAPPA_REPOSITORY https://github.com/jwvdiermen/kappa-npm-proxy.git

RUN export DEBIAN_FRONTEND=noninteractive

# Install nodejs
RUN	apt-get update
RUN apt-get install -y python-software-properties python g++ make git-core
RUN add-apt-repository -y ppa:chris-lea/node.js
RUN apt-get update
RUN apt-get install -y nodejs

# Install CouchDB
RUN apt-get install -y build-essential autoconf automake libtool erlang libicu-dev libmozjs-dev libcurl4-openssl-dev wget

RUN cd /tmp && wget http://apache.mirrors.hostinginnederland.nl/couchdb/source/1.5.0/apache-couchdb-1.5.0.tar.gz && tar xfv apache-couchdb-1.5.0.tar.gz && cd apache-couchdb-1.5.0
RUN ./configure && make && make install 

RUN printf "\n[httpd]\nbind_address = 0.0.0.0\nsecure_rewrites = false\n" >> /usr/local/etc/couchdb/local.ini
RUN printf "\n[vhosts]\n${NPM_VHOST}:5984 = /registry/_design/scratch/_rewrite\n" >> /usr/local/etc/couchdb/local.ini
RUN printf "\n[admins]\nadmin = ${COUCHDB_ADMIN_PASSWORD}\n" >> /usr/local/etc/couchdb/local.ini

# Install Kappa
RUN cd /var/ && git clone ${KAPPA_REPOSITORY} kappa && cd kappa

# Install Supervisor
RUN apt-get -y install supervisor

# Copy configuration files.
ADD ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

ADD ./kappa-config.json /var/kappa/config.json
RUN sed -i '/'s/npm.justdeploy.eu/${NPM_VHOST}/g' /etc/supervisor/conf.d/supervisord.conf

# Cleanup after install
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

EXPOSE 5984
EXPOSE 80

ADD	./start.sh /start.sh
RUN	chmod +x /start.sh
CMD	["/bin/bash", "/start.sh"]
