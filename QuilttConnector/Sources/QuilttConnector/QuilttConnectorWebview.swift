// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import Foundation
import WebKit

class QuilttConnectorWebview: WKWebView, WKNavigationDelegate {
    public var config: QuilttConnectorConfiguration?
    public var token: String?
    public var onEvent: ConnectorSDKOnEventCallback?
    public var onExitSuccess: ConnectorSDKOnExitSuccessCallback?
    public var onExitAbort: ConnectorSDKOnExitAbortCallback?
    public var onExitError: ConnectorSDKOnExitErrorCallback?

    public init() {
        let webConfiguration = WKWebViewConfiguration()
        super.init(frame: .zero, configuration: webConfiguration)
        self.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        self.scrollView.isScrollEnabled = true
        self.isMultipleTouchEnabled = false
        self.navigationDelegate = self // to manage navigation behavior for the webview.
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    @discardableResult
    public func load(token: String? = nil,
                     config: QuilttConnectorConfiguration,
                     onEvent: ConnectorSDKOnEventCallback? = nil,
                     onExitSuccess: ConnectorSDKOnExitSuccessCallback? = nil,
                     onExitAbort: ConnectorSDKOnExitAbortCallback? = nil,
                     onExitError: ConnectorSDKOnExitErrorCallback? = nil) -> WKNavigation? {
        self.token = token
        self.config = config
        self.onEvent = onEvent
        self.onExitSuccess = onExitSuccess
        self.onExitAbort = onExitAbort
        self.onExitError = onExitError
        if let url = URL(string: "https://\(config.connectorId).quiltt.app?mode=webview&oauth_redirect_url=\(config.oauthRedirectUrl)&sdk=swift") {
            print(url)
            let req = URLRequest(url: url)
            print(req)
            return super.load(req)
        }
        return nil
    }

    /**
     allowedListUrl & shouldRender ensure we are only rendering Quiltt, MX and Plaid content in Webview
     For other urls, we assume those are bank urls, which needs to be handle in external browser.

     https://developer.apple.com/documentation/webkit/wknavigationdelegate/1455641-webview
     */
    public func webView(_ webView: WKWebView,
                        decidePolicyFor navigationAction: WKNavigationAction,
                        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("webview \(navigationAction)")
        if let url = navigationAction.request.url {
            // Intercept the URL here
            print("Intercepted URL: \(url)")
            print("isQuilttEvent \(isQuilttEvent(url))")
            if isQuilttEvent(url) {
                handleQuilttEvent(url)
                decisionHandler(.cancel)
                return
            }
            print("shouldRender \(shouldRender(url))")
            if shouldRender(url) {
                decisionHandler(.allow)
                return
            }
            handleOAuthUrl(url)
            decisionHandler(.cancel)
            return
        } else {
            decisionHandler(.cancel)
            return
        }
    }
    
//    TODO: FIXME, not sure how this func can fit into here
    public func authenticate(_ token: String) -> Void {
        self.token = token
        self.initInjectJavaScript()
    }

    private func initInjectJavaScript() -> Void {
        let tokenString = token ?? "null"

        let connectorId = config!.connectorId
        let connectionId = config?.connectionId ?? "null"
        let script = """
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
        print("initInjectJavaScript \(script)")
        self.evaluateJavaScript(script)
    }
    
    private func clearLocalStorage() -> Void {
        let script = "localStorage.clear()"
        self.evaluateJavaScript(script)
    }

    private func handleQuilttEvent(_ url: URL) -> Void {
        let urlComponents = URLComponents(string: url.absoluteString)
        let connectorId = config?.connectorId
        let profileId = urlComponents?.queryItems?.first(where: { $0.name == "profileId"})?.value
        let connectionId = urlComponents?.queryItems?.first(where: { $0.name == "connectionId"})?.value
        switch url.host {
        case "Load":
            initInjectJavaScript()
            print("handleQuilttEvent \(url.host!)")
            break
        case "ExitAbort":
            clearLocalStorage()
            print("ExitAbort \(url)")
            self.onExitAbort?(ConnectorSDKCallbackMetadata(connectorId: connectorId!, profileId: nil, connectionId: nil))
            break
        case "ExitError":
            clearLocalStorage()
            print("ExitError \(url)")
            self.onExitError?(ConnectorSDKCallbackMetadata(connectorId: connectorId!, profileId: nil, connectionId: nil))
            break
        case "ExitSuccess":
            clearLocalStorage()
            print("ExitSuccess \(url)")
            if connectionId != nil {
                self.onExitSuccess?(ConnectorSDKCallbackMetadata(connectorId: connectorId!, profileId: nil, connectionId: connectionId))
            }
            break
        case "Authenticate":
            // Not used in mobile but leaving breadcrumb here.
            print("Authenticate \(String(describing: profileId))")
            break
        case "OauthRequested":
            print("OauthRequested \(url)")
            if let urlc = URLComponents(string: url.absoluteString),
               let oauthUrlItem = urlc.queryItems?.first(where: { $0.name == "oauthUrl" }),
               let oauthUrlString = oauthUrlItem.value,
               let oauthUrl = URL(string: oauthUrlString) {
                handleOAuthUrl(oauthUrl)
            }
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
    
    private func shouldRender(_ url: URL) -> Bool {
        if isQuilttEvent(url) {
            return false
        }
        for allowedUrl in allowedListUrl {
            print("allowedUrl \(allowedUrl)")
            print("url.absoluteString \(url.absoluteString)")
            print("url.absoluteString.contains(allowedUrl) \(allowedUrl.contains(url.absoluteString))")
            if url.absoluteString.contains(allowedUrl) {
                return true
            }
        }
        return false
    }
    
    private func handleOAuthUrl(_ oauthUrl: URL) {
        if (!oauthUrl.absoluteString.hasPrefix("https://")) {
            print("handleOAuthUrl - Skipping non https url - \(oauthUrl)")
            return
        }
        UIApplication.shared.open(oauthUrl)
    }
    
    private func isQuilttEvent(_ url: URL) -> Bool {
        return url.absoluteString.hasPrefix("quilttconnector://")
    }
}
