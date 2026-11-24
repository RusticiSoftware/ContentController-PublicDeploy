---
title: "Security"
type: docs
menu:
    main:
        name: Customizing Security Settings
        identifier: security
        weight: 2
---

# Customizing Security Settings

By default, Content Controller ships with security settings that work for most people.  However, sometimes tighter 
security is more desireable than supporting older browsers.  Most security-related settings can be adjusted by changing 
a few playbook variables.

## HTTP Strict Transport Security (HSTS)

If you need to support LMSs that only work with HTTP, then you can not use this setting.  If you want to force HTTPS 
access semi-permanently, you can enable 
[HTTP Strict Transport Security](https://en.wikipedia.org/wiki/HTTP_Strict_Transport_Security).  **Only do this if 
you're sure that you do not need to support HTTP-only LMSs.**  Once the setting is enabled, browsers will be locked to 
loading over HTTPS only for at least 6 months.

1. On your Ansible control server, go to `ContentController_PublicDeploy` and edit `group_vars/env.yml`.
2. If you're terminating SSL at Apache, edit the line that starts with `allow_80` and set it to `allow_80: false`; 
   if you're terminating SSL at your load balancer (and/or using CloudFront), set it to `allow_80: true`.
3. Add this line under `# SSL Configuration`: `use_hsts: true`
4. If you would like to adjust the time of the HTTPS lock, add the line setting the `hsts_max_age` with the desired 
   value in seconds.
5. If you'd like to include the `includeSubDomains` option in the HSTS header, then also add the line 
   `hsts_include_subdomains: true`. [RFC 6797](https://tools.ietf.org/html/rfc6797#section-14.4) recommends this option,
   but it should not be used if any subdomain of your Content Controller installation could possibly need to allow 
   HTTP-only access in the future.
6. Save and exit.
7. Run the playbooks to deploy your changes.

## Session Timeout

By default, session timeout is 24 hours.  The minimum allowed value is 1 minute, and the maximum allowed value is 43200 
minutes (30 days).

1. On your Ansible control server, go to `ContentController_PublicDeploy` and edit `group_vars/content_controller.yml`.
2. Add this line `token_exp: 1440`, but replace `1440` with your desired session length in minutes.
3. Save and exit.
4. Run the playbooks to deploy your changes.

## Public API Auth Token Expiration

By default, the public API auth token expires after 30 minutes.

1. On your Ansible control server, go to `ContentController_PublicDeploy` and edit `roles/content-controller/defaults/main.yml`.
2. Add this line `public_api_auth_expiration: #`, but replace `#` with your desired session length in minutes.
3. Save and exit.
4. Run the playbooks to deploy your changes.

## Disabling Inactive User Accounts

Users that have experienced a specific number of days since its last login and last unlock are considered inactive. By 
default, this behavior is disabled.

1. On your Ansible control server, go to `ContentController_PublicDeploy` and edit `group_vars/content_controller.yml`.
2. Add this line `user_account_days_inactive_threshold: 30`, and replace `30` with your desired inactivity threshold in 
   number of days.
3. Save and exit.
4. Run the playbooks to deploy your changes.

## SSL Cipher Suites

Ciphers can be enabled or disabled by supplying an SSL cipher suite config.  By default, we use [this config provided by
Mozilla's SSL Configuration Generator](https://mozilla.github.io/server-side-tls/ssl-config-generator/?server=apache-2.4.28&openssl=1.0.1f&hsts=no&profile=intermediate).
If you don't need to support older browsers, you can use the **SSLCipherSuite** provided by choosing the **Modern** 
settings.

## Using SSL for Database Traffic

Content Controller can be configured to encrypt traffic to the database using SSL/TLS. At a minimum, you just need to 
add `db_use_ssl: true` to one of your Ansible config files. By default, Content Controller will trust the certificates 
used by RDS databases.

If you want to communicate with a database that is not in RDS, then you will also need to provide the certificate of 
that database in the `roles/ssl/files` directory of your playbooks. Then, configure the setting 
`db_ssl_cert: [certificate name]`, but replace `[certificate name]` with the name of the file you added to the 
playbooks.

Additionally, there is an optional setting you can set to control the SSL protocols supported. By default, 
`db_ssl_protocols` will have the value of `"TLSv1,TLSv1.1,TLSv1.2"`. If you want to add or remove protocols from this 
default list, then override it by providing your own list of values.

### Terminating SSL at CloudFront

See this AWS documentation on [Supported Protocols and Ciphers](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/secure-connections-supported-viewer-protocols-ciphers.html), 
and then update your CloudFront Security Policies and Elastic Load Balancer Security Policies to match.  See the 
[CloudFront page](/self-hosting/aws/cloudfront) for a refresher on setting distribution details, and see the 
[Load Balancer page](/self-hosting/aws/load-balancer) for a refresher on setting the application load balancer config.

### Terminating SSL at the Application Server

1. On your Ansible control server, go to `ContentController_PublicDeploy` and edit `group_vars/env.yml`.
2. Add this line under `# SSL Configuration`, but replace `...` with your desired cipher suite config: 
   `ssl_cipher_suite: "..."`
3. Save and exit.
4. Run the playbooks to deploy your changes.

## SSL Protocol

By default, we allow TLS 1.0, TLS 1.1, and TLS 1.2.  If you do not need to support learners using older 
browsers/operating systems (such as IE 9 and Windows Vista), then you should turn off TLS 1.0.

### SSL Terminated at CloudFront

Check your CloudFront Origin Behaviors and verify that you have set the desired protocols.  See the 
[CloudFront](/self-hosting/aws/cloudfront) docs for a refresher on setting origin behavior details.

### SSL Terminated at the Application Server

1. On your Ansible control server, go to `ContentController_PublicDeploy` and edit `group_vars/env.yml`.
2. Add this line under `# SSL Configuration`: `ssl_protocol: "all -SSLv2 -SSLv3 -TLSv1"`
3. Save and exit.
4. Run the playbooks to deploy your changes.

### Configuring Password Reset Limits

Password reset emails can be sent through the 'Forgot Password?' button on the login page. This page does not require 
authentication to access, therefore we want to protect users against a malicious actor using this functionality to spam
them with emails. We check the IP address and requested email of the password reset email request to ensure the 
combination has not requested a password reset email more than `password_reset_failure_threshold` times in the past 
`password_reset_failure_window ` days.

Additionally, to protect against a distributed attack with requests to reset a single user's password coming from 
multiple IP address, we check to see if there have been `2 * password_reset_failure_threshold` password reset requests 
from _any_ IP addresses in the last `password_reset_failure_window` days.

The maximum number of requests (default of 3 attempts) and the number of days back in which to check those requests (default 1 day) are configurable.

1. On your Ansible control server, go to `ContentController_PublicDeploy` and edit `group_vars/content_controller.yml`.
2. To change the maximum number of attempts allowed, add `password_reset_failure_threshold: #` but replace `#` with 
   number of maximum attempts you wish to allow.
3. To change the number of days in which password reset requests are checked against, add 
   `password_reset_failure_window: #` but replace `#` with the number of days back you wish to check. This value should 
   not exceed `30`.
4. Save and exit.
5. Run the playbooks to deploy your changes.
