# Quiltt iOS SDK

[![Swift Package Manager](https://img.shields.io/badge/SPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)
[![Swift Versions](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fquiltt%2Fquiltt-ios%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/quiltt/quiltt-ios)
[![Platforms](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fquiltt%2Fquiltt-ios%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/quiltt/quiltt-ios)

The Quiltt iOS SDK provides native iOS components for integrating [Quiltt Connector](https://quiltt.dev/connector) into your iOS applications.

Note that this SDK currently supports iOS 14.0+. We welcome contributions to add support for other Apple platforms!

See the official guide at: [https://quiltt.dev/connector/sdk/ios](https://quiltt.dev/connector/sdk/ios)

## Installation

### Swift Package Manager

1. **In Xcode:** Select `File` > `Add Package Dependency...`
2. **Enter URL:** `https://github.com/quiltt/quiltt-ios`
3. **Select Version:** Choose the latest version and click `Add Package`
4. **Import:** Use `import QuilttConnector` in your Swift files

### Package.swift

```swift
dependencies: [
    .package(url: "https://github.com/quiltt/quiltt-ios.git", from: "1.0.0")
]
```

## Usage

### SwiftUI Implementation

```swift
import SwiftUI
import QuilttConnector
import WebKit

struct ConnectorView: View {
    @Binding var showHomeView: Bool
    @Binding var connectionId: String
    
    var body: some View {
        QuilttWebView(
            showHomeView: $showHomeView, 
            connectionId: $connectionId
        )
    }
}

struct QuilttWebView: UIViewRepresentable {
    @Binding var showHomeView: Bool
    @Binding var connectionId: String
    
    @State private var config = QuilttConnectorConnectConfiguration(
        connectorId: "<CONNECTOR_ID>",
        oauthRedirectUrl: "<YOUR_HTTPS_UNIVERSAL_LINK>"
    )
    
    func makeUIView(context: Context) -> WKWebView {
        let quilttConnector = QuilttConnector()
        
        // Authenticate with session token
        quilttConnector.authenticate(token: "<SESSION_TOKEN>")
        
        // Launch Connect Flow
        let webview = quilttConnector.connect(
            config: config,
            onEvent: { eventType, metadata in
                print("onEvent \(eventType): \(metadata)")
            },
            onExitSuccess: { metadata in
                print("onExitSuccess: \(metadata)")
                if let connId = metadata.connectionId {
                    connectionId = connId
                }
                showHomeView = true
            },
            onExitAbort: { metadata in
                print("onExitAbort: \(metadata)")
                showHomeView = true
            },
            onExitError: { metadata in
                print("onExitError: \(metadata)")
                showHomeView = true
            }
        )
        
        return webview
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Update the WKWebView if needed
    }
}
```

### Reconnect Flow

```swift
struct ReconnectView: UIViewRepresentable {
    @Binding var showHomeView: Bool
    @State private var config = QuilttConnectorReconnectConfiguration(
        connectorId: "<CONNECTOR_ID>",
        oauthRedirectUrl: "<YOUR_HTTPS_UNIVERSAL_LINK>",
        connectionId: "<CONNECTION_ID>" // Required for reconnect
    )
    
    func makeUIView(context: Context) -> WKWebView {
        let quilttConnector = QuilttConnector()
        quilttConnector.authenticate(token: "<SESSION_TOKEN>")
        
        // Launch Reconnect Flow
        let webview = quilttConnector.reconnect(
            config: config,
            onEvent: { eventType, metadata in
                print("onEvent \(eventType): \(metadata)")
            },
            onExitSuccess: { metadata in
                print("onExitSuccess: \(metadata)")
                showHomeView = true
            },
            onExitAbort: { metadata in
                print("onExitAbort: \(metadata)")
                showHomeView = true
            },
            onExitError: { metadata in
                print("onExitError: \(metadata)")
                showHomeView = true
            }
        )
        
        return webview
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
}
```

### UIKit Implementation

```swift
import UIKit
import QuilttConnector
import WebKit

class ConnectorViewController: UIViewController {
    private var quilttConnector: QuilttConnector!
    private var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupQuilttConnector()
    }
    
    private func setupQuilttConnector() {
        quilttConnector = QuilttConnector()
        quilttConnector.authenticate(token: "<SESSION_TOKEN>")
        
        let config = QuilttConnectorConnectConfiguration(
            connectorId: "<CONNECTOR_ID>",
            oauthRedirectUrl: "<YOUR_HTTPS_UNIVERSAL_LINK>"
        )
        
        webView = quilttConnector.connect(
            config: config,
            onEvent: { [weak self] eventType, metadata in
                print("onEvent \(eventType): \(metadata)")
            },
            onExitSuccess: { [weak self] metadata in
                print("onExitSuccess: \(metadata)")
                self?.handleConnectionSuccess(metadata)
            },
            onExitAbort: { [weak self] metadata in
                print("onExitAbort: \(metadata)")
                self?.dismiss(animated: true)
            },
            onExitError: { [weak self] metadata in
                print("onExitError: \(metadata)")
                self?.handleConnectionError(metadata)
            }
        )
        
        // Add webView to view hierarchy
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func handleConnectionSuccess(_ metadata: ConnectorSDKCallbackMetadata) {
        // Handle successful connection
        dismiss(animated: true)
    }
    
    private func handleConnectionError(_ metadata: ConnectorSDKCallbackMetadata) {
        // Handle connection error
        dismiss(animated: true)
    }
}
```

## Universal Link Configuration

For OAuth redirect flows to work properly, you must configure Universal Links in your iOS app to handle the `oauthRedirectUrl` parameter.

### 1. Enable Associated Domains

In your Xcode project:

1. Select your app target
2. Go to **Signing & Capabilities**
3. Add **Associated Domains** capability
4. Add your domain: `applinks:your-app-domain.com`

### 2. Create apple-app-site-association File

Host this file at `https://your-app-domain.com/.well-known/apple-app-site-association`:

```json
{
  "applinks": {
    "apps": [],
    "details": [
      {
        "appID": "TEAMID.com.yourcompany.yourapp",
        "paths": ["/quiltt/oauth/*", "/auth/*"]
      }
    ]
  }
}
```

### 3. Handle Universal Links in Your App

```swift
import SwiftUI

@main
struct YourApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    handleUniversalLink(url)
                }
        }
    }
    
    private func handleUniversalLink(_ url: URL) {
        print("Received Universal Link: \(url)")
        
        // Handle OAuth redirect
        if url.path.hasPrefix("/quiltt/oauth/") {
            // Process OAuth callback
            // Extract parameters and handle redirect
        }
    }
}
```

### 4. URL Scheme Fallback (Optional)

Add a custom URL scheme in `Info.plist` as a fallback:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>quiltt.connector</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>your-app-scheme</string>
        </array>
    </dict>
</array>
```

## API Reference

### QuilttConnector

Main SDK class for managing connections.

#### Methods

```swift
func authenticate(token: String)
```

Authenticates the SDK with a session token.

```swift
func connect(
    config: QuilttConnectorConnectConfiguration,
    onEvent: ConnectorSDKOnEventCallback? = nil,
    onExit: ConnectorSDKOnEventExitCallback? = nil,
    onExitSuccess: ConnectorSDKOnExitSuccessCallback? = nil,
    onExitAbort: ConnectorSDKOnExitAbortCallback? = nil,
    onExitError: ConnectorSDKOnExitErrorCallback? = nil
) -> WKWebView
```

Launches the connect flow and returns a configured WKWebView.

```swift
func reconnect(
    config: QuilttConnectorReconnectConfiguration,
    onEvent: ConnectorSDKOnEventCallback? = nil,
    onExit: ConnectorSDKOnEventExitCallback? = nil,
    onExitSuccess: ConnectorSDKOnExitSuccessCallback? = nil,
    onExitAbort: ConnectorSDKOnExitAbortCallback? = nil,
    onExitError: ConnectorSDKOnExitErrorCallback? = nil
) -> WKWebView
```

Launches the reconnect flow for existing connections.

### Configuration Types

#### QuilttConnectorConnectConfiguration

```swift
public struct QuilttConnectorConnectConfiguration {
    public var connectorId: String
    public var oauthRedirectUrl: String
    public var institution: String? // Optional institution filter
}
```

#### QuilttConnectorReconnectConfiguration

```swift
public struct QuilttConnectorReconnectConfiguration {
    public var connectorId: String
    public var oauthRedirectUrl: String
    public var connectionId: String // Required for reconnect
}
```

### Event Types

```swift
public enum ConnectorSDKEventType: String {
    case Load = "loaded"
    case ExitSuccess = "exited.successful"
    case ExitAbort = "exited.aborted"
    case ExitError = "exited.errored"
}
```

### Callback Metadata

```swift
public struct ConnectorSDKCallbackMetadata {
    public let connectorId: String
    public let profileId: String?
    public let connectionId: String?
}
```

## Troubleshooting

### Common Issues

**WebView shows white screen after authentication:**

- Verify your `oauthRedirectUrl` is properly configured
- Ensure Universal Links are set up correctly
- Check that your redirect URL uses HTTPS scheme

**Universal Link not opening app:**

- Confirm your `apple-app-site-association` file is accessible
- Verify the Associated Domains capability is enabled
- Test Universal Link with Safari or Notes app

**OAuth redirect not working:**

- Ensure your app's Universal Link matches the `oauthRedirectUrl`
- Verify your domain's SSL certificate is valid
- Check that the redirect URL leads back to your app

**Callbacks not firing:**

- Ensure you're handling the OAuth redirect properly in your app
- Check that the redirect URL leads back to your app
- Verify the `connectorId` is correct

### Debug Mode

Enable debug logging to troubleshoot issues:

```swift
#if DEBUG
print("Quiltt SDK running in debug mode")
// Additional debug configuration
#endif
```

### Testing Universal Links

Test your Universal Links using Safari:

1. Open Safari on your iOS device
2. Type your Universal Link URL: `https://your-app-domain.com/quiltt/oauth/test`
3. Your app should open automatically

## Requirements

- **iOS 14.0+**
- **Swift 5.9+**
- **Xcode 15.0+**

## Releases

This SDK uses automated releases. When maintainers merge PRs with release labels, new versions are automatically published to the Swift Package Index.

**Latest Version:** Check the [Releases page](https://github.com/quiltt/quiltt-ios/releases) for the current version.

For release process details, see [RELEASING.md](RELEASING.md).

## Contributing

We welcome contributions! Please see our [contributing guidelines](CONTRIBUTING.md) for more information.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
