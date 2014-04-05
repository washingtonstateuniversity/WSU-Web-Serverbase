#!/bin/bash

resulting=""
name="nginx-compile"

#if [ -z "$1" ]; then
#    resulting="Faild to provide a version of nginx to use"
#    echo "name=$name result=False changed=False comment=$resulting"
#    exit
#fi

nginxVersion="$1"

pagespeedVer="1.7.30.4"

touch /failed_nginx_compile

#set the compiler to be quite
#then return message only it it's a fail
ini(){
    cd /src
    #nginxVersion="1.5.8" # set the value here from nginx website
    wget -N http://nginx.org/download/nginx-$nginxVersion.tar.gz
    tar -xzf nginx-$nginxVersion.tar.gz
    ln -sf nginx-$nginxVersion nginx
    
    cd /src/nginx

    # Fetch openssl
    wget -N http://www.openssl.org/source/openssl-1.0.1e.tar.gz
    tar -xzf openssl-1.0.1e.tar.gz
    
    #get page speed
    wget -N -O "ngx_pagespeed-$pagespeedVer-beta.zip" "https://github.com/pagespeed/ngx_pagespeed/archive/v$pagespeedVer-beta.zip"
    unzip -o "ngx_pagespeed-$pagespeedVer-beta.zip" # or unzip v1.7.30.2-beta
    cd "ngx_pagespeed-$pagespeedVer-beta/"
    wget -N https://dl.google.com/dl/page-speed/psol/$pagespeedVer.tar.gz
    tar -xzvf $pagespeedVer.tar.gz # expands to psol/
	
    #mkdir /tmp/nginx-modules
    #cd /tmp/nginx-modules
    #wget https://github.com/agentzh/headers-more-nginx-module/archive/v0.19.tar.gz
    #tar -xzvf v0.19.tar.gz 
	
    cd /src/nginx

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
--with-http_gunzip_module \
--with-http_gzip_static_module \
--with-http_stub_status_module \
--with-http_sub_module \
--with-http_spdy_module \
--with-http_ssl_module \
--with-openssl=/tmp/openssl-1.0.1e \
--with-sha1=/usr/include/openssl \
--with-md5=/usr/include/openssl \
--with-pcre \
--with-ipv6 \
--with-file-aio \
--with-http_realip_module \
--without-http_scgi_module \
--without-http_uwsgi_module \
--add-module="/src/nginx/ngx_pagespeed-$pagespeedVer-beta"
    make
    make install
}

OUTPUT=$(ini)
$OUTPUT 2>&1 | grep -qi "complete"

if [ $? -eq 1 ]; then
	resulting="Just finished installing nginx $nginxVersion"
    echo "name=$name result=True changed=True comment='$resulting'"
    #echo "{'name': 'nginx-compile', 'changes': {}, 'result': True, 'comment': ''}"
else
	resulting="Failed installing nginx $nginxVersion, check /failed_nginx_compile for details"
	$OUTPUT >> /failed_nginx_compile
    echo "name=$name result=False changed=False comment='$resulting'"
    #echo "{'name': 'nginx-compile', 'changes': {}, 'result': False, 'comment': ''}"
fi
