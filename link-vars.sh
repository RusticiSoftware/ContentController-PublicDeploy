#!/bin/bash

cd group_vars
if [ -a ../private/group_vars/aws.yml ]; then
	ln -fs ../private/group_vars/aws.yml aws.yml
fi

if [ -a ../private/group_vars/cloudfront.yml ]; then
	ln -fs ../private/group_vars/cloudfront.yml cloudfront.yml
fi

if [ -a ../private/group_vars/content_controller.yml ]; then
	ln -fs ../private/group_vars/content_controller.yml content_controller.yml
fi

if [ -a ../private/group_vars/engine_java.yml ]; then
	ln -fs ../private/group_vars/engine_java.yml engine_java.yml
fi

if [ -a ../private/group_vars/env.yml ]; then
	ln -fs ../private/group_vars/env.yml env.yml
fi

if [ -a ../private/group_vars/s3.yml ]; then
	ln -fs ../private/group_vars/s3.yml s3.yml
fi

if [ -a ../private/group_vars/keypair.yml ]; then
	ln -fs ../private/group_vars/keypair.yml keypair.yml
fi

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

if [ -d ../private/roles/newrelic ]; then
	ln -fs ../private/roles/newrelic .
fi

if [ -d ../private/roles/scorm-engine-2016 ]; then
	ln -fs ../private/roles/scorm-engine-2016 .
fi

if [ -d ../private/roles/apache-engine-2016 ]; then
	ln -fs ../private/roles/apache-engine-2016 .
fi

if [ -d ../private/roles/doc ]; then
	ln -fs ../private/roles/doc .
fi

if [ -d ../private/roles/mocha-api ]; then
	ln -fs ../private/roles/mocha-api .
fi

if [ -d ../private/roles/consul ]; then
	ln -fs ../private/roles/consul .
fi

cd ../

if [ -a private/engine.yml ]; then
	ln -fs private/engine.yml engine.yml
fi

if [ -a private/build_ami_engine2016.yml ]; then
	ln -fs private/build_ami_engine2016.yml build_ami_engine2016.yml
fi


