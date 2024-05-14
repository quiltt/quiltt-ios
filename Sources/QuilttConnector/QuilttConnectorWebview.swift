// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import Foundation
import WebKit

class QuilttConnectorWebview: WKWebView, WKNavigationDelegate {
    public var config: QuilttConnectorConfiguration?
    public var token: String?
    public var onEvent: ConnectorSDKOnEventCallback?
    public var onExit: ConnectorSDKOnEventExitCallback?
    public var onExitSuccess: ConnectorSDKOnExitSuccessCallback?
    public var onExitAbort: ConnectorSDKOnExitAbortCallback?
    public var onExitError: ConnectorSDKOnExitErrorCallback?

    public init() {
        let webConfiguration = WKWebViewConfiguration()
        super.init(frame: .zero, configuration: webConfiguration)
        if #available(iOS 14.0, *) {
            self.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        } else {
            self.configuration.preferences.javaScriptEnabled = true
        }
        self.scrollView.isScrollEnabled = true
        self.isMultipleTouchEnabled = false
        /** Enable isInspectable to debug webview */
        //  if #available(iOS 16.4, *) {
        //  self.isInspectable = true
        //  }
        self.navigationDelegate = self // to manage navigation behavior for the webview.
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    @discardableResult
    public func load(token: String? = nil,
                     config: QuilttConnectorConfiguration,
                     onEvent: ConnectorSDKOnEventCallback? = nil,
                     onExit: ConnectorSDKOnEventExitCallback? = nil,
                     onExitSuccess: ConnectorSDKOnExitSuccessCallback? = nil,
                     onExitAbort: ConnectorSDKOnExitAbortCallback? = nil,
                     onExitError: ConnectorSDKOnExitErrorCallback? = nil) -> WKNavigation? {
        self.token = token
        self.config = config
        self.onEvent = onEvent
        self.onExit = onExit
        self.onExitSuccess = onExitSuccess
        self.onExitAbort = onExitAbort
        self.onExitError = onExitError
        if let url = URL(string: "https://\(config.connectorId).quiltt.app?mode=webview&oauth_redirect_url=\(config.oauthRedirectUrl)&agent=ios-\(quilttSdkVersion)") {
            let req = URLRequest(url: url)
            return super.load(req)
        }
        return nil
    }

    /**
     urlAllowList & shouldRender ensure we are only rendering Quiltt, MX and Plaid content in Webview
     For other urls, we assume those are bank urls, which needs to be handle in external browser.

     https://developer.apple.com/documentation/webkit/wknavigationdelegate/1455641-webview
     */
    public func webView(_ webView: WKWebView,
                        decidePolicyFor navigationAction: WKNavigationAction,
                        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let url = navigationAction.request.url {
            // Intercept the URL here
            print("Intercepted URL: \(url)")
            if isQuilttEvent(url) {
                handleQuilttEvent(url)
                decisionHandler(.cancel)
                return
            }
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

    // TODO: FIXME, not sure how this func can fit into here
    public func authenticate(_ token: String) -> Void {
        self.token = token
        self.initInjectJavaScript()
    }

    private func initInjectJavaScript() -> Void {
        let tokenString = token ?? "null"

        let connectorId = config!.connectorId
        let connectionId = config?.connectionId ?? "null"
        let institution = config?.institution ?? "null"
        let script = """
            const options = {
              source: 'quiltt',
              type: 'Options',
              token: '\(tokenString)',
              connectorId: '\(connectorId)',
              connectionId: '\(connectionId)',
              institution: '\(institution)',
            };
            const compactedOptions = Object.keys(options).reduce((acc, key) => {
              if (options[key] !== 'null') {
                acc[key] = options[key];
              }
              return acc;
            }, {});
            window.postMessage(compactedOptions);
        """
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
        let metaData = ConnectorSDKCallbackMetadata(connectorId: connectorId!, profileId: profileId, connectionId: connectionId)
        print("handleQuilttEvent \(url)")
        switch url.host {
        case "Load":
            initInjectJavaScript()
            self.onEvent?(ConnectorSDKEventType.Load, metaData)
            break
        case "ExitAbort":
            clearLocalStorage()
            self.onEvent?(ConnectorSDKEventType.ExitAbort, metaData)
            self.onExit?(ConnectorSDKEventType.ExitAbort, metaData)
            self.onExitAbort?(metaData)
            break
        case "ExitError":
            clearLocalStorage()
            self.onEvent?(ConnectorSDKEventType.ExitError, metaData)
            self.onExit?(ConnectorSDKEventType.ExitError, metaData)
            self.onExitError?(metaData)
            break
        case "ExitSuccess":
            clearLocalStorage()
            self.onEvent?(ConnectorSDKEventType.ExitSuccess, metaData)
            self.onExit?(ConnectorSDKEventType.ExitSuccess, metaData)
            self.onExitSuccess?(metaData)
            break
        case "Authenticate":
            // Not used in mobile but leaving breadcrumb here.
            print("Authenticate \(String(describing: profileId))")
            break
        case "OauthRequested":
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
    
    // TODO: Need to regroup on this and figure out how to handle this better
    // private var urlAllowList = [
    //     "quiltt.app",
    //     "quiltt.dev",
    //     "moneydesktop.com",
    //     "cdn.plaid.com",
    // ]
    
    private func shouldRender(_ url: URL) -> Bool {
        if isQuilttEvent(url) {
            return false
        }
        // for allowedUrl in urlAllowList {
        //     if url.absoluteString.contains(allowedUrl) {
        //         return true
        //     }
        // }
        return true
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
