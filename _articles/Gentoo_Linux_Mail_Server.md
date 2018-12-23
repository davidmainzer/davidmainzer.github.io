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
Since I have a Gentoo Linux running I want to explain within this article how you can use this guide for Gentoo Linux. 
Therefore, please read this guide first to get an overview of all the stuff.

# Requirements 

You have to had a are running a Gentoo Linux with working internet connection and you must be `root`.

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

Start database and add them to your autostart:
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
	CREATE TABLE `tlspolicies` (
    `id` int unsigned NOT NULL AUTO_INCREMENT,
    `domain` varchar(255) NOT NULL,
    `policy` enum('none', 'may', 'encrypt', 'dane', 'dane-only', 'fingerprint', 'verify', 'secure') NOT NULL,
    `params` varchar(255),
    PRIMARY KEY (`id`),
    UNIQUE KEY (`domain`)
	);
{% endhighlight bash %}

# Vmail User

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
Therefore, we have to add `LAYOUT=fs`:

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


### /etc/dovecot/conf.d/20-managesieve.conf 
{% highlight bash %}
service managesieve-login {
    inet_listener sieve {
        port = 4190
    }
}
{% endhighlight bash %}


### /etc/dovecot/conf.d/20-imap.conf
{% highlight bash %}
protocol imap {
  # Space separated list of plugins to load (default is global mail_plugins).
  mail_plugins = $mail_plugins quota imap_quota imap_sieve

  # Maximum number of IMAP connections allowed for a user from each IP address.
  # NOTE: The username is compared case-sensitively.
  mail_max_userip_connections = 20
  imap_idle_notify_interval = 29 mins
} 
{% endhighlight bash %}


### /etc/dovecot/conf.d/20-lmtp.conf
{% highlight bash %}
protocol lmtp {
  # Space separated list of plugins to load (default is global mail_plugins).
  postmaster_address = postmaster@YOUR.MAIL.DOMAIN
  mail_plugins = $mail_plugins sieve
}
{% endhighlight bash %}


### /etc/dovecot/conf.d/auth-sql.conf
{% highlight bash %}
# Authentication for SQL users. Included from 10-auth.conf.
# 
# <doc/wiki/AuthDatabase.SQL.txt>

passdb {
  driver = sql

  # Path for SQL configuration file, see example-config/dovecot-sql.conf.ext
  args = /etc/dovecot/dovecot-sql.conf
}

# "prefetch" user database means that the passdb already provided the
# needed information and there's no need to do a separate userdb lookup.
# <doc/wiki/UserDatabase.Prefetch.txt>
#userdb {
#  driver = prefetch
#}

userdb {
  driver = sql
  args = /etc/dovecot/dovecot-sql.conf
}
{% endhighlight bash %}


### /etc/dovecot/conf.d/15-mailboxes.conf
{% highlight bash %}
namespace inbox {
  inbox = yes

  # These mailboxes are widely used and could perhaps be created automatically:
  mailbox Drafts {
    auto = subscribe
    special_use = \Drafts
  }
  mailbox Junk {
    auto = subscribe
    special_use = \Junk
  }
  mailbox Trash {
    auto = subscribe
    special_use = \Trash
  }

  # For \Sent mailboxes there are two widely used names. We'll mark both of
  # them as \Sent. User typically deletes one of them if duplicates are created.
  mailbox Sent {
    auto = subscribe
    special_use = \Sent
  }
  mailbox "Sent Messages" {
    special_use = \Sent
  }
}

{% endhighlight bash %}


### /etc/dovecot/conf.d/90-sieve.conf
{% highlight bash %}
  ###
  ### Spam learning
  ###
  # From elsewhere to Spam folder
  imapsieve_mailbox1_name = Spam
  imapsieve_mailbox1_causes = COPY
  imapsieve_mailbox1_before = file:/var/vmail/sieve/global/learn-spam.sieve

  # From Spam folder to elsewhere
  imapsieve_mailbox2_name = *
  imapsieve_mailbox2_from = Spam
  imapsieve_mailbox2_causes = COPY
  imapsieve_mailbox2_before = file:/var/vmail/sieve/global/learn-ham.sieve

  sieve_pipe_bin_dir = /usr/bin
  sieve_global_extensions = +vnd.dovecot.pipe

  quota = maildir:User quota
  quota_exceeded_message = Benutzer %u hat das Speichervolumen überschritten. / User %u has exhausted allowed storage space.
{% endhighlight bash %}


### /etc/dovecot/dovecot-sql.conf
{% highlight bash %}
driver=mysql
connect = "host=127.0.0.1 dbname=vmail user=vmail password=vmaildbpass"
default_pass_scheme = SHA512-CRYPT

password_query = SELECT username AS user, domain, password FROM accounts WHERE username = '%n' AND domain = '%d' and enabled = true;
user_query = SELECT concat('*:storage=', quota, 'M') AS quota_rule FROM accounts WHERE username = '%n' AND domain = '%d' AND sendonly = false;
iterate_query = SELECT username, domain FROM accounts where sendonly = false;
{% endhighlight bash %}

Since `dovecot-sql.conf`contains sensitive data we secure the file:
{% highlight bash %}
chmod 440 dovecot-sql.conf
{% endhighlight bash %}

## Global Sieve Filter Script for Spam Detection 

Create the file `/home/vmail/sieve/global/spam-global.sieve`:
{% highlight bash %}
require "fileinto";

if header :contains "X-Spam-Flag" "YES" {
    fileinto "Spam";
}

if header :is "X-Spam" "Yes" {
    fileinto "Spam";
}
{% endhighlight bash %}
This script will move all emails taged with Spam-Flag header into `Spam` the folder.

### Scripts for Spam Improvement (Rspamd)

#### /home/vmail/sieve/global/learn-spam.sieve
{% highlight bash %}
require ["vnd.dovecot.pipe", "copy", "imapsieve"];
pipe :copy "rspamc" ["learn_spam"];
{% endhighlight bash %}

#### /home/vmail/sieve/global/learn-ham.sieve
{% highlight bash %}
require ["vnd.dovecot.pipe", "copy", "imapsieve"];
pipe :copy "rspamc" ["learn_ham"];
{% endhighlight bash %}



# Postfix - Installation and Configuration

{% highlight bash %}
emerge -av mail-mta/postfix
{% endhighlight bash %}

Ensure you have the use flag `mysql` enabled.







##
## Mail-Queue Einstellungen
##

maximal_queue_lifetime = 1h
bounce_queue_lifetime = 1h
maximal_backoff_time = 15m
minimal_backoff_time = 5m
queue_run_delay = 5m


##
## TLS Einstellungen
###

tls_preempt_cipherlist = yes
tls_ssl_options = NO_COMPRESSION
tls_high_cipherlist = EDH+CAMELLIA:EDH+aRSA:EECDH+aRSA+AESGCM:EECDH+aRSA+SHA256:EECDH:+CAMELLIA128:+AES128:+SSLv3:!aNULL:!eNULL:!LOW:!3DES:!MD5:!EXP:!PSK:!DSS:!RC4:!SEED:!IDEA:!ECDSA:kEDH:CAMELLIA128-SHA:AES128-SHA

### Ausgehende SMTP-Verbindungen (Postfix als Sender)

smtp_tls_security_level = dane
smtp_dns_support_level = dnssec
smtp_tls_policy_maps = mysql:/etc/postfix/sql/tls-policy.cf
smtp_tls_session_cache_database = btree:${data_directory}/smtp_scache
smtp_tls_protocols = !SSLv2, !SSLv3
smtp_tls_ciphers = high
smtp_tls_CAfile = /etc/ssl/certs/ca-certificates.crt


### Eingehende SMTP-Verbindungen

smtpd_tls_security_level = may
smtpd_tls_protocols = !SSLv2, !SSLv3
smtpd_tls_ciphers = high
smtpd_tls_session_cache_database = btree:${data_directory}/smtpd_scache

smtpd_tls_cert_file=/etc/letsencrypt/live/mail.mysystems.tld/fullchain.pem
smtpd_tls_key_file=/etc/letsencrypt/live/mail.mysystems.tld/privkey.pem


##
## Lokale Mailzustellung an Dovecot
##

virtual_transport = lmtp:unix:private/dovecot-lmtp


##
## Spamfilter und DKIM-Signaturen via Rspamd
##

smtpd_milters = inet:localhost:11332
non_smtpd_milters = inet:localhost:11332
milter_protocol = 6
milter_mail_macros =  i {mail_addr} {client_addr} {client_name} {auth_authen}
milter_default_action = accept



##
## Server Restrictions für Clients, Empfänger und Relaying
## (im Bezug auf S2S-Verbindungen. Mailclient-Verbindungen werden in master.cf im Submission-Bereich konfiguriert)
##

### Bedingungen, damit Postfix als Relay arbeitet (für Clients)
smtpd_relay_restrictions =      reject_non_fqdn_recipient
                                reject_unknown_recipient_domain
                                permit_mynetworks
                                reject_unauth_destination


### Bedingungen, damit Postfix ankommende E-Mails als Empfängerserver entgegennimmt (zusätzlich zu relay-Bedingungen)
### check_recipient_access prüft, ob ein account sendonly ist
smtpd_recipient_restrictions = check_recipient_access mysql:/etc/postfix/sql/recipient-access.cf


### Bedingungen, die SMTP-Clients erfüllen müssen (sendende Server)
smtpd_client_restrictions =     permit_mynetworks
                                check_client_access hash:/etc/postfix/without_ptr
                                reject_unknown_client_hostname


### Wenn fremde Server eine Verbindung herstellen, müssen sie einen gültigen Hostnamen im HELO haben.
smtpd_helo_required = yes
smtpd_helo_restrictions =   permit_mynetworks
                            reject_invalid_helo_hostname
                            reject_non_fqdn_helo_hostname
                            reject_unknown_helo_hostname

# Clients blockieren, wenn sie versuchen zu früh zu senden
smtpd_data_restrictions = reject_unauth_pipelining


##
## Restrictions für MUAs (Mail user agents)
##

mua_relay_restrictions = reject_non_fqdn_recipient,reject_unknown_recipient_domain,permit_mynetworks,permit_sasl_authenticated,reject
mua_sender_restrictions = permit_mynetworks,reject_non_fqdn_sender,reject_sender_login_mismatch,permit_sasl_authenticated,reject
mua_client_restrictions = permit_mynetworks,permit_sasl_authenticated,reject


##
## Postscreen Filter
##

### Postscreen Whitelist / Blocklist
postscreen_access_list =        permit_mynetworks
                                cidr:/etc/postfix/postscreen_access
postscreen_blacklist_action = drop


# Verbindungen beenden, wenn der fremde Server es zu eilig hat
postscreen_greet_action = drop


### DNS blocklists
postscreen_dnsbl_threshold = 2
postscreen_dnsbl_sites =    ix.dnsbl.manitu.net*2
                            zen.spamhaus.org*2
postscreen_dnsbl_action = drop


##
## MySQL Abfragen
##

virtual_alias_maps = mysql:/etc/postfix/sql/aliases.cf
virtual_mailbox_maps = mysql:/etc/postfix/sql/accounts.cf
virtual_mailbox_domains = mysql:/etc/postfix/sql/domains.cf
local_recipient_maps = $virtual_mailbox_maps


##
## Sonstiges
##

### Maximale Größe der gesamten Mailbox (soll von Dovecot festgelegt werden, 0 = unbegrenzt)
mailbox_size_limit = 0

### Maximale Größe eingehender E-Mails in Bytes (50 MB)
message_size_limit = 52428800

### Keine System-Benachrichtigung für Benutzer bei neuer E-Mail
biff = no

### Nutzer müssen immer volle E-Mail Adresse angeben - nicht nur Hostname
append_dot_mydomain = no

### Trenn-Zeichen für "Address Tagging"
recipient_delimiter = +







