---
title: "Lead-in Page"
type: docs
menu:
    main:
        name: Lead-in Page
        identifier: lead-in-page
        parent: settings
        weight: 90
description: Exploring Lead-in Pages and how to configure within the UI.
---

# Lead-in Page

## What is a Lead-in Page?

Before the launch process, a customer-created and hosted web page is presented to the learner. This page serves as a starting point for their upcoming training and can be utilized in various ways, a few examples include:

* **Resources**: Offering valuable links to supporting documentation.
* **Branding**: Enabling brand recognition, building awareness, and lending credibility to the forthcoming content.
* **Data** **Collection**: Providing a means to collect information from the learner.
* **Learner** **Verification**: Validating who is about to access a lead-in page to ensure they have proper authority to do so.
* **Disclaimer**: Sharing an acknowledgment before the training begins.

While these are merely a few ideas, you have the flexibility to utilize the lead-in page according to your preferences, provided that you can create and host your desired web page.

{{< hint info >}}
Looking for more technical documentation? [Check out this article here](https://docs.contentcontroller.com/integration/features/lead-in-page/).
{{< /hint >}}

### What is supported?

Displaying a Lead-in Page as part of the launch process is supported for **Content**, **Equivalents**, **Bundled** **Content** and **Bundled** **Equivalents**. A lead-in page does _**not**_ support singular or Bundled RXD Content. The Lead-in Page is also _**no**t_ supported within the launch process for Launcher Links.

### Requirements

Before you can configure a Lead-In Page you must first build and host a basic HTML webpage. This new page must return to us once whatever action on the page has been completed. Here is an example of a basic page that supports this configuration:

```markup
<!DOCTYPE html>
<html>
​
<head>
   <title>Hello Friend - Sample Lead-in Page</title>
   <style>
       hr {
           margin: 15px 0px;
       }
   </style>
   <script>
       concedeToLaunch = function () {
       window.parent.postMessage({
           'message': ""
       }, "*");
}
   </script>
</head>
​
<body>
   <p>
       This is a sample landing page for a Lead-in Page.
   </p>
   <br>
   <input type="button" value="Return to Launch" onclick="concedeToLaunch();">
   <br>
</body>
</html>
```

Once created you then must decide whether this will be applied globally or to an individual account.

### Administration vs Account

You may use a Lead-in Page either at the Administrative (global) or the Account (individual) level. If set in the Administrative settings this will copy down to all accounts. However, you may choose to only apply to individual Accounts as well.

{{< hint info >}}
Both Administration and Account may be active at the same time. Meaning, while you may set a Lead-in Page for all accounts - this may be overridden at the account level.
{{< /hint >}}

## How to configure a Lead-in Page

To set a Lead-in Page at the Administration or Account level please follow the appropriate steps below.

### Administration Configuration

**Navigating to Administration Lead-in Page settings**

1. Click **Gear Icon** in the upper right corner and select Administration
2. Navigate to "**Settings**"
3. Select "**Launch**" on the left side
4. Expand the "**Lead-in Page**" accordion to see the options

**Configuring the Administration Lead-in Page**

1. First select the type of Endpoint used during the redirect
   1. **GET** | Simply displays the Lead-in Page
   2. **POST** | Attempts to send learner information ahead of displaying the Lead-in Page
2. Set your fully qualified **Endpoint URL**
3. Check "**Display Lead-in Page**" to enable and begin showing this page
4. Click "**Save**" button inside the accordion

{{< hint info >}}
If you chose **POST** as your Endpoint type you will also have the option for "**Don’t launch course if POST fails**". If Content Controller fails to post learner information to the Endpoint, this option will allow the course launch to fail. With this option checked, the course will not launch.
{{< /hint >}}

{{< img src="images/lead-in-page.png" alt="Lead-in page settings" >}}

### Account Configuration

**Navigating to Account Lead-in Page settings**

1. Go to **Accounts** in the top navigation bar
2. Click on the desired **Account** you wish to set
3. Navigate to **Advanced** tab
4. Click on the **Lead-in Page** in the left side navigation

{{< hint info >}}
If you have set the Lead-in Page at the **Administration** level the option “**Overwrite with Admin settings**” will be checked by default. If you wish to override at the **Account** level, uncheck that box to apply settings to an individual account.
{{< /hint >}}

**Configuring the Account Lead-in Page**

1. First select the type of Endpoint used during the redirect
   1. **GET** | Simply displays the Lead-in Page
   2. **POST** | Attempts to send learner information ahead of displaying the Lead-in Page
2. Set your fully qualified **Endpoint URL**
3. Check "**Display Lead-in Page**" to enable and begin showing this page
4. Click "**Save**" button inside the accordion

{{< hint info >}}
If you chose **POST** as your Endpoint type you will also have the option for ‘**Don’t launch course if POST fails**’. If Content Controller fails to post learner information to the Endpoint, this option will allow the course launch to fail. With this option checked, the course will not launch.
{{< /hint >}}

{{< hint info >}}
If you wish to **overwrite** the currently configured **Account settings** with what is set at the **Administration level**. Then simply check the “**Overwrite with Admin Settings**” checkbox. This will copy down those settings to the Account.
{{< /hint >}}

{{< img src="images/account-lead-in-page.png" alt="Lead-in page settings for an account in Content Controller" >}}

### What happens if I have both Admin and Account set?

When configuring a Lead-in Page in both Administration and Account settings, the Account configuration will take precedence over the Administration settings only if the 'Overwrite with Admin Settings' option is unchecked within the Account's advanced settings. Unchecking this box enables you to apply settings specifically for that individual account, regardless of any configurations made at the Administration level. Otherwise if the Overwrite with Admin settings is checked then it will inherit whatever is set in the Administration settings.
