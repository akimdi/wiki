#!/bin/bash
sudo pacman -Syyu --needed --noconfirm composer doxygen drupal php php-apache php-apcu php-apcu-bc php-cgi php-dblib php-embed php-enchant php-fpm php-gd php-geoip php-grpc php-igbinary php-imagick php-imap php-intl phpldapadmin php-memcache php-memcached php-mongodb phpmyadmin php-odbc phppgadmin php-pgsql php-phpdbg php-pspell php-redis php-snmp php-sodium php-sqlite php-tidy php-xsl xdebug redis certbot-nginx gixy nginx nginx-mod-auth-pam nginx-mod-brotli nginx-mod-cache_purge nginx-mod-echo nginx-mod-geoip2 nginx-mod-headers-more nginx-mod-memc nginx-mod-modsecurity nginx-mod-naxsi nginx-mod-ndk nginx-mod-njs nginx-mod-pagespeed nginx-mod-passenger nginx-mod-redis nginx-mod-redis2 nginx-mod-set-misc nginx-mod-srcache innotop mariadb mariadb-clients mariadb-libs mytop rubygems ruby-irb ruby-reline freetype2 ruby harfbuzz gearmand apache certbot-apache solr go avahi pacredir xdebug cockpit-docker container-diff docker docker-compose docker-machine rabbitmq rabbitmqadmin grafana exa bat vim nano nano-syntax-highlighting ranger nnn ripgrep git git-lfs yarn bower grunt-cli gulp redis postgis postgresql postgresql-docs postgresql-ip4r postgresql-libs memcached apm npm npm-check-updates nodejs nodejs-less unzip && composer global require laravel/installer && sudo systemctl start nginx && sudo systemctl enable nginx