#!/bin/bash

cd group_vars

ln -fs ../private/group_vars/aws.yml aws.yml
ln -fs ../private/group_vars/cloudfront.yml cloudfront.yml
ln -fs ../private/group_vars/content_controller.yml content_controller.yml
ln -fs ../private/group_vars/engine_java.yml engine_java.yml
ln -fs ../private/group_vars/env.yml env.yml
ln -fs ../private/group_vars/s3.yml s3.yml
ln -fs ../private/group_vars/keypair.yml keypair.yml

cd ../host_vars

cp ../private/host_vars/* .

cd ../roles

if [ -d ../private/roles/users ]; then
	ln -fs ../private/roles/users .
fi

cp -rp ../private/roles/ssl/files ssl/files

cp -rp ../private/roles/cloudfront/files cloudfront/files

if [ -d ../private/roles/logstash-filebeat ]; then
	ln -fs ../private/roles/logstash-filebeat .
fi

if [ -d ../private/roles/dripstat ]; then
	ln -fs ../private/roles/dripstat .
fi

if [ -d ../private/roles/site24x7 ]; then
	ln -fs ../private/roles/site24x7 .
fi
