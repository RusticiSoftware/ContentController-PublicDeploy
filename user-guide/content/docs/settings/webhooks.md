---
description: Exploring Webhooks and how to Configure them within the UI.
---

# Webhooks

## What is a Webhook?

When a specific event occurs in your instance of Content Controller. Automatically notify your system with all relevant information.&#x20;

### Available Webhooks

We offer a variety of webhooks to utilize. Below are each **topic** and the **subtopics** within.

* #### Account
  * Created | A new account was created.
  * Deleted | An account was deleted.
  * Activation Updated | The active status of the account was updated.
* #### Account Content
  * Course/equivalent/bundle added to account | A piece of content was added to an account.
  * Course/equivalent/bundle removed from account | A piece of content was removed from an account.&#x20;
* #### Course
  * Imported | A course was imported.
  * Version uploaded | A new course version was created.&#x20;
  * Version published | A course version was published.&#x20;
* #### Registration
  * Registration launched | A course has been launched by a learner.
  * Registration changed | A course registration has changed completion status or overall score.

{% hint style="info" %}
Looking for more technical documentation? [Check out this article here](https://docs.contentcontroller.com/integration/features/webhooks/).
{% endhint %}

## Configuring Webhooks

To view an existing or configure a new webhook please follow these steps.&#x20;

### Navigating to the Webhooks Page

1. Click the **Gear** **Icon** in the upper right corner and select **Administration**.
2. Navigate to the **Integrations** tab.
3. Select "**Webhooks**" on the left side navigation.

### Adding a new Webhook

#### Step 1 | Initial Setup

1. While on the Webhooks listing page. Click on the **+ Add button** in the top right of the page.
2. Enter a **Name** to help describe the webhook.
3. Enter a fully qualified URL endpoint to receive the webhook messages.
4. (Optionally) Set the **Key** & **Secret** if authentication is required to access the endpoint.
5. Select your **Topic** which is the main class of events for which you want to receive notifications. Reference [the list of webhooks](https://app.gitbook.com/o/-LBR0jy9jG8AjotkLnQm/s/-Lu-ZWvY7BC8vS5I6doj/~/changes/30/settings/webhooks#available-webhooks) above to better understand your required topic.
6. (Optionally) Select your **Focus** to better narrow down the topic to only get notifications for specific resources.&#x20;
7. Set **Active** status (this defaults to active). In some situations you may desire the webhook to be ‘off’ while you prepare things. &#x20;
8. Click on Next

<figure><img src="../.gitbook/assets/Webhook Create 1 (1).png" alt=""><figcaption><p>Initial Setup step when configuring a webhook.</p></figcaption></figure>

#### Step 2 | Accounts (if applicable)

9. If chosen as a Focus. Make your selection for **Account(s)** that this webhook will apply to.

#### Step 3 | Content (if applicable)

10. If chosen as a Focus. Make your selection for **Content** that this webhook will apply to.

#### Step 4 | Subtopics

11. Select all subtopics that apply. By default all will be selected. These offer the more granular choice of event types that trigger for the webhook.

<figure><img src="../.gitbook/assets/image (4).png" alt=""><figcaption><p>Available Subtopics to trigger a webhook.</p></figcaption></figure>

#### Step 5 | Summary

12. Here you are given a overview of the webhook that will be created. Once reviewed click on the **Create** button to complete the setup. The new webhook will appear on the listing page.

<figure><img src="../.gitbook/assets/image (5).png" alt=""><figcaption><p>Review the new webhook configuration.</p></figcaption></figure>

<figure><img src="../.gitbook/assets/image (6).png" alt=""><figcaption><p> An example of a newly created webhook.</p></figcaption></figure>

### Editing a Webhook

To edit a webhook simply click on the desired item in the list view. Then click on the Edit button. This will bring up a modified version of the creation wizard where you may make your changes. Please ensure that you follow the wizard to the end and select **Save**.&#x20;

<figure><img src="https://lh7-us.googleusercontent.com/SjFFb5jVwnjNPQOk1Es8Xmwvb2rzsbrfOjgrVbL7OfFeDyE7I6ajrOMoF0nplWz8TIhpavI01-b7KTjlw6qEL3-vj2AMmp623VRmXBtfl5LbJGL4HX7-ncf-1Y1PyZkgUtyiuNvdysC8C3SVHs-MsX8" alt=""><figcaption><p>Editing a webhook</p></figcaption></figure>

### Deactivating a Webhook

If you wish to Deactivate (to turn off) a webhook. Simply Click on the desired webhook on the listing page and select the “Deactivate” option at the top of the edit panel. Then confirm the presented modal.&#x20;

<figure><img src="https://lh7-us.googleusercontent.com/knnIGELzdjEVJJRBLJc_pEACP14owWjDTM38XV3yeg2MghTZOXW89Bjn4yRD8xT0jF8GfS7LaPP9p3QGnFzV1DaHuCeql5_zSHpw7H8R40RYhN9dL9M-05pksBq4Tx4tA25mLiB3lL4QY62qee_CN_8" alt=""><figcaption><p>Deactivation</p></figcaption></figure>

<figure><img src="https://lh7-us.googleusercontent.com/Ywgeh1CWOFH92oajEeAXwlDdVASMM7mOswPJQa-4dNJZABppkUwtQ9UkBNes6Xrz2aeBA418iwFvr2SkS_G63o6LXFIzuY5T_xkAhVa1xS7KVmV-BpPKfIWBDtVqAZz4HjZZrOdr7LxS0SDi_TYySOk" alt=""><figcaption><p>Confirming deactivation</p></figcaption></figure>

### Deleting a Webhook

To delete a webhook it must first be Deactivated (see above). Once a webhook has been deactivated a new Delete Webhook option will appear. Clicking this will once again prompt a modal, confirm deletion.&#x20;

{% hint style="danger" %}
<mark style="color:red;">**Important**</mark> <mark style="color:red;">**Notice**</mark><mark style="color:red;">: This will completely remove the webhook from your instance of Content Controller and cannot be recovered.</mark>
{% endhint %}

<figure><img src="https://lh7-us.googleusercontent.com/jgVQuCJZod-JCqNmInbKaT4A_711umFzX2QfuM2qbmUaMVLQG954nNzY8feea8Iqgcp8hzUIE8o__P5zqiUDNusdnAhp-ROswUxeJm0U96UWhLVBjqgbaRHaR4bzPWsj0EBqlRcDbMVMZiF4cgDsBJY" alt=""><figcaption></figcaption></figure>

<figure><img src="https://lh7-us.googleusercontent.com/ULpcNJhnOrA2tCSbhLuVDuz6m0ttXc1h4ObtXsRIa7RckAD-FclEaoq-QckUEA4MMwxGgiiM7JEU_mbTCrYT1M7hGN_QoPs0PVnH0k4EiF9RBHqOqH6s_OcdUujOOmfwFsQTDAqeayjxLp2TOH86D_M" alt=""><figcaption></figcaption></figure>

### Viewing an Inactive Webhook

When a webhook is deactivated. It will disappear from the Active list of webhooks. To find any inactivated webhooks you must select the filter drop down at the top of the listing page.&#x20;

\


<figure><img src="https://lh7-us.googleusercontent.com/bQ8Yko8td886ppKXs3cYOiSAHvVIgAkKqsofJvHgr90qR07EstnqxN3orinGbM_tc4-BzAci7jgwoGcmVeEoXr25xHMGThewKL0-3lryBs6Zm8etN-dbhxHU4_EFvFI_fuuuuPffWaZ_nsRdigvFEiQ" alt=""><figcaption></figcaption></figure>

### Troubleshooting Webhooks

If there ever is an issue with your webhook. We will attempt to communicate with an Alert on the webhook listing page in the Content Controller application itself. A hazard icon will be displayed next to the webhook in question. By clicking on said webhook we will attempt to describe what is causing the error in the details panel. This will be noted in a gold encapsulated message. This message is crafted based on the error code we receive from the customer system.&#x20;

<figure><img src="https://lh7-us.googleusercontent.com/YLYYhBsG-5aoGxCjNdvknmIND_6Yt2Aacz5-8wmE6V1IO5SbZKHdcWdQ2R2amc46vYhu5aCetJpiRLGthIeJqsf71erIf4qI9viWEACDcdoafQfuK0KJKk1oZXFBabF0E6SMgiv5bRnG0Zv0o2vlHz4" alt=""><figcaption></figcaption></figure>
