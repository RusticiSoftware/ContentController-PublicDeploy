---
title: "Adding a Course (4.1 or earlier)"
type: docs
menu:
  main:
    name: "Adding a Course (4.1 or earlier)"
    identifier: add-a-course-4.1
    parent: getting-started
    weight: 20
---

# Adding a course (4.1 or earlier)

{{< hint warning >}}
Need to upload more than one course? See the [Adding Courses (4.2 or later)](../add-a-course-4.2/) article. Requires version 4.2 or higher.
{{< /hint >}}

## Here's how to import a course into Content Controller

There are two methods for sharing content from Content Controller. The most common method is simply by Course authored in an eLearning standard (or supported media file). While alternatively through something called Rustici Cross Domain (RXD) for when content must remain on your servers.

### Importing a Course

In order to share your content it needs to first be uploaded into Content Controller.

1. Choose the ***Content*** tab and click the **+ ADD** button in the top right corner.
2. When clicking the **+ ADD** from previous step you will be presented with two options to choose between: adding a **Course** or [**Folder**](/docs/content/organizing-content-with-folders/). We are looking to add a **Course** so choose this option.
3. This will open a pop-up with two tabs: one for uploading a packaged course .zip file, such as you would publish from an authoring tool and another for the server-side courses via Rustici Cross Domain. We are focused on adding a Course so stay on the **Add** **Course** tab.
4. Click **Browse** to locate and select the packaged course .zip file or media file to upload.
5. After you have selected the file, click **Import Course**

If the import process is successful, the newly added course will appear in the main Courses list with its [Course Details](/docs/content/view-and-edit-course-details) opened.

{{< img src="images/course-imported.png" alt="Course imported successfully" >}}

{{< hint info >}}
For more information on **Folders** see the article [Organizing Content with Folders](/docs/content/organizing-content-with-folders "mention")
{{< /hint >}}

{{< hint success >}}
Content Controller supports the following content types:

* SCORM 1.2
* SCORM 2004 (2nd, 3rd, & 4th editions)
* xAPI
* AICC
* cmi5
* PDF (Added in v3.0)
* MP4 (Added in v3.0)
* MP3 (Added in v3.1)
{{< /hint >}}

### Importing using Rustici Cross Domain

{{< img src="images/import-with-rxd.png" alt="Import with RXD" >}}

Rustici Cross Domain is useful when content must remain on your own servers, but you need to share it with learners through an LMS. We've added Cross Domain import functionality into Content Controller so that you can add that server-side content into Content Controller.

With Rustici Cross Domain, you can deliver your non-standard web experience as SCORM 1.2, SCORM 2004 3rd Edition, AICC, xAPI, cmi5 or share via LTI to your LMS.

1. Click **Rustici Cross Domain (RXD) Import** from the Add Course window.
2. Fill out **Course Name**, **Course URL** (where it lives on your server), and the **Rustici Cross Domain (RXD) Remote API URL**.
3. Click **Import Course.**

{{< hint info >}}
For more detailed information on using RXD to launch content on your own servers, see [the integration guide](https://docs.contentcontroller.com/integration/features/rxd-cc/).
{{< /hint >}}

{{< hint info >}}
If you need more help, our knowledge base covers [importing courses](https://support.scorm.com/hc/en-us/articles/210611906-Content-Controller-Import-a-Course) including importing RXD content in more detailed steps.
{{< /hint >}}