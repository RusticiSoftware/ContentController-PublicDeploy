---
title: "Webhooks"
type: docs
menu:
    main:
        name: Webhooks
        identifier: webhooks
        parent: integrations
        weight: 30
description: Exploring Webhooks and how to Configure them within the UI.
---

# Webhooks

## What is a Webhook?

When a specific event occurs in your instance of Content Controller. Automatically notify your system with all relevant information.

### Available Webhooks

We offer a variety of webhooks to utilize. Below are each **topic** and the **subtopics** within.

* **Account**
  * Created | A new account was created.
  * Deleted | An account was deleted.
  * Activation Updated | The active status of the account was updated.
* **Account Content**
  * Course/equivalent/bundle added to account | A piece of content was added to an account.
  * Course/equivalent/bundle removed from account | A piece of content was removed from an account.
* **Course**
  * Imported | A course was imported.
  * Version uploaded | A new course version was created.
  * Version published | A course version was published.
* **Registration**
  * Registration launched | A course has been launched by a learner.
  * Registration changed | A course registration has changed completion status or overall score.

{{< hint info >}}
Looking for more technical documentation? [Check out this article here](https://docs.contentcontroller.com/integration/features/webhooks/).
{{< /hint >}}

## Configuring Webhooks

To view an existing or configure a new webhook please follow these steps.

### Navigating to the Webhooks Page

1. Click the **Gear** **Icon** in the upper right corner and select **Administration**.
2. Navigate to the **Integrations** tab.
3. Select "**Webhooks**" on the left side navigation.

### Adding a new Webhook

**Step 1 | Initial Setup**

1. While on the Webhooks listing page. Click on the **+ Add button** in the top right of the page.
2. Enter a **Name** to help describe the webhook.
3. Enter a fully qualified URL endpoint to receive the webhook messages.
4. (Optionally) Set the **Key** & **Secret** if authentication is required to access the endpoint.
5. Select your **Topic** which is the main class of events for which you want to receive notifications. Reference [the list of webhooks](#available-webhooks) above to better understand your required topic.
6. (Optionally) Select your **Focus** to better narrow down the topic to only get notifications for specific resources.
7. Set **Active** status (this defaults to active). In some situations you may desire the webhook to be ‘off’ while you prepare things.
8. Click on Next

{{< img src="images/add-new-webhook.png" alt="Configuration for a new webhook" >}}

**Step 2 | Accounts (if applicable)**

9. If chosen as a Focus. Make your selection for **Account(s)** that this webhook will apply to.

**Step 3 | Content (if applicable)**

10. If chosen as a Focus. Make your selection for **Content** that this webhook will apply to.

**Step 4 | Subtopics**

11. Select all subtopics that apply. By default all will be selected. These offer the more granular choice of event types that trigger for the webhook.

{{< img src="images/webhook-subtopics.png" alt="Webhook subtopics" >}}

**Step 5 | Summary**

12. Here you are given a overview of the webhook that will be created. Once reviewed click on the **Create** button to complete the setup. The new webhook will appear on the listing page.

{{< img src="images/webhook-config-summary.png" alt="Webhook configuration summary" >}}

{{< img src="images/webhook-list.png" alt="A list of webhooks in Content Controller" >}}

### Editing a Webhook

To edit a webhook simply click on the desired item in the list view. Then click on the Edit button. This will bring up a modified version of the creation wizard where you may make your changes. Please ensure that you follow the wizard to the end and select **Save**.

{{< img src="images/edit-webhook.png" alt="Editing a webhook" >}}

### Deactivating a Webhook

If you wish to Deactivate (to turn off) a webhook. Simply Click on the desired webhook on the listing page and select the “Deactivate” option at the top of the edit panel. Then confirm the presented modal.

{{< img src="images/deactivate-webhook.png" alt="Deactivating a webhook" >}}

{{< img src="images/deactivate-webhook-confirmation.png" alt="Confirmation window for deactivating a webhook" >}}

### Deleting a Webhook

To delete a webhook it must first be Deactivated (see above). Once a webhook has been deactivated a new Delete Webhook option will appear. Clicking this will once again prompt a modal, confirm deletion.

{{< hint danger >}}
<mark style="color:red;">**Important**</mark> <mark style="color:red;">**Notice**</mark><mark style="color:red;">: This will completely remove the webhook from your instance of Content Controller and cannot be recovered.</mark>
{{< /hint >}}

{{< img src="images/delete-webhook.png" alt="Deleting a webhook" >}}

{{< img src="images/delete-webhook-confirmation.png" alt="Confirmation window for deleting a webhook" >}}

### Viewing an Inactive Webhook

When a webhook is deactivated. It will disappear from the Active list of webhooks. To find any inactivated webhooks you must select the filter drop down at the top of the listing page.

{{< img src="images/show-inactive-webhooks.png" alt="List of inactive webhooks available through the Showing dropdown" >}}

### Troubleshooting Webhooks

If there ever is an issue with your webhook. We will attempt to communicate with an Alert on the webhook listing page in the Content Controller application itself. A hazard icon will be displayed next to the webhook in question. By clicking on said webhook we will attempt to describe what is causing the error in the details panel. This will be noted in a gold encapsulated message. This message is crafted based on the error code we receive from the customer system.&#x20;

{{< img src="images/webhook-error.png" alt="Webhook details pane with an error message" >}}
