#!/bin/bash
#--------------info-------------#
#londyoffice@163.com
#2013-06-02
#-------------------------------#

#�����Ļ���������Ϣ
NGINX="nginx-xxx"
PCRE="pcre-xxx"

#����û��Ͱ�װ�����������
apt-get update
apt-get install openssl libssl-dev build-essential -y

#�������
cd /root

if [ ! -f "$NGINX.tar.gz" ];then
        wget http://xxx/$NGINX.tar.gz
fi

if [ ! -f "$PCRE.tar.gz" ];then
        wget http://xxx/$PCRE.tar.gz
fi


#��װpcre
cd /root
tar xzvf ${PCRE}.tar.gz
cd $PCRE
./configure
make && make install
ln -s /usr/local/lib/libpcre.so.0.0.1 /lib/libpcre.so.0

#��װnginx
useradd www-data -s /bin/nologin
cd ..
tar xzvf ${NGINX}.tar.gz
cd $NGINX
./configure --user=www-data --group=www-data --prefix=/usr/local/nginx --with-http_stub_status_module --with-http_ssl_module
make && make install

#��������Ŀ¼
mkdir -p /data/log/nginx/
mkdir -p /usr/local/nginx/conf/vhost

#��������ģ��
cd /root
cp nginx.conf /usr/local/nginx/conf/
cp default.conf /usr/local/nginx/conf/vhost

rm -rf  /root/$NGINX
rm -rf  /root/$PCRE