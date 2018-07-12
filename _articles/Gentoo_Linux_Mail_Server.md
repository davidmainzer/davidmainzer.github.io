---
layout: article
title:  "Gentoo Linux as Mail-Server"
date:   2018-07-09 08:00:00
share: true
toc: true
comments: false
tags:
 - Gentoo
 - Article
---

I use a very good and detailed guide created by [Thomas Leister](https://thomas-leister.de/mailserver-debian-stretch/).
Since I have a Gentoo Linux running I want to explain within this article how you can use this guide for Gentoo Linux. Therefore, please read this guide first to get an overview of all the stuff.

# Requirements 

You have to had a are running a Gentoo Linux with working internet connection.

# Goal

At the end we will have a running Gentoo Server with:
- Dovecot
- Postfix
- MySQL
- Rspamd
- Postfix-Admin
 
# Mail-Server
 
## Certifications
 
{% highlight bash %}
  emerge -av app-crypt/certbot
  emerge -av app-crypt/certbot-nginx
{% endhighlight bash %}

## Database

We will use MariaDB as Database (https://wiki.gentoo.org/wiki/MariaDB):
If you do not have mariadb installed already you have to configure it, therefore, we can use a predefined configuration helper:
{% highlight bash %}
  emerge -av --config dev-db/mariadb
{% endhighlight bash %}

Start Database and add them to your autostart:
{% highlight bash %}
  rc-update add mysql default
  rc-service mysql start
{% endhighlight bash %}

Open MySQL Root Shell to perform SQL commands:
{% highlight bash %}
  mysql -u root -p -h localhost
{% endhighlight bash %}

The first step is to create a database for our mail-service, called `vmail`:
{% highlight bash %}
  create database vmail CHARACTER SET 'utf8';
{% endhighlight bash %}

Create a user who can access the database using `vmaildbpass` as password (please use a secure one):
{% highlight bash %}
  grant select on vmail.* to 'vmail'@'localhost' identified by 'vmaildbpass';
{% endhighlight bash %}

Next step we have to use our database `vmail`:
{% highlight bash %}
  use vmail;
{% endhighlight bash %}


** CHECK IF WE NEED THIS ... SINCE WE WILL USE POSTFIX-ADMIN **

Our Mail-setup will use 4 different tables. Therefore, we have to create them:

### Domain Table
{% highlight bash %}
  CREATE TABLE `domains` (
    `id` int unsigned NOT NULL AUTO_INCREMENT,
    `domain` varchar(255) NOT NULL,
    PRIMARY KEY (`id`),
    UNIQUE KEY (`domain`)
  );
{% endhighlight bash %}

### Account Table
{% highlight bash %}
  CREATE TABLE `accounts` (
    `id` int unsigned NOT NULL AUTO_INCREMENT,
    `username` varchar(64) NOT NULL,
    `domain` varchar(255) NOT NULL,
    `password` varchar(255) NOT NULL,
    `quota` int unsigned DEFAULT '0',
    `enabled` boolean DEFAULT '0',
    `sendonly` boolean DEFAULT '0',
    PRIMARY KEY (id),
    UNIQUE KEY (`username`, `domain`),
    FOREIGN KEY (`domain`) REFERENCES `domains` (`domain`)
  );
{% endhighlight bash %}

### Alias Table
{% highlight bash %}
  CREATE TABLE `aliases` (
    `id` int unsigned NOT NULL AUTO_INCREMENT,
    `source_username` varchar(64) NOT NULL,
    `source_domain` varchar(255) NOT NULL,
    `destination_username` varchar(64) NOT NULL,
    `destination_domain` varchar(255) NOT NULL,
    `enabled` boolean DEFAULT '0',
    PRIMARY KEY (`id`),
    UNIQUE KEY (`source_username`, `source_domain`, `destination_username`, `destination_domain`),
    FOREIGN KEY (`source_domain`) REFERENCES `domains` (`domain`)
  );
{% endhighlight bash %}

### TLS Policy-Tabelle

{% highlight bash %}

{% endhighlight bash %}

# vmail-user

We will use `/home/vmail` as mail-server file storage directory (mailboxes, filter-scripts, ...):
{% highlight bash %}
  mkdir /home/vmail
{% endhighlight bash %}

vmail-Systembenutzer erstellen:
{% highlight bash %}
  useradd --shell /usr/sbin/nologin -d /home/vmail vmail
{% endhighlight bash %}

vmail Unterverzeichnisse erstellen:
{% highlight bash %}
  mkdir /home/vmail/mailboxes
  mkdir -p /home/vmail/sieve/global
{% endhighlight bash %}

/var/vmail an vmail-User übereignen und Verzeichnisrechte passend setzen:
{% highlight bash %}
  chown -R vmail:vmail /home/vmail
  chmod -R 770 /home/vmail
{% endhighlight bash %}

# Dovecot
{% highlight bash %}
  emerge -av net-mail/dovecot
{% endhighlight bash %}

Please ensure that at least the following USE-flags are enabled.
{% highlight bash %}
  net-mail/dovecot USE="bzip2 ipv6 managesieve mysql pam sieve ssl tcpd zlib"
{% endhighlight bash %}

## Configuration

All configuration files are located at `/etc/dovecot/`.

### /etc/dovecot/dovecot.conf
{% highlight bash %}
protocols = imap lmtp sieve
{% endhighlight bash %}

### /etc/dovecot/conf.d/10-ssl.conf
{% highlight bash %}
# SSL/TLS support: yes, no, required. <doc/wiki/SSL.txt>
ssl = required

# PEM encoded X.509 SSL/TLS certificate and private key. They're opened before
# dropping root privileges, so keep the key file unreadable by anyone but
# root. Included doc/mkcert.sh can be used to easily generate self-signed
# certificate, just make sure to update the domains in dovecot-openssl.cnf
ssl_cert = /etc/letsencrypt/live/YOUR.MAIL.DOMAIN/fullchain.pem
ssl_key  = /etc/letsencrypt/live/YOUR.MAIL.DOMAIN/privkey.pem

# SSL ciphers to use
# ###############
# Added by Gentoo
# You are encouraged to change the cipher list to
#ssl_cipher_list = DEFAULT:!EXPORT:!LOW:!MEDIUM:!MD5
# if you are not required to support legacy mail clients.
# ###############
ssl_cipher_list = ALL:!LOW:!SSLv2:!EXP:!aNULL
{% endhighlight bash %}

### /etc/dovecot/conf.d/10-mail.conf

If you want maildirs to use hierarchical directories, such as:
* Maildir/folder/
* Maildir/folder/subfolder/ 
we have to add `LAYOUT=fs`
{% highlight bash %}
mail_home = /home/vmail/%d/%n
mail_location = maildir:~/Maildir:LAYOUT=fs
{% endhighlight bash %}

### /etc/dovecot/conf.d/10-master.conf
{% highlight bash %}
service imap-login {
  inet_listener imap {
    port = 143
  }
  inet_listener imaps {
    #port = 993
    #ssl = yes
  }

  # Number of connections to handle before starting a new process. Typically
  # the only useful values are 0 (unlimited) or 1. 1 is more secure, but 0
  # is faster. <doc/wiki/LoginProcess.txt>
  #service_count = 1

  # Number of processes to always keep waiting for more connections.
  #process_min_avail = 0

  # If you set service_count=0, you probably need to grow this.
  #vsz_limit = $default_vsz_limit
}
{% endhighlight bash %}
