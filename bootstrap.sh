#!/bin/bash

export PATH=/opt/bin:/usr/local/bin:/usr/local/sbin:/usr/contrib/bin:/sbin:/bin:/bin:/usr/bin:/usr/sbin

# add optional items to the path
for bindir in $HOME/local/bin $HOME/bin; do
    if [ -d $bindir ]; then
        PATH=$PATH:$${bindir}
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
  ntp \
  ntpdate \
  awscli \
  python-virtualenv \
  apt-transport-https \
  ca-certificates \
  curl \
  software-properties-common \
  git \
  jq \
  unzip

# start and enable ntpd
systemctl start ntpd
systemctl enable ntpd
# set hardare clock to current system time
hwclock  -w 

# install terraform
git clone https://github.com/tfutils/tfenv.git /home/vagrant/.tfenv
/home/vagrant/.tfenv/bin/tfenv install 0.11.14
/home/vagrant/.tfenv/bin/tfenv use 0.11.14

#install terragrunt
git clone https://github.com/userhas404d/terragrunt-bootstrap.git
chmod +x terragrunt-bootstrap/install.sh && ./terragrunt-bootstrap/install.sh

# install python and pip
echo "Installing python"
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
pip3 install pipenv
echo "Python install complete"

# install go
export GOROOT=/home/vagrant/.go
export GOPATH=/home/vagrant/go
curl https://raw.githubusercontent.com/canha/golang-tools-install-script/master/goinstall.sh | bash

"$GOROOT"/bin/go get -u github.com/justjanne/powerline-go

# configure the bash profile
cat <<'EOT' >> /home/vagrant/.bash_profile

# Setup terminal support for UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# update path for tfven
export PATH="$HOME/.tfenv/bin:$PATH"
# update path for go
export GOROOT=/home/vagrant/.go
export PATH=$GOROOT/bin:$PATH
export GOPATH=/home/vagrant/go
export PATH=$GOPATH/bin:$PATH

# AWS environment variables.
export AWS_DEFAULT_REGION=us-east-1
export AWS_ACCESS_KEY_ID="$(aws configure get default.aws_access_key_id)"
export AWS_SECRET_ACCESS_KEY="$(aws configure get default.aws_secret_access_key)"

# confirm AWS env vars exist
[[ -z "$AWS_DEFAULT_REGION" ]] && echo "ERROR: AWS_DEFAULT_REGION not set" || echo "AWS_DEFAULT_REGION is set"
[[ -z "$AWS_ACCESS_KEY_ID" ]] && echo "ERROR: AWS_ACCESS_KEY_ID not set" || echo "AWS_ACCESS_KEY_ID is set"
[[ -z "$AWS_SECRET_ACCESS_KEY" ]] && echo "ERROR: AWS_SECRET_ACCESS_KEY not set" || echo "AWS_SECRET_ACCESS_KEY is set"

# configure git
git config --system --remove-section credential 
git config --global --remove-section credential 
git config --global --remove-section 'credential.https://git-codecommit.us-east-1.amazonaws.com' 
git config --global credential.'https://git-codecommit.us-east-1.amazonaws.com'.helper '!aws codecommit credential-helper $@' 
git config --global credential.'https://git-codecommit.us-east-1.amazonaws.com'.UseHttpPath true

# configure go powerline
function _update_ps1() {
    PS1="$($GOPATH/bin/powerline-go -error $?)"
}

if [ "$TERM" != "linux" ] && [ -f "$GOPATH/bin/powerline-go" ]; then
    PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
fi
EOT