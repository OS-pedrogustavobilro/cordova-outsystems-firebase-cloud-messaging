# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Cordova/Capacitor plugin that bridges Firebase Cloud Messaging (FCM) to hybrid mobile applications. The plugin consists of native code (Swift for iOS, Kotlin for Android) with a JavaScript API layer exposed to the WebView.

See [ARCHITECTURE.md](./ARCHITECTURE.md) for detailed architectural tenets, external integrations, and the Cordova/Capacitor migration strategy.

See [CONTRIBUTING.md](./CONTRIBUTING.md) for development workflow, branch naming conventions, commit format, and PR process.

## Directory Structure

```
src/ios/                  - Swift/Objective-C bridge code
  OSFirebaseCloudMessaging.swift      - Main iOS plugin class
  OSFCMEventExtensions.swift          - Event handling utilities
  AppDelegate+OSFirebaseCloudMessaging.{h,m}  - Method swizzling for Cordova
  frameworks/             - Proprietary xcframeworks (OSFirebaseMessagingLib, OSLocalNotificationsLib)

src/android/              - Kotlin bridge code
  com/outsystems/firebase/cloudmessaging/
    OSFirebaseCloudMessaging.kt       - Main Android plugin class
    OSFCMPermissionEvents.kt          - Permission result states
    build.gradle                      - Android dependencies (references osfirebasemessaging-android AAR)

www/                      - JavaScript API exposed to WebView
  OSFirebaseCloudMessaging.js         - Cordova exec bridge

hooks/                    - Cordova build hooks (run on after_prepare)
  unzipSound.js           - Extract sound resources
  cleanUp.js              - Remove temporary files
  android/androidCopyChannelInfo.js   - Copy notification channel config to strings.xml
  ios/iOSCopyPreferences.js           - Copy iOS preferences to plist

build-actions/            - Capacitor/ODC support (replaces hooks for Capacitor apps)
  updateCloudMessagingConfigs.yaml    - Build actions for channel config and entitlements
  capacitor_hooks_update_after.js     - AppDelegate injection for Capacitor
  README.md               - Build actions usage documentation

plugin.xml                - Cordova plugin manifest (dependencies, hooks, platform configs)
```

## Testing and Development

This is a plugin, not a standalone application. To test changes:

### For Cordova Projects
```bash
# In your test Cordova app
cordova plugin add /absolute/path/to/cordova-outsystems-firebase-cloud-messaging
cordova build android
cordova build ios
```

### For Capacitor Projects
```bash
# In your test Capacitor app
npm install /absolute/path/to/cordova-outsystems-firebase-cloud-messaging
npx cap sync
```

The `capacitor:update:after` hook runs automatically during `cap sync` to inject AppDelegate modifications.

### Manually Trigger Capacitor Hook
```bash
npm run capacitor:update:after
```

## Plugin API Surface

The JavaScript API in `www/OSFirebaseCloudMessaging.js` exposes these methods:

- `getToken()` - Get FCM device token
- `getAPNsToken()` - Get APNs token (iOS only)
- `subscribe(topic)` / `unsubscribe(topic)` - Manage topic subscriptions
- `registerDevice()` / `unregisterDevice()` - Handle push permission and registration
- `getPendingNotifications(clearFromDatabase)` - Retrieve queued notifications
- `clearNotifications()` - Clear notification center
- `setBadge(badge)` / `getBadge()` - Badge management
- `sendLocalNotification(...)` - Trigger local notification
- `setDeliveryMetricsExportToBigQuery(enable)` - Configure BigQuery export
- `on(event, callback)` / `un(event, callback)` - Event listener registration

All methods use the Cordova exec bridge. Events are queued until device ready (see [ARCHITECTURE.md](./ARCHITECTURE.md) T3: Event-Driven Callback Pattern).

## Key Dependencies

### iOS (specified in plugin.xml)
- `FirebaseMessaging` pod version 10.29.0 (from CocoaPods CDN)
- `OSFirebaseMessagingLib.xcframework` (proprietary, embedded in repo)
- `OSLocalNotificationsLib.xcframework` (proprietary, embedded in repo)

### Android (specified in src/android/.../build.gradle)
- `com.github.outsystems:osfirebasemessaging-android:1.3.1@aar` (from OutSystems Azure)
- `com.github.outsystems:oslocalnotifications-android` (from OutSystems Azure)

The proprietary libraries contain the actual FCM SDK integration logic. This plugin acts as a thin bridge.

## Important Context

### Cordova vs Capacitor Build Systems

The plugin supports both build systems using conditional logic:

- **Cordova apps** use method swizzling in `AppDelegate+OSFirebaseCloudMessaging.m` and standard Cordova hooks
- **Capacitor apps** skip swizzling (detected via bridge check) and use `build-actions/capacitor_hooks_update_after.js` to inject AppDelegate code

See [ARCHITECTURE.md](./ARCHITECTURE.md) "Current Phase Constraints: Capacitor Migration Strategy" for details.

### Build Hooks Behavior

Hooks in `hooks/` directory run during `cordova prepare` or `cordova build`:
- `unzipSound.js` - Extracts `sounds.zip` to platform resource directories
- `androidCopyChannelInfo.js` - Reads notification channel preferences from `config.xml` and writes to Android `strings.xml`
- `iOSCopyPreferences.js` - Copies iOS preferences from `config.xml` to `.plist` files

For Capacitor apps, equivalent functionality is in `build-actions/updateCloudMessagingConfigs.yaml` (used by ODC Plugin Manager).

### Permission Handling

- **Android**: Pre-Tiramisu (API < 33) does not require POST_NOTIFICATIONS permission; Tiramisu+ does
- **iOS**: Always requires asynchronous permission request via `requestAuthorisation()`

The `registerDevice()` method abstracts this logic so consuming apps don't need platform-specific code (see [ARCHITECTURE.md](./ARCHITECTURE.md) T5: Permission Abstraction).

### Event Queue Pattern

Events triggered before Cordova's `deviceready` are buffered in native code (`eventQueue` on both platforms) and replayed when the JavaScript calls the `ready()` action. This ensures no notifications are lost during app startup (see [ARCHITECTURE.md](./ARCHITECTURE.md) T3).

## Common Tasks

### Update iOS Firebase Dependency
Edit `plugin.xml` line 54 to change the FirebaseMessaging pod version.

### Update Android Proprietary Library Version
Edit `src/android/com/outsystems/firebase/cloudmessaging/build.gradle` to change the AAR version.

### Add New JavaScript API Method
1. Add method to `www/OSFirebaseCloudMessaging.js` using `exec()`
2. Implement in `src/ios/OSFirebaseCloudMessaging.swift` (method name must match)
3. Implement in `src/android/.../OSFirebaseCloudMessaging.kt` (method name must match)

### Debug Hook Execution
Hooks write to console during build. Check Cordova build output for hook logs. For Capacitor, check `build-actions/capacitor_hooks_update_after.js` console output during `cap sync`.

## Version and Release Management

When releasing a new version:
1. Update `version` in `package.json`
2. Update `version` attribute in `plugin.xml` root `<plugin>` element
3. Update `CHANGELOG.md` following [Keep a Changelog](https://keepachangelog.com/) format
4. Commit with: `chore(release): raise to version X.Y.Z`

See [CONTRIBUTING.md](./CONTRIBUTING.md) "Versioning" section for details.
