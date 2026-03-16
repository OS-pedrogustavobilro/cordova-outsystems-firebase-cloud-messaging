# Contributing to cordova-outsystems-firebase-cloud-messaging

## Overview

This is a Cordova plugin for Firebase Cloud Messaging with support for both iOS and Android platforms. The plugin also supports Capacitor through build actions.

## Development Setup

### Prerequisites

- Node.js and npm
- For iOS development:
  - Xcode
  - CocoaPods
  - Swift 5 compiler
- For Android development:
  - Android Studio
  - Gradle
  - Kotlin support

### Installation

1. Clone the repository
2. Install Node.js dependencies:
   ```bash
   npm install
   ```

## Project Structure

- `src/ios/` - iOS native code (Swift, Objective-C)
- `src/android/` - Android native code (Kotlin)
- `www/` - JavaScript interface layer
- `hooks/` - Cordova hooks for build-time configuration
- `build-actions/` - Capacitor build actions (ODC support)
- `plugin.xml` - Cordova plugin configuration

## Development Workflow

### Branch Naming

Follow this pattern: `<type>/RMET-<ticket-number>/<short-description>`

Examples:
- `feat/RMET-1234/add-notification-actions`
- `fix/RMET-5678/handle-registration-errors`
- `chore/RMET-9012/update-dependencies`

Check existing branches with:
```bash
git branch -r
```

### Commit Format

Use conventional commits with platform scopes:

```
<type>(<scope>): <description>

[optional body]
```

**Types:** `feat`, `fix`, `chore`, `docs`, `refactor`, `test`, `style`, `perf`, `build`, `ci`, `revert`

**Scopes:** `android`, `ios`, `release`, or omit for cross-platform changes

**Examples:**
```
feat(ios): add support for notification badges
fix(android): handle errors in RegisterDevice
chore: update changelog
```

View recent commit patterns:
```bash
git log --oneline -20
```

### Making Changes

1. Create a feature branch from `main`
2. Make your changes following the commit format
3. Update `CHANGELOG.md` following [Keep a Changelog](https://keepachangelog.com/) format
4. Update version in `package.json` and `plugin.xml` if releasing

## Building and Testing

### Testing in a Cordova Project

Since this is a plugin, test by integrating into a Cordova project:

```bash
# In your test Cordova project
cordova plugin add /path/to/cordova-outsystems-firebase-cloud-messaging

# Build for Android
cordova build android

# Build for iOS
cordova build ios
```

### Testing in a Capacitor Project

For Capacitor/ODC testing:

```bash
# In your test Capacitor project
npm install /path/to/cordova-outsystems-firebase-cloud-messaging

# Sync with native projects
npx cap sync
```

The `capacitor:update:after` hook runs automatically:
```bash
npm run capacitor:update:after
```

### Hooks and Build Actions

Hooks execute automatically during Cordova builds:
- `unzipSound.js` - Extracts sound resources
- `cleanUp.js` - Cleans temporary files
- `android/androidCopyChannelInfo.js` - Copies Android channel configuration
- `ios/iOSCopyPreferences.js` - Copies iOS preferences

Build actions (`build-actions/updateCloudMessagingConfigs.yaml`) provide equivalent functionality for Capacitor apps. See `build-actions/README.md` for details.

## Code Standards

### iOS Code

- Swift 5 syntax
- Follow existing patterns in `src/ios/`
- Use the `OSFirebaseMessagingLib.xcframework` for messaging functionality
- Update CocoaPods dependencies in `plugin.xml` when needed

### Android Code

- Kotlin (official code style as per `plugin.xml`)
- AndroidX libraries required
- Follow existing patterns in `src/android/`
- Use the `osfirebasemessaging-android` AAR library for messaging functionality
- Keep Gradle dependencies in `src/android/com/outsystems/firebase/cloudmessaging/build.gradle`

### JavaScript Code

- Follow existing patterns in `www/OSFirebaseCloudMessaging.js`
- Maintain backward compatibility with existing API

## Pull Request Process

### Before Submitting

1. Ensure your branch follows the naming convention
2. Verify commit messages follow conventional commit format
3. Update `CHANGELOG.md` with your changes
4. Test on both platforms if applicable
5. Update documentation if adding/changing features

### PR Title Format

Must follow: `RMET-XXXX <title>`

Example: `RMET-4953 Handle errors in RegisterDevice`

### PR Checklist

Use the provided template (`pull_request_template.md`). Ensure:

- [ ] PR title includes ticket reference (`RMET-XXXX`)
- [ ] Code follows project style
- [ ] `CHANGELOG.md` updated correctly
- [ ] Documentation updated if needed
- [ ] Type of change specified (fix/feature/refactor/breaking)
- [ ] Affected platforms marked (Android/iOS/JavaScript)
- [ ] Testing details provided

### Review Process

- PRs require review from `@OutSystems/rd-mobile-ecosystem` (see `CODEOWNERS`)
- Address review feedback with new commits
- Once approved, the team will merge

## Versioning

This project follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

When releasing:
1. Update version in `package.json`
2. Update version in `plugin.xml` (both `version` attribute and `<plugin>` tag)
3. Update `CHANGELOG.md` with version header and release date
4. Create a release commit: `chore(release): raise to version X.Y.Z`

## Useful Commands

| Command | Description |
|---------|-------------|
| `npm install` | Install Node.js dependencies |
| `git log --oneline -20` | View recent commits for format patterns |
| `git branch -r` | View remote branches for naming patterns |
| `cordova plugin add <path>` | Test plugin in Cordova project |
| `npx cap sync` | Test plugin in Capacitor project |

## Resources

- [Cordova Plugin Development Guide](https://cordova.apache.org/docs/en/latest/guide/hybrid/plugins/)
- [Keep a Changelog](https://keepachangelog.com/)
- [Semantic Versioning](https://semver.org/)
- [Conventional Commits](https://www.conventionalcommits.org/)
