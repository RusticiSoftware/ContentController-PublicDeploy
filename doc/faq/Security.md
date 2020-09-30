# Customizing Security Settings

By default, Content Controller ships with security settings that work for most people.  However, sometimes tighter security is more desireable than supporting older browsers.  Most security-related settings can be adjusted by changing a few playbook variables.

## HTTP Strict Transport Security (HSTS)

If you need to support LMSs that only work with HTTP, then you can not use this setting.  If you want to force HTTPS access semi-permanently, you can enable [HTTP Strict Transport Security](https://en.wikipedia.org/wiki/HTTP_Strict_Transport_Security).  **Only do this if you're sure that you do not need to support HTTP-only LMSs.**  Once the setting is enabled, browsers will be locked to loading over HTTPS only for at least 6 months.

1. On your Ansible control server, go to `ContentController_PublicDeploy` and edit `group_vars/env.yml`.
2. If you're terminating SSL at Apache, edit the line that starts with `allow_80` and set it to `allow_80: false`; if you're terminating SSL at your load balancer (and/or using CloudFront), set it to `allow_80: true`.
3. Add this line under `# SSL Configuration`: `use_hsts: true`
4. If you would like to adjust the time of the HTTPS lock, add the line setting the `hsts_max_age` with the desired value in seconds.
5. If you'd like to include the `includeSubDomains` option in the HSTS header, then also add the line `hsts_include_subdomains: true`. [RFC 6797](https://tools.ietf.org/html/rfc6797#section-14.4) recommends this option, but it should not be used if any subdomain of your CC installation could possibly need to allow HTTP-only access in the future.
6. Save and exit.
7. Run the playbooks to deploy your changes.

## Session Timeout

By default, session timeout is 24 hours.  The minimum allowed value is 1 minute, and the maximum allowed value is 43200 minutes (30 days).

1. On your Ansible control server, go to `ContentController_PublicDeploy` and edit `group_vars/content_controller.yml`.
2. Add this line `token_exp: 1440`, but replace `1440` with your desired session length in minutes.
3. Save and exit.
4. Run the playbooks to deploy your changes.

## Disabling Inactive User Accounts

Users that have experienced a specific number of days since its last login and last unlock are considered inactive. By default, this behavior is disabled.

1. On your Ansible control server, go to `ContentController_PublicDeploy` and edit `group_vars/content_controller.yml`.
2. Add this line `user_account_days_inactive_threshold: 30`, and replace `30` with your desired inactivity threshold in number of days.
3. Save and exit.
4. Run the playbooks to deploy your changes.

## SSL Cipher Suites

Ciphers can be enabled or disabled by supplying an SSL cipher suite config.  By default, we use [this config provided by Mozilla's SSL Configuration Generator](https://mozilla.github.io/server-side-tls/ssl-config-generator/?server=apache-2.4.28&openssl=1.0.1f&hsts=no&profile=intermediate).  If you don't need to support older browsers, you can use the **SSLCipherSuite** provided by choosing the **Modern** settings.

### Terminating SSL at CloudFront

See this AWS documentation on [Supported Protocols and Ciphers](https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/secure-connections-supported-viewer-protocols-ciphers.html), and then update your CloudFront Security Policies and Elastic Load Balancer Security Policies to match.  See the [CloudFront docs](aws/CloudFront.md) for a refresher on setting distribution details, and see the [Load Balancer docs](aws/LoadBalancer.md) for a refresher on setting the application load balancer config.

### Terminating SSL at the Application Server

1. On your Ansible control server, go to `ContentController_PublicDeploy` and edit `group_vars/env.yml`.
2. Add this line under `# SSL Configuration`, but replace `...` with your desired cipher suite config: `ssl_cipher_suite: "..."`
3. Save and exit.
4. Run the playbooks to deploy your changes.

## SSL Protocol

By default, we allow TLS 1.0, TLS 1.1, and TLS 1.2.  If you do not need to support learners using older browsers/operating systems (such as IE 9 and Windows Vista), then you should turn off TLS 1.0.

### SSL Terminated at CloudFront

Check your CloudFront Origin Behaviors and verify that you have set the desired protocols.  See the [CloudFront](aws/CloudFront.md) docs for a refresher on setting origin behavior details.

### SSL Terminated at the Application Server

1. On your Ansible control server, go to `ContentController_PublicDeploy` and edit `group_vars/env.yml`.
2. Add this line under `# SSL Configuration`: `ssl_protocol: "all -SSLv2 -SSLv3 -TLSv1"`
3. Save and exit.
4. Run the playbooks to deploy your changes.
