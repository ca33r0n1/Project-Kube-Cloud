
# AuraSide CDN

This is a high level overview of how our Content Delivery Network is utilised in partnership with AuraSide Cloud.



## Authors

- [@ca33r0n1](https://www.github.com/ca33r0n1) - Cheif Technology Officer - Lead Developer of this Project


## Requirements

 - [Tiny File Manager](https://github.com/prasathmani/tinyfilemanager) - File Management Interface
 - [OAuth 2 Proxy](https://github.com/oauth2-proxy/oauth2-proxy) - SSO Authentication Management for Web Server
 - [Nginx](https://www.nginx.com/blog/setting-up-nginx/#install-nginx) - Web Server
 - [Certbot](https://github.com/certbot/certbot) - SSL Management for CDN
 - [PHP](https://www.digitalocean.com/community/tutorials/how-to-install-linux-nginx-mysql-php-lemp-stack-in-ubuntu-16-04) - Required for File Manager. Please use PHP 8.2 or Higher
 - [Redis](https://www.digitalocean.com/community/tutorials/how-to-install-and-secure-redis-on-ubuntu-20-04) - Cookie Cache!


## Tiny File Manager
TinyFileManager is web based file manager and it is a simple, fast and small file manager with a single file, multi-language ready web application for storing, uploading, editing and managing files and folders online via web browser. The Application runs on PHP 5.5+, It allows the creation of multiple users and each user can have its own directory and a build-in support for managing text files with cloud9 IDE and it supports syntax highlighting for over 150+ languages and over 35+ themes.

#### Running Configuration
The main changes to the config we have made is disabling authentication. This is due to us using OAuth2 Proxy to help protect our files.
```
<?php

/*
#################################################################################################################
This is an OPTIONAL configuration file. rename this file into config.php to use this configuration 
The role of this file is to make updating of "tinyfilemanager.php" easier.
So you can:
-Feel free to remove completely this file and configure "tinyfilemanager.php" as a single file application.
or
-Put inside this file all the static configuration you want and forgot to configure "tinyfilemanager.php".
#################################################################################################################
*/

// Auth with login/password
// set true/false to enable/disable it
// Is independent from IP white- and blacklisting
$use_auth = false;

// Login user name and password
// Users: array('Username' => 'Password', 'Username2' => 'Password2', ...)
// Generate secure password hash - https://tinyfilemanager.github.io/docs/pwd.html
$auth_users = array(
    'admin' => '$2y$10$/K.hjNr84lLNDt8fTXjoI.DBp6PpeyoJ.mGwrrLuCZfAwfSAGqhOW', //admin@123
    'user' => '$2y$10$Fg6Dz8oH9fPoZ2jJan5tZuv6Z4Kp7avtQ9bDfrdRntXtPeiMAZyGO' //12345
);

// Readonly users
// e.g. array('users', 'guest', ...)
$readonly_users = array(
    'user'
);

// Enable highlight.js (https://highlightjs.org/) on view's page
$use_highlightjs = true;

// highlight.js style
// for dark theme use 'ir-black'
$highlightjs_style = 'vs';

// Enable ace.js (https://ace.c9.io/) on view's page
$edit_files = true;

// Default timezone for date() and time()
// Doc - http://php.net/manual/en/timezones.php
$default_timezone = 'Etc/UTC'; // UTC

// Root path for file manager
// use absolute path of directory i.e: '/var/www/folder' or $_SERVER['DOCUMENT_ROOT'].'/folder'
$root_path = $_SERVER['DOCUMENT_ROOT'];

// Root url for links in file manager.Relative to $http_host. Variants: '', 'path/to/subfolder'
// Will not working if $root_path will be outside of server document root
$root_url = '';

// Server hostname. Can set manually if wrong
$http_host = $_SERVER['HTTP_HOST'];

// user specific directories
// array('Username' => 'Directory path', 'Username2' => 'Directory path', ...)
$directories_users = array();

// input encoding for iconv
$iconv_input_encoding = 'UTF-8';

// date() format for file modification date
// Doc - https://www.php.net/manual/en/datetime.format.php
$datetime_format = 'd.m.y H:i:s';

// Allowed file extensions for create and rename files
// e.g. 'txt,html,css,js'
$allowed_file_extensions = '';

// Allowed file extensions for upload files
// e.g. 'gif,png,jpg,html,txt'
$allowed_upload_extensions = '';

// Favicon path. This can be either a full url to an .PNG image, or a path based on the document root.
// full path, e.g http://example.com/favicon.png
// local path, e.g images/icons/favicon.png
$favicon_path = '';

// Files and folders to excluded from listing
// e.g. array('myfile.html', 'personal-folder', '*.php', ...)
$exclude_items = array('');

// Online office Docs Viewer
// Availabe rules are 'google', 'microsoft' or false
// google => View documents using Google Docs Viewer
// microsoft => View documents using Microsoft Web Apps Viewer
// false => disable online doc viewer
$online_viewer = 'google';

// Sticky Nav bar
// true => enable sticky header
// false => disable sticky header
$sticky_navbar = true;


// max upload file size
$max_upload_size_bytes = 5000;

// Possible rules are 'OFF', 'AND' or 'OR'
// OFF => Don't check connection IP, defaults to OFF
// AND => Connection must be on the whitelist, and not on the blacklist
// OR => Connection must be on the whitelist, or not on the blacklist
$ip_ruleset = 'OFF';

// Should users be notified of their block?
$ip_silent = true;

// IP-addresses, both ipv4 and ipv6
$ip_whitelist = array(
    '127.0.0.1',    // local ipv4
    '::1'           // local ipv6
);

// IP-addresses, both ipv4 and ipv6
$ip_blacklist = array(
    '0.0.0.0',      // non-routable meta ipv4
    '::'            // non-routable meta ipv6
);

?>
```
## OAuth2 Proxy

Helpful Authention Manager used to protect internal files.

Further documentation can be found [here](https://oauth2-proxy.github.io/oauth2-proxy/docs/).
#### Example Configuration
The current running Configuration is as follows.
```
## OAuth2 Proxy Config File
## https://github.com/oauth2-proxy/oauth2-proxy

## <addr>:<port> to listen on for HTTP/HTTPS clients
 http_address = "127.0.0.1:4180"
 https_address = "127.0.0.1:443"

## Are we running behind a reverse proxy? Will not accept headers like X-Real-Ip unless this is set.
 reverse_proxy = true

## TLS Settings
# tls_cert_file = "/etc/letsencrypt/live/cdn.auraside.com/cert.pem"
# tls_key_file = "/etc/letsencrypt/live/cdn.auraside.com/privkey.pem"

## the OAuth Redirect URL.
# defaults to the "https://" + requested host header + "/oauth2/callback"
# redirect_url = "https://internalapp.yourcompany.com/oauth2/callback"

## the http url(s) of the upstream endpoint. If multiple, routing is based on path
# upstreams = [
#     "http://127.0.0.1:8080/"
# ]

## Logging configuration
logging_filename = "/var/log/oauth2-proxy/CDN-Auth.log"
logging_max_size = 100
logging_max_age = 7
logging_local_time = true
logging_compress = false
standard_logging = true
standard_logging_format = "[{{.Timestamp}}] [{{.File}}] {{.Message}}"
request_logging = true
request_logging_format = "{{.Client}} - {{.Username}} [{{.Timestamp}}] {{.Host}} {{.RequestMethod}} {{.Upstream}} {{.RequestURI}} {{.Protocol}} {{.UserAgent}} {{.StatusCode}} {{.ResponseSize}} {{.RequestDuration}}"
auth_logging = true
auth_logging_format = "{{.Client}} - {{.Username}} [{{.Timestamp}}] [{{.Status}}] {{.Message}}"

## pass HTTP Basic Auth, X-Forwarded-User and X-Forwarded-Email information to upstream
 pass_basic_auth = true
 pass_user_headers = true
## pass the request Host Header to upstream
## when disabled the upstream Host is used as the Host Header
 pass_host_header = true

## Email Domains to allow authentication for (this authorizes any email on this domain)
## for more granular authorization use `authenticated_emails_file`
## To authorize any email addresses use "*"
 email_domains = [
     "auraside.com",
     ".mpl.gg",
     ".hone.gg",
     ".mantle.gg"
 ]
 

## The OAuth Client ID, Secret
 provider="azure"
 client_id="60eead9e-05b4-46d8-92a2-3f0352688d65"
 client_secret="###REDACTED###"
 oidc_issuer_url="https://sts.windows.net/2981065c-3b97-4127-8631-e88960b7dfac/"
 azure_tenant="2981065c-3b97-4127-8631-e88960b7dfac"
 
## Pass OAuth Access token to upstream via "X-Forwarded-Access-Token"
 pass_access_token = false

## Authenticated Email Addresses File (one email per line)
# authenticated_emails_file = ""

## Htpasswd File (optional)
## Additionally authenticate against a htpasswd file. Entries must be created with "htpasswd -B" for bcrypt encryption
## enabling exposes a username/login signin form
# htpasswd_file = ""

## bypass authentication for requests that match the method & path. Format: method=path_regex OR path_regex alone for all methods
# skip_auth_routes = [
#   "GET=^/probe",
#   "^/metrics"
# ]

## Templates
## optional directory with custom sign_in.html and error.html
custom_templates_dir = "/var/www/oauth/"

footer="-"

## skip SSL checking for HTTPS requests
# ssl_insecure_skip_verify = false


## Cookie Settings
## Name     - the cookie name
## Secret   - the seed string for secure cookies; should be 16, 24, or 32 bytes
##            for use with an AES cipher when cookie_refresh or pass_access_token
##            is set
## Domain   - (optional) cookie domain to force cookies to (ie: .yourcompany.com)
## Expire   - (duration) expire timeframe for cookie
## Refresh  - (duration) refresh the cookie when duration has elapsed after cookie was initially set.
##            Should be less than cookie_expire; set to 0 to disable.
##            On refresh, OAuth token is re-validated.
##            (ie: 1h means tokens are refreshed on request 1hr+ after it was set)
## Secure   - secure cookies are only sent by the browser of a HTTPS connection (recommended)
## HttpOnly - httponly cookies are not readable by javascript (recommended)
 cookie_name = "_auraside_auth"
 cookie_secret = "VFpzaGdZbmJtRlR1bUFNRXRvbW1FMXhi"
# cookie_domains = "auraside.com"
 cookie_expire = "24h"
 cookie_refresh = "1h"
 cookie_secure = true
 cookie_httponly = true
 session_store_type= "redis"
 redis_connection_url="redis://localhost:6379"
 ```

## Nginx

#### Configuration

This is the most important part of the CDN and how it works. 
We can manipulate the configuration to allow certain IP's and paths to bypass the OAuth2 Authentication.

To whitelist a new IP all we need to do is look for the `satisfy any;` part in the configuration.
Once you have found that create a new line under it and add the following `allow <ip address to whitelist>/32`. We always have to specify a CIRD as this restricts access to that set IP. 99.9% of the time you will only need to use /32 to whitelist on address however if you do have a collection of IP's that are in the same subnet you can also do /29 or /24.

Set paths can also be allowed passed the OAuth2 Proxy by adding another location.
Please use this template to paste into the configuration.
```
  location /<path>/ {
    allow all;
  }
``` 
#### Running Configuration
```
server {
	listen 80 default_server;
	listen [::]:80 default_server;

	root /var/www/html;

	index index.html index.htm index.nginx-debian.html;

	server_name _;
 

location / {
        proxy_pass http://127.0.0.1:4180;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Scheme $scheme;
        proxy_connect_timeout 1;
        proxy_send_timeout 30;
        proxy_read_timeout 30;
    }

	location ~ /\.ht {
		deny all;
	}
}

server {
	listen 80 ;
	listen [::]:80 ;

	root /var/www/html;
  #index index.html index.htm index.nginx-debian.html;
  server_name cdn.auraside.com; # managed by Certbot

	location ~ /\.ht {
		deny all;
	}


  listen [::]:443 ssl ipv6only=on; # managed by Certbot
  listen 443 ssl; # managed by Certbot
  ssl_certificate "/etc/ssl/ssl/cdn.auraside.com.crt"; # managed by Certbot
  ssl_certificate_key "/etc/ssl/ssl/cdn_auraside_com.pem"; # managed by Certbot
  include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
  ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot


  satisfy any;
  allow 192.99.13.216/32;
  allow 192.99.34.163/32;
  allow 147.135.4.196/32;
  allow 192.99.15.28/32;
  allow 192.95.31.55/32;
  allow 192.99.160.135/32;
  allow 77.100.56.252/32;
  allow 173.91.128.199/32;



  
  location /oauth2/ {
  proxy_pass       http://127.0.0.1:4180;
  proxy_set_header Host                    $host;
  proxy_set_header X-Real-IP               $remote_addr;
  proxy_set_header X-Scheme                $scheme;
  proxy_set_header X-Auth-Request-Redirect $request_uri;
  # or, if you are handling multiple domains:
  # proxy_set_header X-Auth-Request-Redirect $scheme://$host$request_uri;
  }
  
  location = /oauth2/auth {
    proxy_pass       http://127.0.0.1:4180;
    proxy_set_header Host             $host;
    proxy_set_header X-Real-IP        $remote_addr;
    proxy_set_header X-Scheme         $scheme;
    # nginx auth_request includes headers but not body
    proxy_set_header Content-Length   "";
    proxy_pass_request_body           off;
  }
  
  location /img/ {
    allow all;
  }
  
    location /hone/ {
    allow all;
  }
  
  location /public/ {
    allow all;
  }

  location /iso/ {
    allow all;
  }
  


  location / {
    #Bypass OAuth
    satisfy any;
    allow 192.99.13.216/32;
    allow 192.99.34.163/32;
    allow 147.135.4.196/32;
    allow 192.99.15.28/32;
    allow 192.95.31.55/32;
    allow 192.99.160.135/32;
    allow 77.100.56.252/32;
    allow 173.91.128.199/32;
    allow 62.210.200.32/32;
    
    auth_request /oauth2/auth;
    error_page 401 = /oauth2/sign_in;
    
    index index.php index.html index.htm;

    # pass information via X-User and X-Email headers to backend,
    # requires running with --set-xauthrequest flag
    auth_request_set $user   $upstream_http_x_auth_request_user;
    auth_request_set $email  $upstream_http_x_auth_request_email;
    proxy_set_header X-User  $user;
    proxy_set_header X-Email $email;

    # if you enabled --pass-access-token, this will pass the token to the backend
    auth_request_set $token  $upstream_http_x_auth_request_access_token;
    proxy_set_header X-Access-Token $token;

    # if you enabled --cookie-refresh, this is needed for it to work with auth_request
    auth_request_set $auth_cookie $upstream_http_set_cookie;
    add_header Set-Cookie $auth_cookie;

    # When using the --set-authorization-header flag, some provider's cookies can exceed the 4kb
    # limit and so the OAuth2 Proxy splits these into multiple parts.
    # Nginx normally only copies the first `Set-Cookie` header from the auth_request to the response,
    # so if your cookies are larger than 4kb, you will need to extract additional cookies manually.
    auth_request_set $auth_cookie_name_upstream_1 $upstream_cookie_auth_cookie_name_1;

    # Extract the Cookie attributes from the first Set-Cookie header and append them
    # to the second part ($upstream_cookie_* variables only contain the raw cookie content)
    if ($auth_cookie ~* "(; .*)") {
        set $auth_cookie_name_0 $auth_cookie;
        set $auth_cookie_name_1 "auth_cookie_name_1=$auth_cookie_name_upstream_1$1";
    }

    # Send both Set-Cookie headers now if there was a second part
    if ($auth_cookie_name_upstream_1) {
        add_header Set-Cookie $auth_cookie_name_0;
        add_header Set-Cookie $auth_cookie_name_1;
    }
    
    try_files $uri $uri/ =404;
  }
  
  location ~ \.php$ {
    include snippets/fastcgi-php.conf;
    fastcgi_pass unix:/run/php/php-fpm.sock;
  }
  
 	location ~ /\.ht {
		deny all;
	}
}
```
## Directory Layout

We have tried to keep the CDN some what tidy and in a conventional naming method.
Our main approach is to have to have a server group root folder that will then contain all the relevant plugins, configurations and install scripts for that server.

- Webserver Root
    - Server Type
        - plugins
        - config files
        - install.sh
    - Hone
        - Hone files
    - public
        - All files are available to everyone so be careful what is inside this folder.
## Game Server Script

This is a script that [@ca33r0n1](https://www.github.com/ca33r0n1) develeloped to dynamically deploy game servers from an automated install script. 

#### Script Template
```
#!/bin/sh
echo "Author: Cameron <ca33r0n1@auraside.com> - 21/12/2021"
echo "Rev. 1.3"
echo "Starting Game Install"

#This allows us to call the download header multiple times without having to rewrite this entire thing.
jenkinsdownload(){
    wget --no-check-certificate \
  --method GET \
  --timeout=0 \
  --header "Authorization: Basic $1" \
  -O "$3" \
   "$2"
}

#Download Spigot
jenkinsdownload "$1" "https://jenkins.auraside.com/job/" "server.jar"

#Download Template Files i.e Server Properties
wget --no-check-certificate https://cdn.auraside.com/{Server Type}/world.zip
unzip world.zip
rm -f world.zip
wget --no-check-certificate --quiet "https://cdn.auraside.com/{Server Type}/server.properties"
wget --no-check-certificate --quiet "https://cdn.auraside.com/{Server Type}/ops.json"

mkdir plugins
cd plugins

#Download Plugins Here
wget --no-check-certificate --quiet "https://cdn.auraside.com/squidgame/plugins/Vault.jar"

cd ../

#Download Configs Here
wget --no-check-certificate --quiet "https://cdn.auraside.com/{Server Type}/plugins/plugin.zip"
unzip plugin.zip -d plugins
rm -f plugin.zip

#Final Config
echo 'eula=true' > eula.txt

#Start Server Command
/usr/lib/jvm/java-8-openjdk/bin/java -Dlog4j2.formatMsgNoLookups=true -Xmx4G -Xms4G -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true -jar server.jar nogui
```

The `jenkinsdownload` function will allow you to specify a job's artifact and output it to your working directory. More info in the [README.MD](https://github.com/auraside/AuraCloud#how-do-i-generate-a-jenkins-key).

This script can be talored to support any amout of plugins and configurations. This will allow you to use the CDN as a central repository for the game server and allow mass deploying of the exact same thing.

