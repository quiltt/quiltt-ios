# Releasing the Quiltt iOS SDK

This guide explains how to cut new releases of the iOS SDK using our automated release process.

## Overview

The Quiltt iOS SDK uses **label-based automated releases**. When you merge a PR with a release label, the system automatically:

- Bumps the version number
- Updates the version file
- Creates a GitHub release
- Tags the release

**No manual commands needed!** 🎉

## Release Types

We follow [Semantic Versioning](https://semver.org/) (semver):

| Label | Version Change | When to Use |
|-------|---------------|-------------|
| `release:patch` | `1.0.2 → 1.0.3` | Bug fixes, documentation updates |
| `release:minor` | `1.0.2 → 1.1.0` | New features, enhancements (backward compatible) |
| `release:major` | `1.0.2 → 2.0.0` | Breaking changes, major API changes |

## How to Release

### Step 1: Create Your PR

Create a pull request with your changes as usual:

```bash
git checkout -b fix/webview-memory-leak
# Make your changes...
git commit -m "fix: resolve WebView memory leak in navigation delegate"
git push origin fix/webview-memory-leak
```

### Step 2: Add Release Label

**Before merging**, add the appropriate release label to your PR:

1. Go to your PR on GitHub
2. Click the **Labels** section on the right side
3. Select the appropriate release label:
   - 🐛 **`release:patch`** - for bug fixes
   - ✨ **`release:minor`** - for new features  
   - 💥 **`release:major`** - for breaking changes

### Step 3: Get PR Reviewed and Merged

Follow normal review process, then merge the PR. **The release happens automatically on merge!**

### Step 4: Verify Release

After merging, check:

- ✅ **GitHub Actions**: Go to Actions tab, verify "Automated Release and Publish" succeeds
- ✅ **Swift Package Index**: Check if the package appears on [swiftpackageindex.com](https://swiftpackageindex.com/quiltt/quiltt-ios)
- ✅ **GitHub Releases**: Check the [Releases page](../../releases) for the new release
- ✅ **PR Comment**: The automation will comment on your PR with success details

## Examples

### Bug Fix Release

```md
PR: "Fix WebView navigation delegate memory leak"
Label: release:patch
Result: 1.0.2 → 1.0.3
```

### New Feature Release  

```md
PR: "Add support for macOS Universal Links"
Label: release:minor  
Result: 1.0.2 → 1.1.0
```

### Breaking Change Release

```md
PR: "Remove deprecated authenticate() method signature"
Label: release:major
Result: 1.0.2 → 2.0.0
```

## What Happens Automatically

When you merge a labeled PR, the automation:

1. **Detects the release label** on your merged PR
2. **Calculates new version** based on current version + label type
3. **Updates version file**: `Sources/QuilttConnector/QuilttSdkVersion.swift`
4. **Commits changes** back to main branch
5. **Creates Git tag** (e.g., `v1.0.3`)
6. **Builds and validates** Swift package
7. **Creates GitHub release** with release notes
8. **Comments on your PR** with success details

## Troubleshooting

### No Release Happened

**Problem**: Merged PR but no release was created.
**Solution**: Check that your PR had a `release:*` label before merging.

### Release Failed

**Problem**: GitHub Actions shows red X on release workflow.
**Solution**:

1. Check the Actions logs for specific error
2. Common issues:
   - Swift compilation errors
   - Missing GitHub token permissions
   - Xcode version compatibility issues

### Wrong Version Number

**Problem**: Released wrong version type (e.g., minor instead of patch).
**Solution**:

1. Create a new PR to fix any issues
2. Use the correct label for the follow-up release
3. The version number will continue from the previous release

### Manual Release Needed

**Problem**: Need to release without a PR (hotfix, emergency).
**Solution**: Create a minimal PR with the fix and proper label, then merge.

## Best Practices

### ✅ Do

- **Always add release labels** before merging
- **Use descriptive PR titles** (they become release notes)
- **Test your changes** thoroughly on iOS before labeling for release
- **Use patch releases** for bug fixes and documentation
- **Use minor releases** for new features and iOS enhancements
- **Use major releases** sparingly, only for breaking API changes

### ❌ Don't

- **Don't merge without a release label** if you intend to release
- **Don't use major releases** for non-breaking changes
- **Don't manually edit version files** (automation handles this)
- **Don't create manual Git tags** (automation handles this)
- **Don't release without testing** on physical iOS devices when possible

## Emergency Releases

For urgent hotfixes:

1. **Create hotfix branch** from main
2. **Make minimal fix** focused on the critical issue
3. **Create PR** with clear title describing the emergency
4. **Add `release:patch` label**
5. **Get expedited review** from team
6. **Merge immediately**

The automation will handle the emergency release within minutes.

## Platform-Specific Considerations

### iOS Release Checklist

- ✅ **Test on multiple iOS versions** (iOS 14.0+)
- ✅ **Verify on physical devices** when possible
- ✅ **Check Universal Link handling** for OAuth flows
- ✅ **Validate memory management** in WebView usage
- ✅ **Test accessibility features**

### Swift Package Considerations

- ✅ **Ensure Package.swift is valid**
- ✅ **Verify all platforms build successfully**
- ✅ **Check dependency compatibility**
- ✅ **Validate documentation builds**

## Getting Help

- **GitHub Actions failing?** Check the [Actions tab](../../actions) for detailed logs
- **Swift Package issues?** Verify your Package.swift configuration
- **Questions about semver?** See [Semantic Versioning](https://semver.org/)
- **Need help?** Ask in #engineering-ios or create an issue

## Current Version

You can always check the current version:

- **QuilttSdkVersion.swift**: `public let quilttSdkVersion = "X.Y.Z"`
- **GitHub**: [Latest release](../../releases/latest)
- **Swift Package Index**: [Package page](https://swiftpackageindex.com/quiltt/quiltt-ios)

## Release History

Major releases and their breaking changes:

### v2.0.0 (Future)

- TBD - Major API restructuring

### v1.0.0 (Current)

- Initial stable release
- iOS 14.0+ support
- SwiftUI and UIKit integration
- Universal Links support

---

Happy releasing! 🚀
