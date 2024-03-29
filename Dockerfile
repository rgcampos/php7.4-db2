#CREDTIS https://github.com/jbeduya/php-db2
FROM --platform=linux/amd64 php:7.4-apache-buster

RUN apt-get update && apt-get install -y && \
    apt-get install libldap2-dev libmcrypt-dev -y

RUN docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ && \
    docker-php-ext-install ldap

RUN pecl install mcrypt-1.0.4 && \
    docker-php-ext-enable mcrypt


ADD resources/clidriver.tar.gz /

ADD resources/PDO_IBM-1.3.4.tgz /

RUN pecl channel-update pecl.php.net

RUN yes '/clidriver' | pecl install ibm_db2 && docker-php-ext-enable ibm_db2

RUN cd /PDO_IBM-1.3.4 && phpize && ./configure --with-pdo-ibm=/clidriver && make install && docker-php-ext-enable pdo_ibm