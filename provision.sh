#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive
apt-get update > /dev/null
apt-get -y install git-core