#!/bin/bash

export PATH=/opt/bin:/usr/local/bin:/usr/local/sbin:/usr/contrib/bin:/sbin:/bin:/bin:/usr/bin:/usr/sbin

# add optional items to the path
for bindir in $HOME/local/bin $HOME/bin; do
    if [ -d $bindir ]; then
        PATH=$PATH:${bindir}
    fi
done

yum check-update
yum -y update
yum -y upgrade

# install prerequisites
yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
yum install -y https://centos7.iuscommunity.org/ius-release.rpm 
yum makecache
yum groupinstall -y "Development Tools"

yum install -y \
  awscli \
  python-virtualenv \
  apt-transport-https \
  ca-certificates \
  curl \
  software-properties-common \
  git \
  jq \
  unzip

# install terraform
git clone https://github.com/plus3it/terraform-bootstrap.git
chmod +x terraform-bootstrap/install.sh && ./terraform-bootstrap/install.sh

#install terragrunt
git clone https://github.com/userhas404d/terragrunt-bootstrap.git
chmod +x terragrunt-bootstrap/install.sh && ./terragrunt-bootstrap/install.sh

# install python and pip
PIP_URL=https://bootstrap.pypa.io/get-pip.py
PYPI_URL=https://pypi.org/simple

# Setup terminal support for UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# install python 3.6
yum install -y python36u

# Install pip
curl "$PIP_URL" | python3.6 - --index-url="$PYPI_URL"
# curl "$PIP_URL" | python36 - --index-url="$PYPI_URL"

# Install setup dependencies
pip3 install --index-url="$PYPI_URL" --upgrade pip setuptools

