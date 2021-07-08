#/bin/bash


 # build package install

yum install -y gcc openssl-devel bzip2-devel libffi-devel

 # download python and install python3.8.3

curl -O https://www.python.org/ftp/python/3.8.3/Python-3.8.3.tgz
tar -xzf Python-3.8.3.tgz
cd Python-3.8.3
./configure --enable-optimizations
make altinstall

