# AMI Builder

## Vars

Edit `group_vars/aws.yml` to suit your purposes before you move forward.

If you have a lot of different environments, it's a good idea to have a separate vars file for each that captures the delta between that host and others.  You can represent these vars in a separate YAML file and then load that file via the `--extra-vars` flag.

## Building:

To build an AMI using a particular vars file to override your defaults, do:

	ansible-playbook -v -i inventory.rustici -u ubuntu --extra-vars="@host_vars/some.special.host.yml" build_ami.yml

To build an AMI, use an invocation similar to:

	ansible-playbook -v -i inventory.rustici -u ubuntu --extra-vars="deploy=True" build_ami.yml

To build an AMI and set some other vars in a particular way (like to enable all the CloudFront bits you've so painstakingly configured), do thusly.  :

	ansible-playbook -vvvv -i inventory.rustici -u ubuntu --extra-vars="ServerName=cc.example.com env=qa deploy=True use_cloudfront=True S3FileStorageEnabled=True" build_ami.yml

