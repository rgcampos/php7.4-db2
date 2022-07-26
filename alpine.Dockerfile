FROM --platform=linux/amd64 php:7.4-alpine3.16

# RUN apk update && apk upgrade && apk add --no-cache bash bash-doc
RUN apk update && apk upgrade
RUN apk add --no-cache openssl-dev libldap openldap-dev libmcrypt-dev gcc ldb-dev autoconf g++ make

# RUN docker-php-ext-install ldap
# RUN docker-php-ext-enable ldap

RUN docker-php-ext-configure ldap --with-libdir=lib/ && \
    docker-php-ext-install ldap

RUN pecl install mcrypt-1.0.4 && \
    docker-php-ext-enable mcrypt


ADD resources/clidriver.tar.gz /

ADD resources/PDO_IBM-1.3.4.tgz /

RUN pecl channel-update pecl.php.net

RUN yes '/clidriver' | pecl install ibm_db2 && docker-php-ext-enable ibm_db2

RUN cd /PDO_IBM-1.3.4 && phpize && ./configure --with-pdo-ibm=/clidriver && make install && docker-php-ext-enable pdo_ibm