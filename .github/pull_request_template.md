<!--- CHANGELOG_START -->
## Features <!--- Delete section if not needed -->
<!---
### {Feature Name}
Feature Description...
[Loom Video]

- Related Changes...
-->

## Improvements <!--- Delete section if not needed -->
<!--- Example:
- [External] Changed something that should go into the changelog...
- [External] **Breaking** Changed something that should go into the changelog...
- Changed something internal...
-->

## Bug Fixes <!--- Delete section if not needed -->
<!--- Example:
- [External] Fixed something that should go into the changelog...
- Fixed something internal...
-->

<!--- CHANGELOG_END -->

## Type of Change

- [ ] Bug fix
- [ ] New feature  
- [ ] Breaking change
- [ ] Documentation/refactoring

## Testing & Compatibility

- [ ] Tested on iOS (specify versions: ___)
- [ ] Tested Universal Link flows (if applicable)
- [ ] Example app verified
- [ ] Tested on physical devices (when possible)
- [ ] Memory leak testing completed
- [ ] Accessibility features verified

## Platform Support

- [ ] iOS 14.0+ compatibility maintained
- [ ] Swift 5.9+ compatibility maintained
- [ ] No breaking changes to public API (unless major release)

## Release Checklist

- [ ] **Is commit history clean?**
  - Do all commit names start with verbs like `Add`, `Fix`, `Refactor`...?
  - Are all commits passing or marked with `[WIP]`?
- [ ] **Are relevant documentation changes queued up?**
  - Are the Quiltt API Docs updated?
  - Is the iOS SDK README updated (if needed)?
  - Are Swift documentation comments added for public APIs?
- [ ] **Version considerations**
  - Should this be a patch, minor, or major version bump?
  - Are any breaking changes clearly documented?
  - **Add appropriate release label** (`release:patch`, `release:minor`, `release:major`) before merging

## Code Quality

- [ ] Code follows Swift API Design Guidelines
- [ ] Public APIs have proper documentation comments
- [ ] Error handling is implemented appropriately
- [ ] Memory management is handled correctly (no retain cycles)
- [ ] Swift Package builds without warnings
