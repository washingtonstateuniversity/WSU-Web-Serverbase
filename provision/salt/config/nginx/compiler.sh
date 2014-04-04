#!/bin/bash

resulting=""
name="nginx-compile"

#if [ -z "$1" ]; then
#    resulting="Faild to provide a version of nginx to use"
#    echo "name=$name result=False changed=False comment=$resulting"
#    exit
#fi

nginxVersion="$1"

#set the compiler to be quite
#then return message only it it's a fail
ini(){
    cd /src
    #nginxVersion="1.5.8" # set the value here from nginx website
    wget -N http://nginx.org/download/nginx-$nginxVersion.tar.gz 2>/dev/null
    tar -xzf nginx-$nginxVersion.tar.gz >/dev/null
    ln -sf nginx-$nginxVersion nginx
    
    cd /src/nginx

    # Fetch openssl
    wget -N http://www.openssl.org/source/openssl-1.0.1e.tar.gz 2>/dev/null
    tar -xzf openssl-1.0.1e.tar.gz >/dev/null
    
    #get page speed
    wget -N -O ngx_pagespeed-1.7.30.2-beta.zip https://github.com/pagespeed/ngx_pagespeed/archive/v1.7.30.2-beta.zip 2>/dev/null
    unzip -o ngx_pagespeed-1.7.30.2-beta.zip >/dev/null # or unzip v1.7.30.2-beta
    cd ngx_pagespeed-1.7.30.2-beta/
    wget -N https://dl.google.com/dl/page-speed/psol/1.7.30.2.tar.gz 2>/dev/null
    tar -xzvf 1.7.30.2.tar.gz >/dev/null # expands to psol/
    #mkdir /tmp/nginx-modules
    #cd /tmp/nginx-modules
    #wget https://github.com/agentzh/headers-more-nginx-module/archive/v0.19.tar.gz
    #tar -xzvf v0.19.tar.gz 
    cd /src/nginx

    #just in case
    mkdir -p /var/lib/nginx/proxy
    mkdir -p /var/log/nginx

    ./configure \
--user=www-data \
--group=www-data \
--prefix=/etc/nginx \
--sbin-path=/usr/sbin/nginx \
--conf-path=/etc/nginx/nginx.conf \
--pid-path=/var/run/nginx.pid \
--lock-path=/var/lock/subsys/nginx \
--error-log-path=/var/log/nginx/error.log \
--http-log-path=/var/log/nginx/access.log \
--http-client-body-temp-path=/var/cache/nginx/client_temp \
--http-proxy-temp-path=/var/cache/nginx/proxy_temp \
--http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
--http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
--http-scgi-temp-path=/var/cache/nginx/scgi_temp \
--with-http_auth_request_module \
--with-http_sub_module \
--with-http_mp4_module \
--with-http_flv_module \
--with-http_addition_module \
--with-http_dav_module \
--with-http_gzip_static_module \
--with-http_stub_status_module \
--with-http_sub_module \
--with-http_spdy_module \
--with-http_ssl_module \
--with-sha1=/usr/include/openssl \
--with-md5=/usr/include/openssl \
--with-pcre \
--with-file-aio \
--with-http_realip_module \
--without-http_scgi_module \
--without-http_uwsgi_module \
--add-module=/src/nginx/ngx_pagespeed-1.7.30.2-beta >/dev/null
    make >/dev/null
    make install >/dev/null
    resulting="Just finished installing nginx $nginxVersion"
    return 1 #fix this this should be a grep for 'error' or something also this is backwards as non-0 is false yet it's treated as true
}

ini
if [ $? -eq 1 ]; then
    echo "name=$name result=True changed=True comment='$resulting'"
    #echo "{'name': 'nginx-compile', 'changes': {}, 'result': True, 'comment': ''}"
else
    echo "name=$name result=False changed=False comment='$resulting'"
    #echo "{'name': 'nginx-compile', 'changes': {}, 'result': False, 'comment': ''}"
fi
