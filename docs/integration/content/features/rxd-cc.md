---
title: "Rustici Cross Domain for Content Controller"
type: docs
menu:
    main:
        name: RXD
        identifier: rxd
        parent: features
        weight: 6
---

# Rustici Cross Domain

## Introduction
If your training content is tightly integrated with your platform and not easy to package for third party use, you can use Content Controller to outfit your content with Rustici Cross Domain.  Rustici Cross Domain will allow your content to remain on your servers, but harness the power of Content Controller to share that content out to your clients via proxy packages. 

When a learner launches the proxy package in the third party LMS, they will be directed back to your servers via links you set up in Content Controller.  Once the learner exits the content, they will be directed back to the third party LMS via Content Controller.  Key information is saved in Content Controller reports so that you can see who is taking your content without having to set up reporting in your environment.

## Getting Started

You'll start by logging into your Content Controller instance to grab both the sample file and the `contentapi.html` file.  Instructions to do so are documented [here](  https://guide.contentcontroller.com/getting-started/add-a-course#importing-using-rustici-cross-domain).  

Looking at the source of the sample file will show you a simple example of a course that uses the RXD methods to do things like setting the status, setting a score, and other calls that may be important to use in your course. You will do similar Javascript calls in your content to communicate those values to the LMS. 

The `contentapi.html` file will be used to initialize the RXD API so that your course can make those calls.  You will take this file and deploy it on your server so it is accessible in the same domain as where your content lives. Once you have done so, you will use the url to the file when creating the RXD course in Content Controller.  

Since your content will be launched inside the `contentapi.html` page, it can access the RXD API object by calling `window.parent.RXD`.

~~~
    <script>
        // RXD variable will be undefined if content is not dispatched to an LMS
        var RXD = window.parent.RXD;
    </script>
~~~

Once you have done, so, you are free to use the following methods.

## Content API

### Initialize()

This function is automatically called by the `contentAPI.html` page when the content is launched. You should not need to use it unless you have replaced the default landing page as described in Customizations Landing Page.

### ConcedeControl()

This function will pass control back to the LMS and trigger the content window to be closed.

## Storing and Retrieving General Data

NOTE: All values set with RXD are held locally in the JavaScript object and they are initialized on launch with values from the LMS. Getting a value using the below methods gets the locally stored value and not neccesarily the value currently on the LMS.

### GetStudentID()

Returns the ID of the student currently taking the content. There is no technical reason why you should need this value unless your content is performing some functionality that is outside the scope of the standards or unless the content displays the student’s ID.

### GetStudentName()

Returns the name of the student currently taking the content. Formatted “Last Name,First Name”

### GetLessonMode()

Returns the mode in which the content was launched. Possible values are:

* `normal` - The content was launched intending to record full status and/or scoring data
* `browse` - The content was launched expecting to not record status and/or scoring data
* `review` - The content was launched having already recorded status and/or scoring data, not expecting it to be updated

Calling RXD status and/or scoring functions will trigger messages to be passed to the LMS and that LMS may choose to accept or reject them based on the lesson mode that was provided during launch.

### GetBookmark()

This function returns the last value that was saved using `SetBookmark`. If `SetBookmark` was not called previously, this function returns an empty string.  This function is useful to call at the beginning of the content to retrieve the user’s last location and give him/her the option to return to that location.

### SetBookmark(val)

Saves a string that represents the user’s current location in the content. This string can be formatted however you choose. This function should be called periodically as the user progresses through the content. Note for SCORM 1.2 based proxy packages the string has a limit of 255 characters. LMSs may restrict the size for other standards as well.

### GetSuspendData()

This function returns the last value that was saved to the suspend data bucket. If `SetSuspendData` was not called previously, or there was no suspend data available on launch, this function returns an empty string.

### SetSuspendData(val)

This function allows you to save a string of data. This data can represent anything; it is just an arbitrary chunk of data. This function is useful for saving internal state data that does not correspond to any other data element. Note for SCORM 1.2 based proxy packages the string has a limit of 4000 characters. LMSs may restrict the size for other standards as well.

## Status Functions

### GetStatus()

Returns the current lesson status of the content. Possible values are:

* `passed` - The user completed the content with a score sufficient to pass.
* `failed` - The user completed the content but his/her score was not sufficient to pass.
* `completed` - The user completed the content.
* `incomplete` - The user began the content but did not complete it.
* `browsed` - The user looked at the content but was not making a recorded attempt at it.
* `not_attempted` - The user has not started the content.
* `unknown` - The content received an unrecognized status, or the status was reset via `ResetStatus`

### SetReachedEnd()

You can optionally call this function to indicate that the user has made sufficient progress in the content to be considered complete. This function is useful for content that has a final diploma or confirmation page. When that final page is reached, you should call `SetReachedEnd`. After calling this function a call to `GetStatus` will return `completed` *unless* the content was previously marked as `passed` or `failed`.

### SetPassed()

Sets the current status of the content to passed. If there is a mastery score stored in the LMS (as specified in your content packaging) and if you record a score for the content, then this function does not need to be called; the LMS will automatically compare the score to the mastery score to determine if the content was passed or failed.

### SetFailed()

Sets the current status of the content to failed. If there is a mastery score stored in the LMS (as specified in your content packaging) and if you record a score for the content, then this function does not need to be called; the LMS will automatically compare the score to the mastery score to determine if the content was passed or failed.

### ResetStatus()

Resets the status of the content back to incomplete if you previously set it to passed or failed. A call to `GetStatus` will return `unknown` after calling this function.

## Assessments

### GetScore()

Retrieves the raw score previously recorded by `SetScore` in this session. If no score was previously set (since launch), this function returns `undefined`.

### SetScore(score, max, min)

Allows you to record the score that the user achieved in the content. You should specify the minimum and maximum scores that were available. All scores should be numbers (float) between 0 and 100.

### Interactions

The following set of functions record interaction data and all take the same set of arguments.

* `RecordTrueFalseInteraction`
* `RecordMultipleChoiceInteraction`
* `RecordFillInInteraction`
* `RecordMatchingInteraction`
* `RecordPerformanceInteraction`
* `RecordSequencingInteraction`
* `RecordLikertInteraction`
* `RecordNumericInteraction`

The function arguments are as follows:

* `id` - string identifier for the interaction,
* `learnerResponse` - learner's response to the interaction, format depends on the type of interaction,
* `isCorrect` - boolean indicating whether the learner's response was correct,
* `correctResponse` (optional) - expected correct response, format depends on the type of interaction,
* `description` (optional) - string description of the interaction (i.e. the question asked),
* `weighting` (optional) - a number that indicates the importance of the interaction relative to other interactions,
* `latency` (optional) - number of milliseconds passed during interaction,
* `learningObjectiveId` (optional) - string identifier of a learning objective associated with this interaction

An example call to record an interaction might look like the following:

    RXD.RecordMultipleChoiceInteraction("alpha-mc-1", "a", true, "a", "Which letter is first in the alphabet?", 1, 750, "alphabet1");

#### Response Formats

Multiple choice and seqeuencing interactions can be provided as simple strings, or via an object that provides a short and a long representation. A short representation will always be generated if the recording LMS does not support long identifiers using the first character of the long representation if both are not provided. For SCORM 2004 based packages the identifier will be transformed into a URI if it is not provided as one using the underlying Rustici Driver code which will prefix the provided response with `urn:scormdriver:`. To provide the specific response identifier an object notation similar to the following should be used:

    {
        short: "a",
        long: "alpha"
    }

For both types of interactions an array of objects similar to the above can also be provided:

    {
        short: "a",
        long: "alpha"
    },
    {
        short: "b",
        long: "beta"
    }

Matching interactions expect a response to include a source value and a target value, and may include multiple responses. For example a single matching response might take the form:

    {
        source: "left",
        target: "west"
    }

And multiple match responses could be recorded using an array of objects like the above:

    [
        {
            source: "top",
            target: "north"
        },
        {
            source: "right",
            target: "east"
        },
        {
            source: "bottom",
            target: "south"
        },
        {
            source: "left",
            target: "west"
        },
    ]


