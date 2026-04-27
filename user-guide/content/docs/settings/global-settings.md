# Global settings

![](../.gitbook/assets/CC-GlobalSettings.png)

### Content Security

Content Controller will inspect the contents of uploaded zip packages for dangerous file types. You can [modify this behavior](https://support.scorm.com/hc/en-us/articles/360033820534-Content-Controller-Imported-Package-Contained-Blacklisted-File-Type) by clicking Content Security under Global Settings.

### Content Options

**Enable SCORM 2004 4th Edition Export:** Toggle on/off the ability to export courses as SCORM 2004 4th Edition.

**Enable import of legacy RXD content:** Allows users to choose RXD v1.8 (legacy) instead of RXD v3.x (recommended) when importing RXD content.

### Launch

#### Learner Data

Toggle on/off the ability to [anonymize learner data](https://support.scorm.com/hc/en-us/articles/7671577344155-Hashing-Specifics-in-Content-Controller). This feature hashes personally identifiable information about learners before it is sent to Content Controller for all accounts.

#### Lead-in Page

During the launch process, direct users to a Lead-in Page. This self-hosted webpage allows Content Controller to present information or obtain a response before users start a course.

#### Mobile Device User-Agent Segments

If the User-Agent of a learner contains any of these segments, then a course that has the 'Force Frameset Launches on Mobile Devices' setting enabled will ignore the configured SCO launch type and continue with a frameset launch.

### Privacy Policy

Add a customized privacy policy statement for learners. A link to the statement will be displayed in the player for all accounts that enabled the _Display Privacy Policy Link_ setting.

### Sign-in Message

Add a custom message to Content Controller’s sign-in screen. It will appear to all users before they sign in.
