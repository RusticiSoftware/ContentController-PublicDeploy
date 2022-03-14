#!/bin/bash
if [ ! -d ../cc-deployment-dev ]; then
    echo "Please clone cc-deployment-dev to the same directory as cc-deployment-public before running this script."
    exit 1
fi

# Link group vars
cd group_vars
for file in `find ../../cc-deployment-dev/group_vars -name '*.yml' -type f -exec basename {} ';'`; do
    ln -fs "../../cc-deployment-dev/group_vars/$file" "$file"
done
cd ..

# Link host vars
cd host_vars
for file in `find ../../cc-deployment-dev/host_vars -name '*.yml' -type f -exec basename {} ';'`; do
    ln -fs "../../cc-deployment-dev/host_vars/$file" "$file"
done
cd ..

# Link ansible.cfg
ln -s ../cc-deployment-dev/ansible.cfg ./

# Link SSL certs
cd roles/ssl
ln -fs ../../../cc-deployment-dev/roles/ssl/files files
cd ../..

# Link roles
cd roles
ln -fs ../../cc-deployment-dev/roles/minio .
ln -fs ../../cc-deployment-dev/roles/qa-dev .
cd ..

# Link .ymls
for file in `find ../cc-deployment-dev -name '*.yml' -maxdepth 1 -type f -exec basename {} ';'`; do
    ln -fs "../cc-deployment-dev/$file" "$file"
done
