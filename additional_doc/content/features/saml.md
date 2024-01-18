---
title: "SAML"
type: docs
menu:
    main:
        name: SAML Integration
        identifier: saml
        parent: features
        weight: 5
---

# SAML SSO

## Introduction
SAML allows an organization to create a single source of truth for user identity management and communicate this 
information with other applications. The user identity source is referred to as the Identity Provider (IdP) which 
communicates with Service Providers (SP). In this context, Content Controller is the Service Provider and an application
like Active Directory would be the Identity Provider.

The following steps will describe how to integrate your Identity Provider with Content Controller.

## Setup
Before starting the configuration of SAML on the Content Controller side of things, first you must obtain a metadata XML
file from your identity provider and place it in the `roles/saml/files` directory of the playbooks and name it 
`idp-metadata.xml`.

Next, if you do not already have one, you will need to generate a keystore for all signature and encryption operations. 
Execute the following commands, replacing `{private_key_password}` and `{keystore_password}` with strong passwords. 
Keep track of these two passwords as they will be added to the Content Controller configuration later.

```
keytool -genkeypair -alias pac4j-demo \
  -keystore samlKeystore.jks -keyalg RSA -keysize 2048 -validity 3650 \
  -keypass {private_key_password} -storepass {keystore_password}
```

This command will output a file named `samlKeystore.jks`. Where you run the command isn't important, as long as the 
`samlKeystore.jks` is copied onto the Ansible control server. It needs to be moved into the `roles/saml/files` directory
of the playbooks.

## Content Controller Configuration
With these files now in the proper place, open your `group_vars/content_controller.yml` configuration file in the 
Ansible playbooks. Find the placeholder values for these settings and update them to the following:

```
enable_saml: true
private_key_password: {private_key_password used to generate keystore}
keystore_password: {keystore_password used to generate keystore}
maximum_auth_lifetime: 3600
include_query_param_on_callback: true
```

`maximum_auth_lifetime` is the maximum age in seconds that Content Controller will allow for a user. If a token older 
than this lifetime is used in a request, then CC will reject it. The value configured in CC should be shorter than or 
equal to the same value in your IdP server.

`include_query_param_on_callback` determines whether or not query parameters are included on the SAML callback URLs. 
This is configurable as some Identify Providers do not accept query parameters. If Content Controller doesn't include 
query parameters, the 'client_name' property will be set as part of the SAML resolver.

### Identifying Users

After your IdP authenticates a user, it will send information about that user to Content Controller in the form of 
attributes on a profile. By default, CC will use the value of the `email` attribute as the user ID when a user logs in 
through SSO. However, if there is an attribute on the SAML profile that you would prefer as the identifier, you can use 
the setting `saml_identifying_attribute`. The value of this setting should be the name of the attribute that should be 
used to uniquely identify users. The value of the attribute will be used to uniquely identify users coming from your 
IdP, so please ensure that the value of the attribute is unique for each user.

### Authorizing Users

By default, Content Controller will allow any user that comes from your IdP. However, CC can be configured to authorize 
users based on the attributes that are sent back your IdP. If you would like to limit the users that can access the 
application, then you can use the following settings:

* `saml_access_attribute`: The name of the attribute used to authorize users.
* `saml_access_value`: The value required to be in or equal to the `saml_access_attribute`.
* `saml_access_condition`: The operation used to verify that the `saml_access_value` is present in the 
  `saml_access_attribute`. Can be `equals`, `starts_with`, or `contains`. If not specified, will default to `contains`.

If the above settings are configured, Content Controller will first verify that the `saml_access_attribute` is present
on the profile sent by the IdP. Then, depending on the configured `saml_access_condition`, CC will verify that the 
attribute value either equals, starts with, or contains the `saml_access_value`.

For example, if you wanted to require that users SSOing into Content Controller have an attribute `teams` that contains
the string `content_controller`, then you would set the following:

```
saml_access_attribute: "teams"
saml_access_value: "content_controller"
```

If you wanted to be very strict and require that users have the attribute `cc_admin` set to `true`, then you would set
the following:

```
saml_access_attribute: "cc_admin"
saml_access_value: "true"
saml_access_condition: "equals"
```

## IdP Configuration

To integrate Content Controller with your IdP server, you will need to provide a service provider metadata file. This 
file is used to configure your IdP so that it knows how to communicate with Content Controller.  Because these steps 
rely on saving a file to disk, if you've multiple app servers behind a load balancer, then this process will be more 
reliable if you can execute the requests directly against one app server.

After you've deployed Content Controller, first visit the endpoint `[domain or IP]/api/saml`. This will attempt to 
initiate an SSO login, and probably redirect you over to the IdP. This process will generate a SAML metadata file on 
disk. If you get an error back from that endpoint, then there may be an issue with your SAML configuration. Refer to the
application logs for more details.

Once you've generated the service provider metadata, you can access it by hitting the endpoint 
`[domain or IP]/api/saml/metadata`. It will return an XML document that you can save to the file system. Then, provide 
it to your IdP in the appropriate manner. This will vary depending on which IdP you are using; for more information, 
refer to that product's documentation or support team.

Content Controller will need permission to initiate the SSO process. Some IdP's may require special configuration to 
enable SP-Initiated SSO. If the specific binding is required, please add 
`urn:oasis:names:tc:SAML:profiles:SSO:request-init` as one of the allowable SAML bindings.

By default, Content Controller requires an `email` attribute on the profile your IdP provides. If that is not included 
by default, then you may need to do a bit of extra configuration to ensure that information is communicated to the 
application. Alternatively, you can refer to the "Identifying Users" section above for how to configure Content 
Controller to not require an `email` attribute.


## Use

Once enabled, a new `SSO` button will appear on the login page that will redirect the user to your Identity Provider 
login page. If authentication with the IdP is successful, then the user will be redirected back to Content Controller 
and issued a valid authentication token. If a CC profile already exists with that email address, then the user will be 
logged in using that profile. If such a user does not already exist in the application, then one will be created.
