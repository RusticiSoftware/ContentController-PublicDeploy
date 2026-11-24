---
title: "Testing Course Content and Debugging"
type: docs
menu:
    main:
        name: Testing Course Content and Debugging
        identifier: testing-course-content-and-debugging
        parent: content
        weight: 60
---

# Testing course content and debugging

Built into Content Controller is a testing sandbox environment that lets you test, troubleshoot, and configure your content before sharing it with your accounts and learners.

This is useful for a variety of reasons, like simply previewing a course before sharing with an account, making sure completion and score data are reporting properly, and configuring certain settings to improve interoperability with LMSs.

To access the testing section, open a course’s Details panel and click **Test** in the top left.

## **Test & Configure**

{{< img src="images/test-and-configure.png" alt="Test and configure" >}}

### **Testing your content**

{{< img src="images/test-your-content.png" alt="Test your content" >}}

Testing your content is one of the most valuable features inside Content Controller. Using the built-in testing sandbox, you can launch and test your content repeatedly, as well as adjust the course’s configuration settings. If your content doesn’t work in Content Controller, it likely is not going to work in your LMS, either. To test your content:

1. Navigate to the **Content** section
2. Click on the desired Content
3. In the Course Details panel, click on the **Test** button in the top of this area.


### **Configuration Settings**

Configuration settings allow you to direct how your courses will play in a learner’s LMS. Some tweaks to Course Properties improve how the course runs while others allow you to customize the learner experience. When you import a course, Content Controller makes some educated guesses on what properties make the most sense for your course and has dozens of Course Property combinations that allow you to truly customize how your course plays and appears to your learner.

* **Navigation Controls:** settings that change how the course’s navigation will display
* **Launch Behavior:** adjust how the course displays and launches for learners
* **Advanced:** advanced compatibility settings
* **Metadata Overlay:** add additional values to the courses meta data
* **Reset progress:** resets the course progress in the testing environment

## **Debug Logs**

{{< img src="images/debug-logs.png" alt="Debug logs" >}}

### **What are debug logs?**

Debug logs are system-generated logs that track every single event and operation that occurs when a course is launched. There’s a lot going on behind the scenes when you launch your course, so debug logs show you what’s going on and make it easy for you (or our support team) to pinpoint issues. In most cases, you won’t need to look at the debug log, but it’s there to use if something goes wrong with your course.

Debug logs are stored for each test you do in Content Controller. Each log is stored for 30 days, though you can click Clear Logs to delete all logs sooner if desired.

### **Sharing debug logs**

Debug logs can also be shared. Click the Share button on the right to generate a public URL that can be shared.

{{< hint info >}}
Need more help with [testing and debugging](https://support.scorm.com/hc/en-us/articles/114094529633-Content-Controller-Testing-Content-Debug-Logs)? Head over to our knowledge base for more details on reading, storing and clearing debug logs.
{{< /hint >}}
