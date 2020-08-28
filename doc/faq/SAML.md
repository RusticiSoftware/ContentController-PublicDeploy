# SAML SSO

## Introduction
SAML allows an organization to create a single source of truth for user identity management and communicate this information with other applications. The user identity source is referred to as the Identity Provider (IdP) which communicates with Service Providers (SP). In this context, Content Controller is the Service Provider and an application like Active Directory would be the Identity Provider.

The following steps will describe how to integrate your Identity Provider with Content Controller.

## Setup
### Pre-Configuration
Before starting the configuration of SAML on the Content Controller side of things, first you must obtain a metadata XML file from your identity provider and place it in the `ContentController_PublicDeploy/roles/saml/files` directory and name it `idp-metadata.xml`.

Next if you do not already have one, you will need to generate a keystore for all signature and encryption operations. Execute the following commands, replacing `{private_key_password}` and `{keystore_password}` with strong passwords. Keep track of these two passwords as they will be added to the Content Controller configuration later.

```
keytool -genkeypair -alias pac4j-demo \
  -keystore samlKeystore.jks -keyalg RSA -keysize 2048 -validity 3650 \
  -keypass {private_key_password} -storepass {keystore_password}
```

This command will output a file named `samlKeystore.jks`. This file should be moved into the `ContentController_PublicDeploy/roles/saml/files` directory.

### Content Controller Configuration
With these files now in the proper place, open your `.yml` configuration file in `ContentController_PublicDeploy/host_vars` and add the following four lines at the bottom

```
enable_saml: true
private_key_password: {private_key_password used to generate keystore}
keystore_password: {keystore_password used to generate keystore}
maximum_auth_lifetime: 3600
```

`maximum_auth_lifetime` is the maximum age in seconds that Content Controller will allow for a user. If a token older than this lifetime is used in a request, then CC will reject it. The value configured in CC should be shorter than or equal to the same value in your IdP server.

With these settings in place, execute the normal `ansible` upgrade command, and the playbooks will take care of moving files into the correct location and enabling SAML SSO authentication.

### IdP Configuration

To integrate Content Controller with your IdP server, you will need to provide a service provider metadata file. This file is used to configure your IdP so that it knows how to communicate with Content Controller. After you've deployed Content Controller, you can generate this document using the endpoint `/api/saml/metadata`. It will return an XML document that you can save to the file system. Then, provide it to your IdP in the appropriate fashion. This may vary depending on which IdP you are using; refer to that product's documentation or support team.

Content Controller will need permission to initiate the SSO process. Some IdP's may require special configuration to enable SP-Initiated SSO. If the specific binding is required, please add `urn:oasis:names:tc:SAML:profiles:SSO:request-init` as one of the allowable SAML bindings.

Lastly, Content Controller requires an `email` attribute on the profile your IdP provides. If that is not included by default, then you may need to do a bit of extra configuration to ensure that information is communicated to the application.


## Use
Once enabled, a new `SSO` button will appear on the login page that will redirect the user to your Identity Provider login page. If authentication with the IdP is successful, then the user will be redirected back to Content Controller and issued a valid authentication token. If a CC profile already exists with that email address, then the user will be logged in using that profile. If such a user does not already exist in the application, then one will be created.
