UIKit for OS X

This is a fork of a fork of @enormego's UIKit work on the Mac, but almost a complete re-write. I wrote these classes in the process of making [a blog post](http://darknoon.com/blog/2011/02/01/mac-ui-in-the-age-of-ios/) about the future of Mac UI and iOS.

The point of this post is to foster discussion in the community, rather than be a real alternative to AppKit.

Twitter has a more robust Mac UI framework called ABUIKit, whose open-source release I'm advocating. If you want to support this effort, tweet with the tag #ABUIKit to express your interest in using the framework.

============================

UIKit compiles as a native OS X framework. You have two options for including it in your project: do a one-time compile and bundle it with your software, or add it as a dependency to your project to keep up-to-date easily.