---
title: "Add Multi-language Support with Equivalents"
type: docs
menu:
    main:
        name: Add Multi-language Support with Equivalents
        identifier: add-multi-language-support-with-equivalents
        parent: content
        weight: 40
---

# Add multi-language support with equivalents

{{< img src="images/equivalent-details.png" alt="Equivalent details" >}}

## **What is an equivalent?**

In addition to regular courses, Content Controller can deliver **equivalents** which are made up of regular courses with equivalent material presented in different languages.

Let's say you have a course that you offer in English, Spanish, and French. The equivalent allows you to package the English, Spanish, and French versions of the course as a single file that you can share with your client.

Equivalents can be shared with accounts exactly like regular courses, but when launched they present the learner with a menu of available languages. Selecting a language will deliver the regular course configured for that language.

## **How do equivalents work?**

A single file is shared with an account that your client will import and assign in their LMS just as they would any course. When the learner launches the course, Content Controller offers the course in the language based on the learner’s browser settings (if available). The learner will also see a drop-down menu of all language options available to choose their language preference. Content Controller serves the course in the selected language to the learner and the LMS only knows the course has been satisfied.

## **Create an equivalent**

{{< img src="images/add-language-equivalent.png" alt="Add language equivalent" >}}

1. Click **Add** in the Equivalents section. This will open a dialog with a field for the new equivalent's name and a button to add a language option to the equivalent.
2. Click **Add** **Language** to select a course and language to add to the equivalent. \
   You can search for a course by name or tag using the search tool. After selecting the course, use the Language drop-down at the bottom of the dialog to match the language to the course.
3. As you add multiple languages to the equivalent, they’ll appear in the list.
4. To remove a language, click the X icon.
5. To change which course a language maps to, click the pencil icon.
6. Click Save once you’ve finished selecting languages to create your new equivalent.

After the equivalent is created, it will appear in the equivalents list with its [details panel](https://docs.contentcontroller.com/user-guide/Content.html#equivalent-details) opened. You can add [courses with equivalents](https://support.scorm.com/hc/en-us/articles/210706786-Content-Controller-Adding-Courses-and-Equivalents-to-an-Account) to Accounts just like any other content.

{{< img src="images/equivalent-courses.png" alt="Click into the courses subsection to see which courses have been added to the equivalent." >}}

## **Viewing equivalent details**

Just like Course Details, clicking an equivalent in the list will open its details panel. You can change the equivalent name and its list of courses and languages by [clicking Edit](https://support.scorm.com/hc/en-us/articles/214123883-Content-Controller-Edit-Equivalent).

* **Equivalent name**
* **Created:** date and time that the equivalent was first added.
* **Modified:** date and time that the equivalent was last modified.
* **Location**

**Test:** use this to test the equivalent language selection page in your browser

**Deactivate:** deactivate the equivalent so it can’t be shared with accounts or accessed by learners

**Tags:** view, add, and remove tags from the equivalent. As with course tags, anywhere in Content Controller where you can search for an equivalent by name, you may instead search for equivalents with a particular tag.

**Usage:** same information about accounts, in-progress learners, and total learners as the [course details panel](../view-and-edit-course-details), but also has a breakdown of in-progress and total learners for each course in the equivalent.

**Courses:** a list of the courses and languages that make up the equivalent.

## **How to organize equivalents with folders**

Use folders in any section to [organize content](../organizing-content-with-folders).

## **Limiting Available Languages by Account**

By default, an **Equivalent** will display all of its configured language options to a learner. However, if a specific client (Account) only licenses a subset of those languages, you can restrict the available options at the **Account level** without having to create multiple versions of the same Equivalent.

### **How Account-level language filtering works**

When you enable this setting for an Account, Content Controller cross-references the languages within an Equivalent against the Account’s "Authorized" list.
It will then use that to present the wanted language options to the learner.

### **Restricting Authorized Languages**

{{< img src="images/equivalent-account-authorized.png" alt="Set Authorized Equivalents" >}}

To set an "Allow List" for a specific account:

1. Navigate to the **Accounts** section and select the desired Account.
2. Click on the **Advanced** tab in the top navigation bar.
3. Select **Equivalents** from the left-hand sidebar under *Advanced Settings*.
4. **Set the Default Language:** Use the dropdown to choose which language should be served if the learner's browser preference isn't authorized.
5. **Enable the Filter:** Check the box for **Enable Equivalent language selection**.
6. **Build your Authorized List:**
    * The **Available Languages** column shows all possible languages supported by your Content Controller instance.
    * Use the **arrow buttons** to move the specific languages you wish to authorize into the **Selected Languages** column.
    * *Note: You must select at least one language to save these settings.*
7. Click **Save**.

> **Important Note:** > This setting acts as a global filter for **all Equivalents** shared with this Account. If an Equivalent contains "French" but French is **not** in the Account's *Selected Languages* list, the French option will be hidden from those learners.

## **What if the language I need is not in the list?**

{{< img src="images/add-language.png" alt="Add language" >}}

You can manually add in any custom language right from within Content Controller.

1. In the top right of your Content Controller account, click the gear icon and go to Administration.
2. Choose the **Languages** tab in the navigation.
3. Then click **Add** to add new languages to Equivalents.
4. A modal will appear and you must enter the **IETF Language Tag**, **English & Localized display names**.
5. Click **Add Equivalent Language**.

The new language will now appear in the available languages list when creating or editing an Equivalent.
