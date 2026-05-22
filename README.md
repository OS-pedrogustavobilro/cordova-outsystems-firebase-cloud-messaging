# cordova-outsystems-firebase-cloud-messaging

## Core Data model (iOS)

The iOS side persists notifications with Core Data. The model lives in
[src/ios/ios-lib/CoreDataManager/](src/ios/ios-lib/CoreDataManager/) and is shipped to apps as a
**pre-compiled `.momd` bundle**, registered in [plugin.xml](plugin.xml) via
`<resource-file>`. The `.xcdatamodeld` source is kept in the same directory as
the source of truth, but is not referenced by `plugin.xml`.

Why pre-compile: Cordova's `<source-file>` is what would normally trigger
`momc` (the Core Data model compiler) in the host app's Xcode build, but
Capacitor's Cordova-plugin compatibility layer can't process directory wrappers
listed under `<source-file>` and fails sync with `EISDIR`. Shipping the
pre-compiled `.momd` as a `<resource-file>` works in both Cordova and Capacitor
because it's a plain "copy into the app bundle" artifact — no build-time
compilation needed.

### When you edit the model

Anything that changes `NotificationsModel.xcdatamodeld` (new entity, renamed
attribute, new model version, etc.) must be followed by recompiling the
`.momd` and committing both:

```sh
xcrun momc \
  src/ios/ios-lib/CoreDataManager/NotificationsModel.xcdatamodeld \
  src/ios/ios-lib/CoreDataManager/NotificationsModel.momd
```

Then `git add` both `NotificationsModel.xcdatamodeld` and
`NotificationsModel.momd` and commit together. The `.momd` directory is what
ends up in user devices, so if it's stale the runtime model won't match what
the source `.xcdatamodeld` describes.
