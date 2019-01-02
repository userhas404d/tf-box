#!/bin/bash

yum check-update
yum -y update
yum -y upgrade

# install prerequisites
yum install epel-release -y

yum -y install  \
  awscli \
  python-virtualenv \
  apt-transport-https \
  ca-certificates \
  curl \
  software-properties-common \
  python3 \
  git \
  jq \
  unzip

# # install terraform
git clone https://github.com/plus3it/terraform-bootstrap.git
chmod +x terraform-bootstrap/install.sh && ./terraform-bootstrap/install.sh

# #install terrabroker
git clone https://github.com/userhas404d/terragrunt-bootstrap.git
chmod +x terragrunt-bootstrap/install.sh && ./terragrunt-bootstrap/install.sh

export AWS_DEFAULT_REGION=#{ENV['AWS_DEFAULT_REGION']}
export AWS_ACCESS_KEY_ID=#{ENV['AWS_ACCESS_KEY_ID']}
export AWS_SECRET_ACCESS_KEY=#{ENV['AWS_SECRET_ACCESS_KEY']}
