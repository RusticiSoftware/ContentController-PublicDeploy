#!/bin/sh

cd /opt/mod_jk/tomcat-connectors-1.2.41-src/native

./configure --with-apxs=/usr/bin/apxs
make
libtool --finish /usr/lib64/httpd/modules
make install