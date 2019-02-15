# =============================================================================
# Dockerfile automated Docker Hub build - Base image for other ones
#
# CentOS-7
# EPEL Repo 
# Supervisor
# Webtatic Repo
# NGINX 
# PHP-FPM
# PHP 7.0
# =============================================================================

FROM centos

MAINTAINER Supermasita <supermasita@supermasita.com>

ENV UPDATED "2019-02-15"

## Import the Centos-7 RPM GPG key to prevent warnings 
## Add EPEL and Webtatic repos
ADD nginx/nginx.repo /etc/yum.repos.d/nginx.repo
RUN rpm --import http://mirror.centos.org/centos/RPM-GPG-KEY-CentOS-7 \
    && rpm --import http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-7 \
    && rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm \
    && rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm

## YUM
RUN yum -y install \
    supervisor \
    memcached \
    php70w-opcache \
    php70w-fpm \
    php70w-pecl-memcached \
    nginx

## Networking
RUN echo -e "NETWORKING=yes\nHOSTNAME=centos7-`date '+%s'`" > /etc/sysconfig/network

## NGINX CONF
ADD nginx/nginx.conf /etc/nginx/nginx.conf
ADD nginx/default.conf /etc/nginx/conf.d/default.conf
ADD nginx/info.php /var/www/index.php

## PHP-FPM CONF
ADD php-fpm/php-fpm.conf /etc/php-fpm.conf
ADD php-fpm/www.conf /etc/php-fpm.d/www.conf

## SUPERVISOR CONF
ADD supervisord/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

## PORTS
EXPOSE 80 443 11211 8080 

## RUN, FORREST! RUN!
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

