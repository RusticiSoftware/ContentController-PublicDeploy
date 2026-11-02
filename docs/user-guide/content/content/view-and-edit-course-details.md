---
title: "View and Edit Course Details"
description: View and edit course details
type: docs
menu:
  main:
    name: "View and Edit Course Details"
    identifier: view-and-edit-course-details
    parent: content
    weight: 10
---

# View and edit course details

{{< img src="images/course-details.png" alt="Course details" >}}

To view and edit additional details about a course, select a course from your library to open the **Course Details** panel.

## Course details

At the top of the Course Details panel are 3 common actions you may want to perform on a course:

1. **Test**: testing the course and adjusting its configuration settings
2. **Version**: import a new version of the course
3. **Deactivate**: deactivate the course so it can no longer be shared or accessed by learners

The Details section contains the course’s metadata. The course name and description, along with the course's language are read from the course's manifest file at import time, and they can be edited by clicking **Edit**.

* **Course Name** (editable): the course’s name in Content Controller
* **Description** (editable): a short description of the course.
* **Created**: date and time that the course was first added to Content Controller
* **Modified**: date and time that the course was last modified
* **Published Version**: the [version](using-version-control.md) that is delivered when a learner launches the course (think of this as the "active" version of the course)
* **Uploaded File Name**: the original filename that was uploaded for the published version of the course
* **Language** (editable): primary language of the course's learning content
* **Standard**: learning standard to which the course conforms
* **Location**: where the file is currently located in the **Content** area. Home is the default area.
* **Create a Preview Link:** use this to generate a preview link to the course for internal testing and debugging.

1. **Test**: test the course and adjust configuration settings.
2. **Version**: import a new version of the course.
3. **Deactivate**: deactivate the course so it can no longer be shared or accessed by learners.

## Tags

[Adding tags](https://support.scorm.com/hc/en-us/articles/115003178073-Content-Controller-Tagging) to courses make it easy to categorize, search for, and find that content later on. Anywhere in Content Controller where you can search for a course by name, you may search for courses with a particular tag. This includes searching the courses list, [sharing content with an account](https://docs.contentcontroller.com/user-guide/Sharing.html), and selecting a course for a [report](https://docs.contentcontroller.com/user-guide/Reports.html).

How to use tags:

1. Click on the **Tags** section to expand, revealing more.
2. Click into the **Add a tag** box, type the desired tag name, and then press **Enter**.
3. As you type, previously-used tags added to other courses will auto-populate.
4. Tag names must be between 3 and 25 characters long.
5. To remove a tag from a course, click the "x" to the right of the tag's name.

## Versions

[Versions](using-version-control.md) is a list of all versions of a course that have been imported into Content Controller. The published version of the course (i.e., the “active” version delivered to learners) is highlighted in blue. The list includes version IDs, creation dates, the number of in-progress learners, and the total number of learners who have launched each version. Clicking the ellipsis ("...") on the right side of a row will open a drop-down menu with actions that can be done with that version.

## Usage

* **Accounts**: number of accounts the course has been shared with. Click the number to see the list of accounts with the number of learners for each.
* **In-Progress Learners**: number of learners who have launched the course, but have not yet completed, passed, or failed. Click the number to see a breakdown of in-progress learners by account. Note: This number does not include learners who launched the course as part of an [equivalent](add-multi-language-support-with-equivalents.md).
* **Total Learners**: the number of learners who have launched the course excluding those who launched it as part of an [equivalent](add-multi-language-support-with-equivalents.md). Click the number to see a breakdown of learners by account (just like clicking the number of accounts).
* **Equivalents**: the number of equivalents that the course is a part of. Click the number to see the list of equivalents, with the number of learners who have taken the course as part of each. This item is only visible if the course has been added to an equivalent.

## Deactivating a course

Deactivating a course means that the course can no longer be shared or accessed by learners. A deactivated course can be reactivated at any time using the [_Course Details_](https://support.scorm.com/hc/en-us/articles/212148443-Content-Controller-Course-Details-View) panel.

#### How to deactivate a course

1. Click on the course to see the Course Details panel.
2. Click **Deactivate** in the top right and click **Deactivate** once more in the pop-up window.

#### How to reactivate a course

1. Open Content to see your main course list.
2. Switch the list view from "Active" to "Inactive" to show your inactive (deactivated) courses.
3. Click the course you'd like to reactivate to open its Course Details panel.
4. Click **Activate** and then click the **Activate** button in the pop-up window.
