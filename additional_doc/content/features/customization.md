---
title: "Customization"
type: docs
menu:
    main:
        name: Customization
        identifier: customization
        parent: features
        weight: 5
---

# Customization

## Favicons

Content Controller's favicons can be customized with a `.png` file that you provide. The '16x16' format is the favicon that is likely to appear in a browsers tab, while the '32x32' format is likely to be used for browser shortcuts. We allow one or both of these files to be customized.

To change the favicons:
1. Add a new directory named `files` to `roles/content-controller`.
2. In `files`, add the desired `.png` file with the name of `favicon-32x32.png` and/or `favicon-16x16.png`, depending on which favicon you wish to customize. The path to the new favicon(s) should be `roles/content-controller/files/favicon-##x##.png`.
3. Redeploy

Note: You may need to clear your browser's cache to see the new favicon.