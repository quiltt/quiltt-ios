// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import Foundation
import WebKit

public class QuilttConnector {
    private var webview: QuilttConnectorWebview?
    private var token: String?
    private var connectorId: String?
    private var connectionId: String?
    
    public init() {
        print("QuilttConnector init")
        webview = QuilttConnectorWebview.init()
    }
    
    public func authenticate(token: String) {
        self.token = token
        print("authenticate token: \(self.token!)")
    }
    
    public func connect(config: QuilttConnectorConnectConfiguration,
                        onEvent: ConnectorSDKOnEventCallback? = nil,
                        onExitSuccess: ConnectorSDKOnExitSuccessCallback? = nil,
                        onExitAbort: ConnectorSDKOnExitAbortCallback? = nil,
                        onExitError: ConnectorSDKOnExitErrorCallback? = nil) -> WKWebView {
        webview!.load(token: self.token, config: config)
        return webview!
    }
    
    public func reconnect(config: QuilttConnectorReconnectConfiguration,
                          onEvent: ConnectorSDKOnEventCallback? = nil,
                          onExitSuccess: ConnectorSDKOnExitSuccessCallback? = nil,
                          onExitAbort: ConnectorSDKOnExitAbortCallback? = nil,
                          onExitError: ConnectorSDKOnExitErrorCallback? = nil) -> WKWebView {
        webview!.load(token: self.token, config: config)
        return webview!
    }

    public func teardown() -> Void {
        webview?.stopLoading()
        webview?.removeFromSuperview()
        webview?.navigationDelegate = nil
        webview?.uiDelegate = nil
        webview = nil
    }
}
