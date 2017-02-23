#!/usr/bin/env bash

ntpdate -u pool.ntp.org

apt-get -y install python-pip build-essential checkinstall python-dev

# easy_install pip

pip install --upgrade boto

pip install ansible


