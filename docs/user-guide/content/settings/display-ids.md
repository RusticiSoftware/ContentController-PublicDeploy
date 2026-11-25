---
title: "Display (Custom) IDs"
type: docs
menu:
    main:
        name: Display (Custom) IDs
        identifier: display-ids
        parent: settings
        weight: 20
---

# Display (custom) IDs

## What are Display IDs?

Replace the automatically generated ID created by Content Controller for **Accounts**, **Content**, **Equivalents** and **Bundles** with your own Display (also known as custom) ID. These IDs can be used for searching, reporting and audit logs or interacted with via the API.

{{< hint warning >}}
If you are integrated in any way with Content Controller or utilize the Automation API. Please make sure to check with your Manager or Engineering team before changing an ID.
{{< /hint >}}

### Some things to keep in mind

Before working with these custom IDs there are a few limitations to be aware of.

* The IDs must be unique
* They cannot be more than 1000 characters
* And they cannot contain any of the following: &$+,/:;=?@# <>\[]{}|^%

### Setting & editing IDs

To set a custom ID this can be done via the API or the UI. Within the UI, you have the option of applying an ID when importing a course or from the details panel for those already in your library. Similarly, this applies to Accounts, Equivalents and Bundles.

**During content import**

1. Navigate to the **Content** section
2. Click the **+ Add** button then select the Course option.
3. Here you will see a checkbox “**Automatically generate ID**” selected. Uncheck this box to present a new text field where an ID may be set.
4. Enter your ID and upload the course as normal.

{{< img src="images/add-custom-course-id.png" alt="Adding a custom ID for a course" >}}

{{< hint info >}}
The same steps above also apply when creating an **Equivalent** or **Bundle**.
{{< /hint >}}

**Editing existing content**

1. Navigate to the **Content**, **Equivalent** or **Bundle** areas
2. Select the desired course by clicking on it
3. In the details panel that appears, click the **Edit** button under the Details title section.
4. Here you may edit the ID and save as normal.

{{< img src="images/edit-course-add-custom-id.png" alt="Editing a pre-existing course to add a custom ID" >}}

**During account creation**

1. Navigate to the **Account** section
2. Click the **+ Add** button to create a new account
3. Here you will see a checkbox “**Automatically generate ID**” selected. Uncheck this box to present a new text field where an ID may be set.
4. Enter your ID and create the account as normal.

{{< img src="images/create-custom-account-id.png" alt="Creating a custom ID for an account at creation" >}}

**Editing an existing account**

1. Navigate to the **Account** section
2. Select the account you wish to assign an ID to
3. On the account dashboard you will see the ID near the bottom as shown in the screenshot.
4. Click **Edit** and uncheck the **automatically assign ID checkbox**. Enter your ID and save the account as normal.

{{< img src="images/edit-account-details.png" alt="Where to find an account's current ID and open the Edit menu" >}}

{{< img src="images/edit-account-add-custom-id.png" alt="Add a custom ID to an already existing account" >}}

### Using and viewing IDs

**Searching**

When searching on the appropriate pages within Content Controller. You may preface your search with **id:** followed by the ID to find the desired course. <mark style="color:green;">Example id: RD5896521485</mark> notice how the search icon changes to a key.

{{< img src="images/search-custom-course-id.png" alt="Searching Content Controller using a custom course ID" >}}

**List views**

IDs will now appear on the appropriate pages with a list view for Content, Equivalents, Bundles as well as the Accounts dashboard.

{{< img src="images/course-list-with-course-ids.png" alt="A list of courses in Content Controller with their Course IDs" >}}

{{< hint info >}}
Anywhere an ID would normally appear in reports a new <mark style="color:green;">displayid</mark> will be added.
{{< /hint >}}



