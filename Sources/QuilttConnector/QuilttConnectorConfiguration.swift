// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import Foundation

public protocol QuilttConnectorConfiguration {
    var connectorId: String { get }
    var oauthRedirectUrl: String { get }
    var connectionId: String? { get }
}

public struct QuilttConnectorConnectConfiguration : QuilttConnectorConfiguration {
    public var connectorId: String
    public var oauthRedirectUrl: String
    public var connectionId: String?
    public init(
        connectorId: String,
        oauthRedirectUrl: String
    ){
        self.connectorId = connectorId
        self.oauthRedirectUrl = oauthRedirectUrl
    }
}

public struct QuilttConnectorReconnectConfiguration: QuilttConnectorConfiguration {
    public var connectorId: String
    public var oauthRedirectUrl: String
    public var connectionId: String?
    
    public init(
        connectorId: String,
        oauthRedirectUrl: String,
        connectionId: String? = nil
    ){
        self.connectorId = connectorId
        self.oauthRedirectUrl = oauthRedirectUrl
        self.connectionId = connectionId
    }
}

