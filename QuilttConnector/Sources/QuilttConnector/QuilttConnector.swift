// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import Foundation
import WebKit

public class QuilttConnector {
    private var token: String?
    private var connectorId: String?
    private var connectionId: String?
    
    public init() {
        print("QuilttConnector init")
    }
    
    public func authenticate(token: String) {
        self.token = token
        print("authenticate token: \(self.token!)")
        // TODO: figure out how to send js to webview here
        // webview.injectJavascriptSomething
    }
    
    public func connect(config: QuilttConnectorConnectConfiguration) -> WKWebView { // add callbacks
        var webview = QuilttConnectorWebview.init()
        webview.load(token: self.token, config: config)
        return webview
    }
    
    public func reconnect(config: QuilttConnectorReconnectConfiguration) -> WKWebView { // add callbacks
        var webview = QuilttConnectorWebview.init()
        webview.load(token: self.token, config: config)
        return webview
    }
}
