---
title: "Lead-in Page"
type: docs
menu:
    main:
        name: Lead-in Page
        identifier: lead_in_page
        parent: features
        weight: 5
---

# Lead-In Page

## What Is A Lead-in Page
A Lead-in Page is a self-hosted webpage that will precede content during the launch process. After the learner has 
viewed and interacted with the Lead-in Page, they will be returned to their content. A Lead-in Page can be configured 
with a GET or POST endpoint.

## Setting Up A Lead-in Page
Either endpoint setup requires the user to provide the location of the webpage that Content Controller will display. The
Lead-in page will be displayed within an iframe. Content Controller uses that iframe to "listen" for the Lead-in page's 
notice to move on to the course content. The webpage will also need to include a simple script that notifies Content 
Controller.

Script for the webpage:
```js
window.parent.postMessage({
    'message': ""
}, "*");
```

### Where To Enable A Lead-In Page
Users can choose to enable one Lead-in page for their entire instance of Content Controller or enable the page by 
account. To set an instance wide Lead-in page to display before any dispatch go to Administration > Settings > Launch > 
Lead-in Page. Whatever is set here can be overridden at the account level. Dispatches from that account will use that 
account's Lead-in page. The account level settings can be found in the account's Advanced Settings under the Lead-in 
Page tab.

In the event that a user needs to use the Administration level Lead-in page settings but they've already set a separate
Lead-in page for the account, the user can check "Overwrite with Admin Settings". Once the changes are saved that 
account will switch to using the Administration level Lead-in page for all dispatches.

### GET Settings
The GET option tells Content Controller to grab the Lead-in page, place it in an iframe and then wait for a message to 
move on to the course content. Once the Lead-in page settings are saved, those changes take
effect immediately.

Steps to add a GET style Lead-in page from the Account or Administration level:
1. Choose GET from the _Select Endpoint Type_ dropdown. 
2. Fill in the _GET Endpoint URL_ with the URL location of the hosted Lead-in page. 
3. To start displaying the Lead-in page in front of any launched dispatch check _Display Lead-in page_. 
4. Save the settings.

### POST Settings
The POST option tells Content Controller to POST a JWT token to the given endpoint. Content Controller will expect to 
receive a response with a status code of 3xx and a `Location` header set to the URL of the Lead-in Page. Content 
Controller will use the given URL to redirect the learner. Once the learner has been redirected to the Lead-in page,
Content Controller will rely on the Lead-in page to notify Content Controller when the learner needs to be redirected to 
the course. Content Controller will also handle a 2xx response as an indication to continue to the content launch and 
not attempt a Lead-in page redirect.

Steps to add a POST style Lead-in page from the Account or Administration level:
1. Choose POST from the _Select Endpoint Type_ dropdown.
2. Fill in the _POST Endpoint URL_ with the location where you will receive the token from Content Controller.
3. To start displaying the Lead-in page in front of any launched dispatch check _Display Lead-in page_.
4. Choose whether a failure response sent to Content Controller will keep the course from launching.
5. Save the settings.

#### JWT Header
Key | Value   | Description
----|---------|-------------------------------------
typ | "JWT"   | 
alg | "HS512" | The algorithm used to sign the JWT.

#### JWT Payload
Key   | Value                                                                               | Description
------|-------------------------------------------------------------------------------------|---------------------------
aud   | "Lead-inPageHost"                                                                   | The audience of tokens issued.
lid   | "user@example.com" (example)                                                        | The Learner ID of an individual launching a course.
rls   | "http://purl.imsglobal.org/vocab/lis/v2/institution/person#Administrator" (example) | The LTI User roles.
iss   | "ContentController" (default value)                                                 | The Issuer of the JWT. Can be configured through our playbooks.
title | "Test Title" (example)                                                              | Title of the course being launched.
exp   | "1440" (default value)                                                              | Expiration for the JWT token in seconds. Can be configured through the playbooks.
aid   | "2" (example)                                                                       | The Content Controller account ID associated with the dispatch package.
an    | "Test Account" (example)                                                            | The account name of the Content Controller account associated with the dispatch package.
ait   | "1660676709" (example)                                                              | The date which the token was created.
cid   | "1" (example)                                                                       | The content ID of the course being launched.

#### JWT Signature
Key    | Value                                                                              | Description
-------|------------------------------------------------------------------------------------|-------------------------------------
secret | "FFPJiHlnFQxiRLUDPJYL8rAHHhrLNgqKClR60uh6P28W1C9hZoDqrTWfpCrIxyOO" (default value) | The secret key used to sign tokens. Can be configured via the playbooks.
