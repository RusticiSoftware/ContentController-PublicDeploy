#!/bin/bash

# Turn our parallels Vagrant def into one suitable for virtualbox
cp Vagrantfile.parallels Vagrantfile.virtualbox
sed -i.bak 's%parallels/ubuntu-14.04%ubuntu/trusty64%g' Vagrantfile.virtualbox
sed -i.bak 's%parallels%virtualbox%g' Vagrantfile.virtualbox
rm -f Vagrantfile.virtualbox.bak

