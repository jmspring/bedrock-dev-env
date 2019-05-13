#!/bin/bash

# verify we are running as root
if [[ "$EUID" != 0 ]]; then
    echo "Script must be run as root or sudo."
    exit 1
fi

# create a temporary directory to do work in
tmp_dir=$(mktemp -d -t ci-XXXXXXXXXX)
cd $tmp_dir

# retrieve latest go version
# this snippet taken from <add reference>
GOURLREGEX='https://dl.google.com/go/go[0-9\.]+\.linux-amd64.tar.gz'
echo "Finding latest version of Go for AMD64..."
url="$(wget -qO- https://golang.org/dl/ | grep -oP 'https:\/\/dl\.google\.com\/go\/go([0-9\.]+)\.linux-amd64\.tar\.gz' | head -n 1 )"
latest="$(echo $url | grep -oP 'go[0-9\.]+' | grep -oP '[0-9\.]+' | head -c -2 )"
echo "Downloading latest Go for AMD64: ${latest}"
wget --quiet --continue --show-progress "${url}"
unset url
unset GOURLREGEX

# install / replace existing go
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go"${latest}".linux-amd64.tar.gz

# remove directory
cd -
rm -rf $tmp_dir
