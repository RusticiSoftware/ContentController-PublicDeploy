---
title: "Add a Zoom Meeting"
type: docs
menu:
  main:
    name: "Add a Zoom Meeting"
    identifier: add-a-zoom-meeting
    parent: integrations
    weight: 10
---

# Add a Zoom meeting

## Integration requirements

{{< hint warning >}}
The Zoom integration is available in Content Controller version 5.0 and later. The following criteria must be met:
* You must have a user with Administrator permissions in both Content Controller and Zoom.
* That user email must match in both Content Controller and Zoom.
{{< /hint >}}

## Find the Zoom Application Connect Set Up

1. In Content Controller, go to **Settings > Administration > Integrations > Applications**.
2. For Zoom, select **Connect**.
3. Save the OAuth Redirect URI for a later step.
{{< img src="images/oauth-uri.png" alt="OAuth URI" >}}

## Build a Zoom app

You need to build an app in Zoom to authenticate with Content Controller. Do this through the Zoom Marketplace.

1. Go to [https://marketplace.zoom.us/](https://marketplace.zoom.us/) and sign in.
2. In the top right corner, turn on **Try new experience** if it is off.
{{< img src="images/try-new.png" alt="Try New Experience is turned on" >}}
3. Click **Developer** in the bottom left corner.
{{< img src="images/developer.png" alt="Developer Link" >}}
4. In Platform Studio, click **Develop** in the top right corner and select **Build App**.
{{< img src="images/build-app.png" alt="Build App" >}}
5. Choose **General App**, then select **Create**.
{{< img src="images/general-app.png" alt="General App Selection" >}}
6. On the left panel, go to **Basic Information**. Scroll down on the page content to **Select how the app is managed**. Choose **Admin-Managed** and Save.
7. Scroll further down on the page content and enter the **OAuth Redirect URI**. This is the URI that you saved in step 3 of [Find the Zoom Application Connect Set Up](#find-the-zoom-application-connect-set-up).
{{< img src="images/basic-information.png" alt="Basic Information" >}}
8. On the left panel, go to **Embed** and turn **Meeting SDK** on.
{{< img src="images/embed.png" alt="Embed" >}}
9. On the left panel, go to **Scopes** and select **Add Scopes**.
{{< img src="images/add-scopes.png" alt="Add Scopes" >}}
10. In the **Add Scopes** modal, search for and add one scope at a time. Add the following scopes:
   * `meeting:read:meeting:admin` (View a meeting)
   * `meeting:read:list_meetings:admin` (View a user's meeting)
   * `user:read:email:admin` (View a user's email)
   * `user:read:user:admin` (View a user)
{{< img src="images/add-scope-read-meeting.png" alt="Add Scopes" >}}
11. After the four scopes are added, click **Done**.
{{< img src="images/list-scopes.png" alt="List Scopes" >}}
12. At the top of the left panel, copy the **App Credentials** (Client ID and Client Secret). You will need these in Content Controller.
{{< img src="images/secret-key.png" alt="Copy Secret and Key" >}}

## Connect Zoom in Content Controller

1. In Content Controller, go to **Settings > Administration > Integrations > Applications**.
2. For Zoom, select **Connect**.
3. Enter the **Client ID** and **Client Secret** from Zoom.

{{< img src="images/oauth-uri.png" alt="Enter Zoom Client ID and Client Secret in Content Controller" >}}

4. Select **Next**.
5. Select **Authorize with Zoom**. You will be redirected to a Zoom App page requesting permission to connect. Your App may still have a generic name. You can rename it in the Zoom's App Builder at any time. Select **Allow**. 
{{< img src="images/allow-zoom.png" alt="Allow Zoom" >}}
6. You will be redirected back to Content Controller. A green success notification should appear when the connection is complete.
{{< img src="images/authorize.png" alt="Authorize Zoom" >}}

## Add a Zoom Event as Content

1. Go to Content > Add > Courses > Add Event.
2. Pick the Zoom Meetings to import and select **Next**.
{{< img src="images/add-event.png" alt="Add Zoom Events" >}}
3. Add any custom IDs and tags on the **Metadata** step.
{{< img src="images/set-metadata.png" alt="Add Metadata for Zoom Events" >}}
4. **Review Results** and select **Return to Content**.
{{< img src="images/review-results.png" alt="Review Results" >}}

From here the Zoom meeting can be treated like any other course content. You can add it to accounts, edit details and create a dispatch. 

