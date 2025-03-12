---
title: "CC Launcher Links"
type: docs
menu:
    main:
        name: CC Launcher Links
        identifier: launcher_links
        parent: features
        weight: 5
---

# CC Launcher

## How It Works
Launcher Links allow content to be shared via a URL link without the use of an LMS. When a user shares the URL link the 
hosted package makes a call back to their Content Controller instance. The Rustici SCORM Adapter within CC builds a 
request url that calls the launch API. The launch API verifies that the package token is associated with the content 
token. Upon verification, it returns the relevant dispatch information needed to fill out the template dispatch within 
the hosted package. The Rustici SCORM Adapter will then start the content in the player.

## How To Use A Launcher Link
This documentation will cover using a launcher link to successfully play a course. For the sake of brevity the UI 
instructions are included here. Check [Content Controller Automation API](https://docs.contentcontroller.com/automation-api/v1/) 
for the API calls. The flow will be similar, if not the same, as the UI use case. The major area where the UI and API 
use cases will overlap is setting up the launcher link package on a web server environment.

### Enable The Feature
This feature is an additional feature that is not included in the base Content Controller. Contact a really cool sales 
person to find out how to add this feature to your instance of Content Controller.

### Create A Launcher Link Package
The launcher link package contains the content player. This is the web application the you need to host on your server. 
Each account can create launcher link packages. The package is based on Rustici SCORM Adapter; an LMS adapter that 
allows SCORM content to be played. The package structure needs to be maintained when it is unzipped. Everything in the 
unzipped package must be web-accessible relative to `index.html`.

To create a launcher link package in the UI, go to the Launcher Link option under an account's Advanced settings then 
select "Add". Enter a name for the package and the URL where the package will be hosted (this includes the package name). 
Select "Add Link".

Once the launcher link package is created it can be disabled, enabled, or deleted. In order to delete the package it 
must be disabled first.

### Host The Package
Unzip the package on your web server. As mentioned earlier, make sure to leave the package structure as-is. There are a 
couple items in `config.js` that can be customized. Currently, these are `studentId` and `studentName`. The template 
`config.js` includes an example of how to generate a UUID as the learner ID for each time the content is accessed.

### Share Content With A Launcher Link
We currently support sharing individual pieces of content. For instance, an individual course within a bundle can be 
shared but not the whole bundle. Sharing content is as simple as selecting share on the content and finding the launcher
link package name in the drop-down. Then select "Get Link". The URL that shows up is the launcher link URL meant to be 
shared with whomever is allowed to take the course. It has a unique token that identifies which course the hosted player
should play.

### Items Of Note
* The dispatch offering up the content can still be limited by licensing and course deactivation.
* Access to the content can be removed by disabling the launcher link package. This is in addition to the more 
  traditional CC methods.
* In the package, `index.html` contains the package token, `ccPackageToken`, used to verify that the correct package is 
 attempting to play the content.
* Currently unique identification for learners is the responsibility of the hosted package.