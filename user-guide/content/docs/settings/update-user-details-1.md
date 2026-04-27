# Display (custom) IDs

## What are Display IDs?

Replace the automatically generated ID created by Content Controller for **Accounts**, **Content**, **Equivalents** and **Bundles** with your own Display (also known as custom) ID. These IDs can be used for searching, reporting and audit logs or interacted with via the API.&#x20;

{% hint style="warning" %}
If you are integrated in any way with Content Controller or utilize the Automation API. Please make sure to check with your Manager or Engineering team before changing an ID.&#x20;
{% endhint %}

### Some things to keep in mind

Before working with these custom IDs there are a few limitations to be aware of.

* The IDs must be unique
* They cannot be more than 1000 characters
* And they cannot contain any of the following: &$+,/:;=?@# <>\[]{}|^%

### Setting & editing IDs

To set a custom ID this can be done via the API or the UI. Within the UI, you have the option of applying an ID when importing a course or from the details panel for those already in your library. Similarly, this applies to Accounts, Equivalents and Bundles.

#### During content import&#x20;

1. Navigate to the **Content** section&#x20;
2. Click the **+ Add** button then select the Course option.&#x20;
3. Here you will see a checkbox “**Automatically generate ID**” selected. Uncheck this box to present a new text field where an ID may be set.&#x20;
4. Enter your ID and upload the course as normal.&#x20;

<figure><img src="../.gitbook/assets/image (20).png" alt=""><figcaption></figcaption></figure>

{% hint style="info" %}
The same steps above also apply when creating an **Equivalent** or **Bundle**.
{% endhint %}

#### Editing existing content&#x20;

1. Navigate to the **Content**, **Equivalent** or **Bundle** areas&#x20;
2. Select the desired course by clicking on it&#x20;
3. In the details panel that appears, click the **Edit** button under the Details title section.&#x20;
4. Here you may edit the ID and save as normal.

<figure><img src="../.gitbook/assets/image (21).png" alt=""><figcaption></figcaption></figure>

#### During account creation

1. Navigate to the **Account** section&#x20;
2. Click the **+ Add** button to create a new account&#x20;
3. Here you will see a checkbox “**Automatically generate ID**” selected. Uncheck this box to present a new text field where an ID may be set.&#x20;
4. Enter your ID and create the account as normal.

<figure><img src="../.gitbook/assets/image (22).png" alt=""><figcaption></figcaption></figure>

#### Editing an existing account

1. Navigate to the **Account** section&#x20;
2. Select the account you wish to assign an ID to&#x20;
3. On the account dashboard you will see the ID near the bottom as shown in the screenshot.&#x20;
4. Click **Edit** and uncheck the **automatically assign ID checkbox**. Enter your ID and save the account as normal.

<figure><img src="../.gitbook/assets/image (24).png" alt=""><figcaption></figcaption></figure>

<figure><img src="../.gitbook/assets/image (25).png" alt=""><figcaption></figcaption></figure>

### Using and viewing IDs

#### Searching

When searching on the appropriate pages within Content Controller. You may preface your search with **id:** followed by the ID to find the desired course. <mark style="color:green;">Example id: RD5896521485</mark> notice how the search icon changes to a key.

<figure><img src="../.gitbook/assets/image (26).png" alt=""><figcaption></figcaption></figure>

#### List views

IDs will now appear on the appropriate pages with a list view for Content, Equivalents, Bundles as well as the Accounts dashboard.&#x20;

<figure><img src="../.gitbook/assets/image (27).png" alt=""><figcaption></figcaption></figure>

{% hint style="info" %}
Anywhere an ID would normally appear in reports a new <mark style="color:green;">displayid</mark> will be added.
{% endhint %}



