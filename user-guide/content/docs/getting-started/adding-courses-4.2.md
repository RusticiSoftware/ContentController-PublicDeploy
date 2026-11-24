---
title: "Adding Courses (4.2 or later)"
type: docs
menu:
  main:
    name: "Adding Courses (4.2 or later)"
    identifier: adding-courses-4.2
    parent: getting-started
    weight: 30
---

# Adding courses (4.2 or later)

{{< hint warning >}}
This article details the new course upload process introduced in Content Controller version 4.2 and later.
{{< /hint >}}

## Here's how to import courses into Content Controller

There are two methods for sharing content from Content Controller. The most common method is simply by Course authored in an eLearning standard (or supported media file). While alternatively through something called Rustici Cross Domain (RXD) for when content must remain on your servers.

### Importing Courses

In order to share your content it needs to first be uploaded into Content Controller.

1. Choose the **Content** tab and click the **+ ADD** button in the top right corner.
2. When clicking the **+ ADD** from previous step you will be presented with two options to choose between: adding **Courses** or [**Folder**](/docs/content/organizing-content-with-folders/). We are looking to adding **Courses** so choose this option.

{{< img src="images/add-courses.png" alt="Add courses" >}}

3. This opens a Course staging area for uploading content. Additionally, there will be a navigation tab for Add RXD (Rustici cross domain) and Upload history. We are focused on adding new courses so stay on the “**Add Course**” tab.
4. Here you will be presented with various options. Starting from the top:

{{< img src="images/add-course-options.png" alt="Add course options" >}}

* **Automatically generate ID** - Unchecking this will present a new input field for each course added allowing you to set your own ID. We recommend ignoring this unless you specifically want to set a unique ID per course.
* **Drag and drop files here** - this area is where you can drag and drop supported files onto or click to browse, in which case you may also select one or more files at a time.
* **Apply Tagging** - Here you can add tags for all content added to the staging area. Alternatively you can uncheck the box to expose a tagging input box for each course listed, if you need courses to have different tags.'

5. Add courses by dropping into the Drag and drop area or by selecting via the browse button.
6. When files have been added to the staging area. You’ve applied IDs (optional) or Tags (optional) and are ready to upload. Simply click the **Upload** button.
   1. **Note**: if you need to remove a course, click the circle with the X icon to remove.

{{< img src="images/staged-files.png" alt="Staged files" >}}

7. The files will begin uploading, once completed you will be dropped onto the **results pag**e.

{{< img src="images/upload-results.png" alt="Upload results" >}}

The results page will show all uploaded content and if it was successful or not. On this page you have some options before you finish.

* You can add tags now if you did not on the previous step.
* Clicking the **Edit** button will present all details for a give course, allowing you to make edits here.
* If content failed to upload, you will be give another opportunity to retry on this page or review any errors.

Now click **Return to content** to be brought back to your library where you may find your newly added courses.

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

### Importing using Rustici Cross Domain (RXD)

{{< img src="images/import-with-rxd.png" alt="Import with RXD" >}}

Rustici Cross Domain is useful when content must remain on your own servers, but you need to share it with learners through an LMS. We've added Cross Domain import functionality into Content Controller so that you can add that server-side content into Content Controller.

With Rustici Cross Domain, you can deliver your non-standard web experience as SCORM 1.2, SCORM 2004 3rd Edition, AICC, xAPI, cmi5 or share via LTI to your LMS.

1. Click **+** **Add > Courses** and then the **Add RXD** tab at the top

{{< img src="images/add-rxd.png" alt="Add RXD courses" >}}

2. Here you will be presented with similar options to the Add Course page shown above.
3. Click the **Add** button to insert RXD configuration input boxes.
   1. **Note**: you can click add many times if you are configuring more than one.

{{< img src="images/config-rxd.png" alt="RXD course configuration" >}}

4. Fill out Course Name, Course URL (where it lives on your server), and the Rustici Cross Domain (RXD) Remote API URL.
5. **Note**: if you click “**? More Info**" this will give you an example and further information.
6. Click **Upload.**

{{< hint info >}}
For more detailed information on using RXD to launch content on your own servers, see [the integration guide](https://docs.contentcontroller.com/integration/features/rxd-cc/).
{{< /hint >}}
