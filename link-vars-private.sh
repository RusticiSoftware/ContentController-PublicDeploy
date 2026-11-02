#!/bin/bash

if [ ! -d ../cc-deployment-private ]; then
    echo "Please clone cc-deployment-private to the same directory as cc-deployment-public before running this script."
    exit 1
fi

cd group_vars
if [ -a ../../cc-deployment-private/group_vars/aws.yml ]; then
    ln -fs ../../cc-deployment-private/group_vars/aws.yml aws.yml
fi

if [ -a ../../cc-deployment-private/group_vars/cloudfront.yml ]; then
    ln -fs ../../cc-deployment-private/group_vars/cloudfront.yml cloudfront.yml
fi

if [ -a ../../cc-deployment-private/group_vars/content_controller.yml ]; then
    ln -fs ../../cc-deployment-private/group_vars/content_controller.yml content_controller.yml
fi

if [ -a ../../cc-deployment-private/group_vars/engine_java.yml ]; then
    ln -fs ../../cc-deployment-private/group_vars/engine_java.yml engine_java.yml
fi

if [ -a ../../cc-deployment-private/group_vars/env.yml ]; then
    ln -fs ../../cc-deployment-private/group_vars/env.yml env.yml
fi

if [ -a ../../cc-deployment-private/group_vars/s3.yml ]; then
    ln -fs ../../cc-deployment-private/group_vars/s3.yml s3.yml
fi

if [ -a ../../cc-deployment-private/group_vars/keypair.yml ]; then
    ln -fs ../../cc-deployment-private/group_vars/keypair.yml keypair.yml
fi

cd ../host_vars

cp ../../cc-deployment-private/host_vars/* .

cd ../roles

if [ -d ../../cc-deployment-private/roles/users ]; then
    ln -fs ../../cc-deployment-private/roles/users .
fi

cp -rp ../../cc-deployment-private/roles/ssl/files ssl/files

cp -rp ../../cc-deployment-private/roles/cloudfront/files cloudfront/files

if [ -d ../../cc-deployment-private/roles/logstash-filebeat ]; then
    ln -fs ../../cc-deployment-private/roles/logstash-filebeat .
fi

if [ -d ../../cc-deployment-private/roles/dripstat ]; then
    ln -fs ../../cc-deployment-private/roles/dripstat .
fi

if [ -d ../../cc-deployment-private/roles/site24x7 ]; then
    ln -fs ../../cc-deployment-private/roles/site24x7 .
fi

if [ -d ../../cc-deployment-private/roles/scorm-engine-2016 ]; then
    ln -fs ../../cc-deployment-private/roles/scorm-engine-2016 .
fi

if [ -d ../../cc-deployment-private/roles/apache-engine-2016 ]; then
    ln -fs ../../cc-deployment-private/roles/apache-engine-2016 .
fi

if [ -d ../../cc-deployment-private/roles/doc ]; then
    ln -fs ../../cc-deployment-private/roles/doc .
fi

if [ -d ../../cc-deployment-private/roles/mocha-api ]; then
    ln -fs ../../cc-deployment-private/roles/mocha-api .
fi

if [ -d ../../cc-deployment-private/roles/consul ]; then
    ln -fs ../../cc-deployment-private/roles/consul .
fi

if [ -d ../../cc-deployment-private/roles/newrelic-infrastructure/ ]; then
    ln -fs ../../cc-deployment-private/roles/newrelic-infrastructure .
fi

cd ../

if [ -a ../cc-deployment-private/engine.yml ]; then
    ln -fs private/engine.yml engine.yml
fi

if [ -a ../cc-deployment-private/build_ami.yml ]; then
    rm -f build_ami.yml
    ln -fs private/build_ami.yml build_ami.yml
fi

if [ -a ../cc-deployment-private/build_ami_engine2016.yml ]; then
    ln -fs private/build_ami_engine2016.yml build_ami_engine2016.yml
fi
