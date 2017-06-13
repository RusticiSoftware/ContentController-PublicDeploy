![RusticiContentControllerLogo](img/Rustici_ContentController.png)

## Vagrant

Vagrant can be useful for running test environments.  We provide preconfigured Vagrantfiles for Parallels.  You'll need Vagrant 1.8+ for Parallels to behave on El Capitan.

[To install Vagrant, head to https://www.vagrantup.com/downloads.html](https://www.vagrantup.com/downloads.html)

After installing Vagrant, you'll need to ensure that you have the `hostmanager` plugin installed:

	vagrant plugin install vagrant-hostmanager

There are two VMs enumerated in this Vagrantfile, each of which responds to different DNS names:

_cc.example.com_
	cc # Runs the cc environment without s3 support

_ccs3.example.com_
	ccs3 # Runs the cc environment WITH s3 support

Most of the time, you'll prolly want to use "cc".

To use Parallels, do:

	ln -s Vagrantfile.parallels Vagrantfile

	vagrant plugin install vagrant-parallels

	vagrant up # Launches both S3-enabled and local storage VMs (you'll need 8GB free to make this go.)

	vagrant up cc # Runs the cc environment without s3 support

	vagrant up ccs3 # Runs the cc environment WITH s3 support

To ssh to your box, you need to specify a host.  Hosts are defined in the Vagrantfile

	vagrant ssh cc # ssh to the box with local storage

	vagrant ssh ccs3 # ssh to the box with S3 Storage

If you want to update individual roles without running all of the playbooks against a Vagrant instance, do thusly.  Make sure you set the path to your inventory file correctly.  To see what inventory file you're using, run Vagrant with the ansible provisioner configured to be verbose, like so:

        config.vm.provision :ansible do |ansible|
    	ansible.playbook = "env.yml"
    	ansible.verbose = "v"
  	  end

To run only the content-controller role:

	ansible-playbook --connection=ssh --timeout=30 --inventory-file=.vagrant/provisioners/ansible/inventory --extra-vars "skip_deps=true" cc.yml

To run only the cc-scorm-engine role:

	ansible-playbook --connection=ssh --timeout=30 --inventory-file=.vagrant/provisioners/ansible/inventory --extra-vars "skip_deps=true" cc-scorm-engine.yml
