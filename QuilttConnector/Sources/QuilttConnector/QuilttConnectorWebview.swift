// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import Foundation
import WebKit

class QuilttConnectorWebview: WKWebView, WKNavigationDelegate {
    public var config: QuilttConnectorConfiguration?
    public var token: String?

    public init() {
        let webConfiguration = WKWebViewConfiguration()
        super.init(frame: .zero, configuration: webConfiguration)
        self.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        self.scrollView.isScrollEnabled = true
        self.isMultipleTouchEnabled = false
        self.navigationDelegate = self // to manage navigation behavior for the web view.
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    @discardableResult
    public func load(token: String? = nil, config: QuilttConnectorConfiguration) -> WKNavigation? {
        self.token = token
        self.config = config
        if let url = URL(string:"https://\(config.connectorId).quiltt.app?mode=webview&oauth_redirect_url=\(config.oauthRedirectUrl)&sdk=swift") {
            print(url)
            let req = URLRequest(url: url)
            print(req)
            return super.load(req)
        }
        return nil
    }

    //https://developer.apple.com/documentation/webkit/wknavigationdelegate/1455641-webview
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url {
            // Intercept the URL here
            print("Intercepted URL: \(url)")
            print("url.host \(url.host!)")
            if isQuilttEvent(url: url) {
                handleQuilttEvent(url: url)
                decisionHandler(.cancel)
                return
            }
            if shouldRender(url: url) {
                decisionHandler(.allow)
                return
            }
            decisionHandler(.allow)
            return
        } else {
            decisionHandler(.cancel)
            return
        }
    }
    
    private func initInjectedJavaScript() -> String {
        var tokenString = token ?? "null"
        var connectorId = config!.connectorId
        var connectionId = config?.connectionId ?? "null"
        var script = """
            const options = {
              source: 'quiltt',
              type: 'Options',
              token: '\(tokenString)',
              connectorId: '\(connectorId)',
              connectionId: '\(connectionId)',
            };
            const compactedOptions = Object.keys(options).reduce((acc, key) => {
              if (options[key] !== 'null') {
                acc[key] = options[key];
              }
              return acc;
            }, {});
            window.postMessage(compactedOptions);
        """
        return script
    }
    
    private func handleQuilttEvent(url: URL) {
        switch url.host {
        case "Load":
            var script = initInjectedJavaScript()
            self.evaluateJavaScript(script)
            print("handleQuilttEvent \(url.host!)")
            break
        case "ExitAbort":
            print("ExitAbort \(url)")
            break
        case "ExitError":
            print("ExitError \(url)")
            break
        case "ExitSuccess":
            print("ExitSuccess \(url)")
            break
        case "Authenticate":
            print("Authenticate \(url)")
            break
        case "OauthRequested":
            print("OauthRequested \(url)")
            var urlc = URLComponents(string: url.absoluteString)
            var oauthUrlString = urlc?.queryItems?.first?.value
            var oauthUrl = URL(string: oauthUrlString!)!
            handleOAuthUrl(oauthUrl: oauthUrl)
            break
        default:
            print("unhandled event \(url.absoluteString)")
        }
    }
    
    private var allowedListUrl = [
        "quiltt.app",
        "quiltt.dev",
        "moneydesktop.com",
        "cdn.plaid.com/link/v2/stable/link.html",
    ]
    
    private func shouldRender(url: URL) -> Bool {
        for allowedUrl in allowedListUrl {
            if allowedUrl.contains(url.absoluteString) {
                return true
            }
        }
        return false
    }
    
    private func handleOAuthUrl(oauthUrl: URL) {
        print("handleOAuthUrl \(oauthUrl)")
        if (!oauthUrl.absoluteString.hasPrefix("https://")) {
            print("handleOAuthUrl - Skipping non https url - \(oauthUrl)")
            return
        }
        UIApplication.shared.open(oauthUrl)
    }
    
    private func isQuilttEvent(url: URL) -> Bool {
        return url.absoluteString.hasPrefix("quilttconnector://")
    }
}
