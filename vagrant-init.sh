#!/usr/bin/env bash

sudo su

apt-get -y update
apt-get -y build-dep php5-cli

apt-get -y install git-core
apt-get -y install libmcrypt-dev

git clone https://github.com/sstephenson/bats.git
cd bats
./install.sh /usr/local

exit 0

