![RusticiContentControllerLogo](img/Rustici_ContentController.png)

## Deployment Changelog:

### 0.6.97

1. Ansible-native AMI build support
1. Fix for issues where use of "%" host part of usernames in mysql-config role causes trouble with RDS installations.
1. Faster upgrade process for content-controller package updates
1. Moved use_art vars to content-controller/defaults to remove variable precendece errors in some customer deployments.

### 0.6.96

1. UTF-8 Database encoding support
1. Improved ScormEngine database install/upgrade handling
1. Database migrations for contentcontroller role have configurable override
1. Auto-discovery of dispatch schema support in Engine

### 0.5.90

1. Cloud Front support (yay!)
1. Full S3 Support without the use of S3fuse

### 0.4.74

1. Improved handling of s3fs mount points and content file storage.
1. Variable files have been greatly simplified, with vars that don't change much having been moved in to role `vars` folders.
1. ScormDriver Cross-Domain support added.
1. Improved documentation of requirements for Amazon RDS.
1. Enabled @ingramj's MariaDB compatibility plugin for the MariaDB driver.

### 0.3.58

1. SSL self-signed certificate handling is greatly improved, and we now deploy a the Debian Standard Java keystore rather than the non-awesome one that ships with the JVM.
1. Added the `data_root` var to env.yml and s3.yml to allow you to specify the path for course content without a bunch of mucking around after the fact.
1. Added the ability to use a local Apt Cache to speed up deployments for folks that are building lots of machines all the time.
1. Added proper exit pages for ScormEngine course launches.
