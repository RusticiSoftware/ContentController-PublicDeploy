---
title: "EC2 Bastion / Ansible Controller"
type: docs
menu:
    main:
        name: 5. EC2 Bastion / Ansible Controller
        identifier: ec2_ansible
        parent: aws
        weight: 6
---

# EC2 Bastion / Ansible Controller

The first server you will need is a publicly accessible bastion host.  This server will go in the public subnet, have a public IP, and be accessible through SSH.  You can tunnel through this machine to access your databases, and you can host your Ansible playbooks on this server.  **You should pay careful attention to make sure this server stays up to date and is well-secured.**  Make a backup of it once you're finished with the initial setup.  It will contain your application secrets, passwords, and configs.

Go to **Services** -> **EC2**

## Create an Instance, Security Group, and Key Pair

1. Click on **Instances** on the left sidebar and click the blue **Launch Instance** button.
2. Click **Select** by the instance type to use.  Any linux should work for this box, but we recommend **Ubuntu Server 18.04 LTS (HVM)**, and the rest of these instructions (such as bootstrapping) will assume that is the instance type you chose.
3. Choose **t2.micro** as the instance type, and click **Next: Configure Instance Details**.
4. Choose `Rustici CC VPC` for your Network, `CC Public 1` for your Subnet, `Enable` for Auto-assign Public IP, `RusticiCCAnsibleRole` for the IAM role, enable protect against accidental termination, enable T2 unlimited if you'd like, and click **Next: Add Storage**. <br><br> **WARNING**: Be aware of what you're doing here!  By attaching credentials (`RusticiCCAnsibleRole`) to this instance that have the power to create IAM roles, servers, etc, if this machine is compromised, the attacker will have the ability to create new user accounts and do anything they want in your AWS account.  Make sure you keep this server secure!! <br><br>{{< img src="/self-hosting/aws/img/ec2-create-ansible-config.png" >}}<br><br>
5. Enter a value for the root volume size (16 GB is probably good) and uncheck Delete on Termination.  Click **Next: Add Tags**.
6. Click **Add Tag**.  Enter `Name` for the Key and `CC Ansible` for the Value.  Click **Next: Configure Security Group*.
7. Choose **Select an existing security group** and check the box beside the `CC Ansible` security group you created earlier.
8. Click **Review and Launch**.
9. Click **Launch**.
10. In the dialog choose **Create a new key pair** and name it `rustici-cc`.  Click **Download Key Pair**.  Save this key pair in a safe, private place, and back it up.  You can't get into this server without it.
11. Click **Launch Instances**.
12. You should see your new `CC Ansible` instance in the list of instances.  Select it and copy the IPv4 Public IP address from the description tab.  This is the IP address you will use to connect to your server.

### Create a DNS record in Route 53

If you don't want to remember the IP address to your Ansible control server, you can create an A record for it in Route 53.  For our demo, we'll create `ansible.demo.contentcontroller.net`.

1. Go to **Services** -> **Route 53**.
2. Select **Hosted zones** on the left sidebar.
3. Select your domain.
4. Click the blue **Create Record Set** button.
5. In the sidebar that appears, enter your desired subdomain **Name** (such as `ansible`), and choose `A - IPv4 address` for the **Type**.
6. Enter the IPv4 Public IP address from step 12 above in the **Value** box.
7. Click **Create**.

## Prepare your SSH key

We're assuming that you are using macOS or Linux for this step.  If you are using Windows, please refer to the documentation for your SSH client (such as Putty).

1. Copy the `rustici-cc.pem` key pair that you downloaded to `~/.ssh/rustici-cc.pem`.
2. Change the permissions by running `chmod 0600 ~/.ssh/rustici-cc.pem`.

## Bootstrap Ansible Controller

This will download all of the Ansible playbooks for installing Content Controller and install Ansible and its dependencies.

1. SSH to your Ansible instance. On macOS or Linux, you can do this by running `ssh -i ~/.ssh/rustici-cc.pem ubuntu@ansible.demo.contentcontroller.net`.
2. Update the server by running `sudo apt update && sudo apt upgrade -y`.  If you are prompted about updating grub, choose **keep the local version currently installed**.
3. Make sure git is installed by running `sudo apt install -y git`.
4. Pick a place to store Content Controller's deploy files, secrets, etc.  Your home directory is fine, unless you plan on adding additional user accounts to this machine.  Run `cd ~` to get there.
5. Clone the deploy file repository by running `git clone https://github.com/RusticiSoftware/ContentController-PublicDeploy.git`.
6. Go to the newly cloned directory. `cd ContentController-PublicDeploy`
7. Run `sudo ./bootstrap.sh` to install the necessary dependencies for running the Ansible playbooks.

## Bootstrap Content Controller secrets and config

This will generate application passwords, database passwords, and other sensible defaults.

1. SSH to your Ansible instance and go to your `ContentController-PublicDeploy` directory.
2. Run `nano group_vars/keypair.yml`.  Paste the contents of the `keypair.yml` file provided for you by Rustici Software.  Press CTRL + X to exit, and press `Y` and then press ENTER to save.
3. Run `./setup.sh demo.contentcontroller.net`, but substitute your own domain.  Type `YES` to confirm, and press enter.

### Edit group_vars

Now, you'll need to set some configuration parameters to match your environment.  If you haven't already, take a look at the [Deploy Tools](/self-hosting/deploy-tools) to see what the host_vars and group_vars are all about.  Then, edit these files as needed for your installation.

If you're following this example exactly, then you'll need to make at least these changes:

#### `group_vars/env.yml`

* Change `env: dev` to `env: prod`
* Change `S3FileStorageEnabled: False` to `S3FileStorageEnabled: true`
* Change `mysql_root_user: root` to `mysql_root_user: ccroot`
* Make note of the `mysql_root_user` and `mysql_root_password`.  You will need those when provisioning the RDS instance.
* Change `use_ssl: true` to `use_ssl: false` and `allow_80: false` to `allow_80: true`.  We'll be terminating SSL at the load balancer.
* If your application server does not have exactly 4 GB RAM, then you'll probably need to adjust the heap sizes.
