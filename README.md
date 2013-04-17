# App.net Integration for iOS

Twitter is integrated in iOS 6, why not App.net?

Right now, everything except image uploads is working.

I'll publish this to Cydia soon.

## Development Notes

- `Config.h.example` -> `Config.h`, set credentials there
- [CocoaPods](http://cocoapods.org) `pod install` to get dependencies
- build requires [iOSOpenDev](http://iosopendev.com)
- we're building a MobileSubstrate .dylib, not an app bundle. we don't have a special directory for resources.
