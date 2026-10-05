---
title: "Launcher Links"
type: docs
menu:
    main:
        name: Launcher Links
        identifier: launcher_links
        parent: features
        weight: 5
---

# Launcher Links

## How It Works

Launcher links allow content to be shared via a URL link without the use of an LMS. When a user shares the URL link, the
hosted launcher package makes a call back to their Content Controller instance. The Rustici SCORM Adapter within CC builds a
request URL that calls the launch API. The launch API verifies that the package token is associated with the content
token. Upon verification, it returns the relevant dispatch information needed to fill out the template dispatch within
the hosted package. The Rustici SCORM Adapter will then start the content in the player.

## How To Use A Launcher Link

This section covers using a launcher link to successfully play a course. For the sake of brevity, the UI
instructions are included here. Check the [Content Controller Automation API](https://docs.contentcontroller.com/automation-api/v1/)
for the API calls. The flow will be similar, if not the same, as the UI use case. The major area where the UI and API
use cases overlap is setting up the launcher package on a web server environment.

### Enable The Feature

This feature is an additional feature that is not included in the base Content Controller. [Contact us at Rustici Software](https://rusticisoftware.com/contact/)
to find out how to add this feature to your instance of Content Controller.

### Create A Launcher Link

The launcher link package contains the content player, which is the web application that you need to host on your server.
Each account can create launcher link packages. The package is based on Rustici SCORM Adapter; an LMS adapter that 
allows SCORM content to be played. The package structure needs to be maintained when it is unzipped. Everything in the 
unzipped package must be web-accessible relative to `index.html`.

To create a launcher link in the UI:

1. Within an account, go to **Advanced → Launcher** and expand the **Links** section.
2. Select **Add** to open the **Add Launcher Link** modal.
3. Enter a **Launcher Link Name** and the **URL** where the launcher package will be hosted (HTTPS required; include the package path).
4. Select **Add Link**.

Use **Download** to retrieve the launcher package ZIP for hosting. Use **Delete** to remove a disabled link permanently.


### Edit A Launcher Link

Only the **Launcher Link Name** and **URL** can be changed after creation. The `ccPackageToken` value embedded in the
launcher package's `index.html` does not change when you edit a link.

{{< hint warning >}}
A launcher link must be **disabled** before it can be edited or deleted.
{{< /hint >}}

To edit a launcher link:

1. Within an account, go to **Advanced → Launcher → Links**.
2. **Disable** the link using the status switch and confirm.
3. Click **Edit** (the button is locked while the link is enabled; tooltip: *Cannot be edited while enabled*).
4. Update **Launcher Link Name** and/or **URL** as needed.
5. If you change the URL, note the warning: *Changing this URL may disrupt launch links already shared or in use.* A URL change requires re-hosting the launcher package at the new location. Shared course URLs are not affected.
6. Optionally check **Download launcher package after save**.
7. Click **Save**, then **re-enable** the link when you are ready.

The Automation API supports edits via `PUT /accounts/{accountId}/launcherLinks/{launcherLinkId}`. The UI enforces the disable-before-edit rule.

### Host The Package

Unzip the launcher package on your web server. As mentioned earlier, make sure to leave the package structure as-is. There are a
couple of items in `config.js` that can be customized. Currently, these are `studentId` and `studentName`. The template
`config.js` includes an example of how to generate a UUID as the learner ID each time the content is accessed.

Unique identification for learners is the responsibility of the hosted launcher package.

### Share Content With A Launcher Link

We currently support sharing individual pieces of content. For instance, an individual course within a bundle can be
shared but not the whole bundle. Sharing content is as simple as selecting **Share** on the content and finding the
launcher link name in the drop-down. Then select **Get link**. The URL that appears is the launcher link URL meant to be
shared with whomever is allowed to take the course. It has a unique token that identifies which course the hosted player
should play.

### Items Of Note

* The dispatch offering up the content can still be limited by licensing and course deactivation.
* Access to the content can be removed by disabling the launcher link. This is in addition to the more
  traditional CC methods.
* In the launcher package, `index.html` contains the package token, `ccPackageToken`, used to verify that the correct package is
  attempting to play the content.
* Unique identification for learners is the responsibility of the hosted launcher package.


---


## SSO for Launcher Links (Optional)

{{< hint info >}}
**Optional.** The sections above are all you need for standard launcher links. Continue below only if your organization requires learners to sign in through an identity provider before launching a course.
{{< /hint >}}

Before configuring SSO, complete the launcher link setup in the previous section. SSO is configured separately under **Advanced → Launcher**, in the **Single Sign-On (optional)** section.

### Overview

By default, launcher links are public, so anyone with the link can launch and take a course anonymously. Enabling SSO adds an authentication barrier to the link.  Rather than taking a learner directly to the course, they're brought to your Identity Provider's sign-in page (such as Okta or Azure AD), and once successfully authenticated, they're directed to the course.

Enabling SSO applies it to the **entire account**, including all launcher links under that account.

{{< hint tip >}}
Content Controller supports **SAML 2.0** and **OpenID Connect (OIDC)**. You can save a configuration for each protocol, but only one SSO configuration can be enabled on an account at a time.
{{< /hint >}}

### How SSO Works

When SSO is enabled, learners follow a short sign-in flow before the course opens:

1. **Open the course link:** The learner clicks the same shared link they would use without SSO.
2. **Sign in:** They are redirected to your organization's login page (for example, Okta or Azure AD). Content Controller never sees their password.
3. **Launch the course:** After a successful login, they are sent back to the course link and the player starts.

**Where mapped learner data goes**

The **Attribute Mapping** settings tell Content Controller which details your identity provider sends for each learner, such as a unique ID and name. Content Controller uses that information to record who took the course. Those details are **not** added to the course link URL that learners share.

Instead, Content Controller collects them during sign-in and passes them securely to the hosted player. When SSO is enabled, this replaces the anonymous learner name and ID you would otherwise set up in the hosted launcher package.

### Set Up SSO

Go to **Advanced → Launcher**, expand **Single Sign-On (optional)**, and select **configure** on the **SAML 2.0** or **OpenID Connect (OIDC)** card, depending on your identity provider.

The form has six sections. Complete them in this order:

1. [Name the connection](#1-name-the-connection)
2. [Share Content Controller details with your identity provider](#2-share-content-controller-details-with-your-identity-provider)
3. [Enter your identity provider details](#3-enter-your-identity-provider-details)
4. [Map learner attributes](#4-map-learner-attributes)
5. [Test the configuration](#5-test-the-configuration)
6. [Save and enable](#6-save-and-enable)

Steps 2 and 3 differ by protocol. Follow only the **SAML 2.0** or **OpenID Connect (OIDC)** subsection that matches the card you opened.

#### 1. Name the connection

In **General Details**, enter a **Name** for this SSO connection—a label you'll recognize when sharing content (for example, *Corporate Okta Login*).

#### 2. Share Content Controller details with your identity provider

In **Service Provider Details**, copy the values Content Controller provides into your identity provider.

**SAML 2.0**

Use one of two methods:

* **Option 1 — metadata:** Copy the **Metadata URL**, or download the metadata XML file and upload it into the corresponding field in your identity provider. Identity providers can fetch the URL directly. The file contains the ACS URL, Service Provider Entity ID, and Content Controller's public signing certificate. It does **not** include private keys.
* **Option 2 — individual fields:** Copy the **ACS URL** and **Service Provider Entity ID** into the corresponding fields in your identity provider.

The same metadata path is available on the Automation API as `GET /api/public/v1/accounts/{accountId}/ssoConfigurations/serviceProviderMetadata?protocol=SAML`.

Example values (your instance will differ):

* **Metadata URL:** `https://your-instance.contentcontroller.com/api/public/v1/accounts/your-account-id/ssoConfigurations/serviceProviderMetadata?protocol=SAML`
* **ACS URL:** `https://your-instance.contentcontroller.com/api/launch/launcherLink/sso/saml/callback`
* **Service Provider Entity ID:** `https://your-instance.contentcontroller.com/api/launch/launcherLink/sso/saml/sp/your-account-id`

**OpenID Connect (OIDC)**

Copy the **Redirect URI** from Content Controller into the corresponding field in your OIDC identity provider. Your IdP uses this value when it registers the Content Controller client and generates the identity provider details needed in the next step.

Example value (your instance will differ):

* **Redirect URI:** `https://your-instance.contentcontroller.com/api/launch/launcherLink/sso/oidc/callback`

#### 3. Enter your identity provider details

In **Identity Provider Details**, enter the values your identity provider generated.

**SAML 2.0**

Use one of two methods:

* **Option 1 — metadata:** Enter a **Metadata URL** or **Upload metadata XML**. Content Controller reads the IdP metadata and fills **Identity Provider Entity ID**, **SSO URL**, and **X.509 Certificate**. You can edit the values before saving.
* **Option 2 — individual fields:** Copy the **Identity Provider Entity ID**, **SSO URL**, and **X.509 Certificate** from your identity provider into the corresponding fields.

Saving from the UI always stores these manual fields. Automation API clients may instead send `idp_metadata_url` or `idp_metadata_xml` in `config_json`.

**OpenID Connect (OIDC)**

Copy the details generated by your identity provider into Content Controller:

* **Client ID:** The client identifier issued when you register Content Controller with your identity provider.
* **Client Secret:** The client secret issued with that registration. Required when you first save the configuration.
* **Issuer URL:** The OpenID Provider issuer URL from your identity provider (for example, `https://login.microsoftonline.com/{tenant-id}/v2.0`). Content Controller uses this URL to discover the IdP's authorization and token endpoints.

{{< hint tip >}}
When you edit an existing OIDC configuration, leave the **Client Secret** field blank to keep the current secret.
{{< /hint >}}

#### 4. Map learner attributes

In **Attribute Mapping**, tell Content Controller which learner details your identity provider sends:

* **Learner ID** (required): The unique property that identifies the student. This value is used as the learner ID in the course player. For SAML, map an attribute (for example, `userId` or `email`). For OIDC, map a claim (for example, `sub` or `email`).
* **First Name** (optional): Maps the learner's first name for Engine history reports.
* **Last Name** (optional): Maps the learner's last name for Engine history reports.

#### 5. Test the configuration

Testing ensures the connection works before you save or enable it for live learners.

1. Click **Test** in the **Configuration Test (recommended)** section of the form.
2. A popup window will open and redirect to your identity provider login screen.
3. Sign in with your IdP credentials.
4. On success, the popup will close and the **Test Results** panel will expand with result details.

**Success** displays a confirmation alongside an attributes summary showing what data Content Controller extracted (for example, `learner_id`, `first_name`, `last_name`) based on your mappings.

**Failure** displays an error with details (such as an invalid signature or timestamp skew) to help your IT team troubleshoot.

#### 6. Save and enable

**Save** and **Enable** are separate steps:

1. Click **Save** to store your configuration and return to the **Launcher** page.
2. On the **SAML 2.0** or **OpenID Connect (OIDC)** card you configured, toggle SSO **on** to enable it.

Saving a new configuration does not activate SSO until you enable it from the Launcher page. If a configuration for the other protocol is already enabled, disable it before enabling this one.

### Enable or Disable SSO

#### Enable SSO

When you enable an SSO configuration, Content Controller asks for confirmation:

> *Are you sure you want to enable this SSO configuration? Learners will not be able to launch courses provided through Launcher links unless they have authenticated through the configured identity provider.*

Click **Enable** to confirm. All active launcher links under the account immediately require authentication through the configured identity provider. Only one SSO configuration can be enabled at a time.

#### Disable SSO

When you disable an active SSO configuration, Content Controller shows a **Disable Configuration** modal:

> *Are you sure you want to disable this SSO configuration? Learners will be able to launch courses provided through Launcher links without being authenticated.*

If existing launcher links are enabled, the modal includes a **Disable Launcher links** checkbox, checked by default. When checked, all enabled launcher links are disabled at the same time as SSO, preventing unauthenticated access while SSO is disabled. Uncheck the box to leave launcher links enabled; they revert to the standard public configuration where anyone with the link can access the course.

Click **Disable** to confirm, or **Cancel** to keep SSO enabled.
