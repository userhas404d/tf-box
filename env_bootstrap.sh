#!/bin/bash

# configure git
echo "-------------------------"
echo "configuring git.."
echo "-------------------------"
git config --system --remove-section credential 
git config --global --remove-section credential 
git config --global --remove-section 'credential.https://git-codecommit.us-east-1.amazonaws.com' 
git config --global credential.'https://git-codecommit.us-east-1.amazonaws.com'.helper '!aws codecommit credential-helper $@' 
git config --global credential.'https://git-codecommit.us-east-1.amazonaws.com'.UseHttpPath true
echo "git configuration complete"