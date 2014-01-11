#!/bin/bash

resulting=""
name="nginx-compile"

#set the compiler to be quite
#then return message only it it's a fail
ini(){
    cd /src
    
    nginxVersion="1.5.8" # set the value here from nginx website
    wget -N http://nginx.org/download/nginx-$nginxVersion.tar.gz 2>/dev/null
    tar -xzf nginx-$nginxVersion.tar.gz >/dev/null
    ln -sf nginx-$nginxVersion nginx
    
    cd /src/nginx

    # Fetch openssl
    wget -N http://www.openssl.org/source/openssl-1.0.1e.tar.gz 2>/dev/null
    tar -xzf openssl-1.0.1e.tar.gz >/dev/null
    

    #mkdir /tmp/nginx-modules
    #cd /tmp/nginx-modules
    #wget https://github.com/agentzh/headers-more-nginx-module/archive/v0.19.tar.gz
    #tar -xzvf v0.19.tar.gz 

    
    ./configure \
--prefix=/etc/nginx \
--sbin-path=/usr/sbin/nginx \
--conf-path=/etc/nginx/nginx.conf \
--pid-path=/var/run/nginx.pid \
--lock-path=/var/run/nginx.lock \
--error-log-path=/var/log/nginx/error.log \
--http-log-path=/var/log/nginx/access.log \
--http-proxy-temp-path=/var/lib/nginx/proxy \
--with-http_auth_request_module \
--with-http_sub_module \
--with-http_mp4_module \
--with-http_addition_module \
--with-http_dav_module \
--with-http_gzip_static_module \
--with-http_stub_status_module \
--with-http_ssl_module \
--with-http_sub_module \
--with-http_xslt_module \
--with-http_spdy_module \
--with-ipv6 \
--with-sha1=/usr/include/openssl \
--with-md5=/usr/include/openssl \
--with-pcre \
--with-file-aio \
--with-http_realip_module \
--without-http_scgi_module \
--without-http_uwsgi_module \
--with-openssl='openssl-1.0.1e' \ # wget http://www.openssl.org/source/openssl-1.0.1e.tar.gz
--with-ipv6 >/dev/null
    make >/dev/null
    make install >/dev/null

    return 1 #fix this
}

ini
if [ $? -eq 1 ]; then
    echo "name=$name result=True changed=True comment=$resulting"
    #echo "{'name': 'nginx-compile', 'changes': {}, 'result': True, 'comment': ''}"
else
    echo "name=$name result=False changed=False comment=$resulting"
    #echo "{'name': 'nginx-compile', 'changes': {}, 'result': False, 'comment': ''}"
fi
