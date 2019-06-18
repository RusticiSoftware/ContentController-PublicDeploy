# SAML SSO

## Introduction
SAML allows an organization to create a single source of truth for user identity management and communicate this information with other applications. The user identity source is referred to as the Identity Provider (IdP) which communicates with Service Providers (SP). In this context, Content Controller is the Service Provider and an application like Active Directory would be the Identity Provider.

The following steps will describe how to integrate your Identity Provider with Content Controller.

## Setup
### Pre-Configuration
Before starting the configuration of SAML on the Content Controller side of things, first you must obtain a metadata XML file from your identity provider and place it in the `ContentController_PublicDeploy/roles/saml/files` directory and name it `idp-metadata.xml`.

Next if you do not already have one, you will need to generate a keystore for all signature and encryption operations. Execute the following commands, replacing `{keypass}` and `{storepass}` with strong passwords. Keep track of these two passwords as they will be added to the Content Controller configuration later.

```
keytool -genkeypair -alias pac4j-demo \
  -keypass {keypass} -keystore samlKeystore.jks \
  -storepass {storepass} -keyalg RSA -keysize 2048 -validity 3650
```

This command will output a file named `samlKeystore.jks`. This file should be moved into the `ContentController_PublicDeploy/roles/saml/files` directory.

### Content Controller Configuration
With these files now in the proper place, open your `.yml` configuration file in `ContentController_PublicDeploy/host_vars` and add the following four lines at the bottom

```
enable_saml: true
keystore_password: demo-passwd
private_key_password: demo-passwd
service_provider_entity_id: test
saml_email_key: 'urn:oid:1.2.840.113549.1.9.1'
```

The `saml_email_key` property key is the property that your Identity Provider will send to Content Controller in the authentication post back. This value should match the user ID of a Content Controller user.

With these settings in place, execute the normal `ansible` upgrade command, and the playbooks will take care of moving files into the correct location and enabling SAML SSO authentication.

## Use
Once enabled, Content Controller user accounts will still need to be created and managed in the Content Controler admin panel. However, a new `SSO` button will appear on the login page that will redirect the user to your Identity Provider login page. Once authentication with the IdP is successful, the user will be redirected back to Content Controller and issued a valid authentication token.
