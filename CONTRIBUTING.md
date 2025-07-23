# Contributing to Quiltt iOS SDK

First off, thank you for considering contributing to the Quiltt iOS SDK. It's people like you that make Quiltt such a great tool for developers in the fintech space. We welcome contributions from everyone as part of our mission to build powerful, user-friendly tools for financial technology applications on Apple platforms.

## Getting Started

Before you begin, please ensure you have:

- A GitHub account
- iOS development environment set up (Xcode 15.0+, iOS 14.0+)
- Familiarity with the Quiltt documentation at [https://quiltt.dev](https://quiltt.dev)
- Understanding of Swift Package Manager and WebKit integration

Understanding Quiltt's core concepts and the iOS SDK's architecture will help you make meaningful contributions.

## Development Setup

1. **Clone the repository:**

   ```bash
   git clone https://github.com/quiltt/quiltt-ios.git
   cd quiltt-ios
   ```

2. **Open in Xcode:**

   ```bash
   open Package.swift
   ```

3. **Set up the example app:**

   ```bash
   cd ExampleSwiftUI
   open ExampleSwiftUI.xcodeproj
   ```

4. **Install Fastlane (for releases):**

   ```bash
   bundle install
   ```

## Project Structure

```txt
├── Sources/QuilttConnector/          # Main SDK source code
│   ├── QuilttConnector.swift             # Main SDK entry point
│   ├── QuilttConnectorConfiguration.swift # Configuration classes
│   ├── QuilttConnectorEvent.swift        # Event callback definitions
│   ├── QuilttConnectorWebview.swift      # WebView implementation
│   ├── URLUtils.swift                    # URL encoding utilities
│   └── QuilttSdkVersion.swift            # Version information
├── ExampleSwiftUI/               # Example SwiftUI app
├── Tests/QuilttConnectorTests/   # Unit tests
├── fastlane/                     # Release automation
└── .github/workflows/            # CI/CD pipelines
```

## Ways to Contribute

There are many ways to contribute to the Quiltt iOS SDK:

### Reporting Bugs

- **Use the GitHub Issues tracker** to submit bug reports
- **Search existing issues** to avoid duplicates
- **Provide detailed information:**
  - Xcode and Swift versions
  - iOS/macOS versions being tested
  - Device models (iPhone, iPad, Mac)
  - Steps to reproduce the issue
  - Expected vs actual behavior
  - Console logs or error messages
  - Connector ID (if applicable) for debugging

**Bug Report Template:**

```md
**Describe the bug**
A clear description of what the bug is.

**To Reproduce**
Steps to reproduce the behavior:
1. Configure SDK with '...'
2. Call method '...'
3. See error

**Expected behavior**
What you expected to happen.

**Environment:**
- Xcode version: [e.g. 15.2]
- Swift version: [e.g. 5.9]
- Platform: [iOS/macOS]
- Device: [e.g. iPhone 15 Pro, MacBook Pro M3]
- iOS/macOS version: [e.g. iOS 17.2, macOS 14.2]
- SDK version: [e.g. 1.0.1]

**Additional context**
Any other context about the problem.
```

### Feature Requests

- **Use the GitHub Issues tracker** for feature requests
- **Search existing requests** to avoid duplicates
- **Provide clear explanations:**
  - Use case and business justification
  - Proposed API design
  - Examples of how it would work
  - Consideration for iOS/macOS differences

### Platform Support

We welcome contributions to extend platform support:

- **iPad optimizations** - Split view, multitasking optimizations, Stage Manager support
- **Apple TV support** - Extending to tvOS platform
- **Apple Watch support** - WatchKit integration possibilities
- **iOS-specific features** - Camera integration, biometric authentication

## Submitting Code Changes

### Development Workflow

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:

   ```bash
   git clone https://github.com/YOUR_USERNAME/quiltt-ios.git
   ```

3. **Create a feature branch:**

   ```bash
   git checkout -b feature/your-feature-name
   ```

4. **Make your changes** following our coding standards
5. **Test your changes** thoroughly
6. **Commit with descriptive messages:**

   ```bash
   git commit -m "Add support for macOS Universal Links"
   ```

7. **Push to your fork:**

   ```bash
   git push origin feature/your-feature-name
   ```

8. **Submit a pull request** against the `main` branch

### Coding Standards

- **Follow Swift conventions** from the [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- **Use meaningful variable names** and add documentation comments for public APIs
- **Maintain consistency** with existing code patterns
- **Handle errors gracefully** with proper error handling
- **Add documentation** for public APIs using Swift documentation comments
- **Test on multiple Apple platforms** (iOS, macOS when applicable)
- **Follow Apple Human Interface Guidelines** for UI components

### Swift Coding Conventions

```swift
// Use clear, descriptive names
class QuilttConnectorWebview: WKWebView {
    // Use access control appropriately
    public var config: QuilttConnectorConfiguration?
    private var internalState: String?
    
    // Document public APIs
    /// Authenticates the SDK with the provided token
    /// - Parameter token: The session token for authentication
    public func authenticate(_ token: String) {
        // Implementation
    }
    
    // Use Swift's error handling
    func loadConfiguration() throws {
        guard let config = self.config else {
            throw QuilttError.missingConfiguration
        }
        // Process configuration
    }
}
```

### Commit Message Format

We prefer clear, descriptive commit messages that start with action verbs:

- `Add` - New features or functionality
- `Fix` - Bug fixes
- `Update` - Changes to existing features
- `Refactor` - Code restructuring without functional changes
- `Remove` - Deleting code or features
- `Improve` - Enhancements to existing functionality

**Examples:**

- `Add support for iOS Universal Links 2.0`
- `Fix WebKit navigation delegate memory leak`
- `Update URLUtils to handle edge cases`
- `Refactor configuration validation logic`

**Note:** Release versioning is handled automatically via PR labels, not commit message conventions.

### Testing

- **Test your changes** on iOS simulators and physical devices
- **Run the example app** to verify functionality
- **Test with multiple connectors** if possible (Plaid, Finicity, etc.)
- **Verify Universal Link flows** work correctly
- **Check for memory leaks** in WebView handling
- **Test on physical devices** when possible
- **Validate accessibility** features work properly

### Pull Request Guidelines

**Pull Request Template:**

See [pull_request_template.md](./.github/pull_request_template.md)

## Release Process

The project uses **automated label-based releases**:

- **Patch releases** (`release:patch` label) - Bug fixes, documentation updates
- **Minor releases** (`release:minor` label) - New features, enhancements  
- **Major releases** (`release:major` label) - Breaking changes, major API changes

### How to Trigger a Release

1. **Create your PR** with changes
2. **Add appropriate release label** before merging:
   - `release:patch` for bug fixes
   - `release:minor` for new features
   - `release:major` for breaking changes
3. **Merge the PR** - Release happens automatically!

The automation will:

- Calculate new version number
- Update `QuilttSdkVersion.swift`
- Create GitHub release with release notes
- Tag the release

**No manual commands needed!** See [RELEASING.md](RELEASING.md) for detailed instructions.

Contributors should indicate the type of change in their PRs using the pull request template.

## Code Review Process

1. **Automated checks** run via GitHub Actions
2. **Build verification** on macOS with Xcode
3. **Swift Package validation**
4. **Maintainer review** for code quality and architecture
5. **Testing verification** on iOS devices and simulators
6. **Feedback and iteration** if changes are needed
7. **Approval and merge** once requirements are met

Reviews help ensure code quality, consistency, and maintainability. Please be open to feedback and discussion.

## Swift Package Development

### Package.swift Guidelines

- **Keep dependencies minimal** - Avoid unnecessary external dependencies
- **Use appropriate Swift tools version** - Currently 5.9+
- **Platform support** - Specify minimum iOS versions
- **Proper target organization** - Separate main library from tests

### WebKit Integration

- **Follow WebKit best practices** - Proper delegate implementation
- **Handle navigation carefully** - Security considerations for financial apps
- **Memory management** - Avoid retain cycles with WebView delegates
- **JavaScript injection** - Secure script evaluation practices

## Community Guidelines

We want to foster an inclusive and friendly community around the Quiltt iOS SDK. We expect everyone to:

- **Be respectful** in all interactions
- **Provide constructive feedback** during code reviews
- **Help newcomers** get started with contributions
- **Share knowledge** about iOS development and fintech integration
- **Follow Apple's community guidelines** and development best practices

## Questions and Support

- **GitHub Issues** - For bugs and feature requests
- **GitHub Discussions** - For questions and community support
- **Pull Request comments** - For code-specific questions
- **Documentation** - Check [quiltt.dev](https://quiltt.dev) for SDK guides

## Apple Developer Resources

- **Swift Documentation** - [swift.org/documentation](https://swift.org/documentation/)
- **Human Interface Guidelines** - [developer.apple.com/design/human-interface-guidelines](https://developer.apple.com/design/human-interface-guidelines/)
- **WebKit Documentation** - [developer.apple.com/documentation/webkit](https://developer.apple.com/documentation/webkit)
- **Universal Links** - [developer.apple.com/documentation/xcode/supporting-universal-links-in-your-app](https://developer.apple.com/documentation/xcode/supporting-universal-links-in-your-app)

## Thank You

Thank you for your interest in contributing to the Quiltt iOS SDK! Together, we can make financial technology integration easier and more accessible for iOS developers worldwide.
