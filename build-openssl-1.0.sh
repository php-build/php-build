#!/bin/sh -xe

mkdir -p /tmp/openssl-1.0
cd /tmp/openssl-1.0
curl -Ls https://github.com/openssl/openssl/archive/OpenSSL_1_0_2t.tar.gz | tar xzC /tmp/openssl-1.0 --strip-components=1
./Configure --prefix=/usr/local/opt/openssl@1.0 no-ssl2 no-ssl3 no-zlib shared enable-cms darwin64-x86_64-cc enable-ec_nistp_64_gcc_128
make depend
make
sudo make install_sw
