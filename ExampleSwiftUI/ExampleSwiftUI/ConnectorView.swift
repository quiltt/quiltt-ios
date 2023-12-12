//
//  ConnectorView.swift
//  ExampleSwiftUIQuilttConnector
//
//  Created by Tom Lee on 12/1/23.
//

import SwiftUI
import QuilttConnector
import WebKit

struct ConnectorView: View {
    var body: some View {
        WebView()
    }
}

struct WebView: UIViewRepresentable {
    @State var config = QuilttConnectorConnectConfiguration(
        connectorId: "mobile-sdk-sandbox",
//        connectionId: "<CONNECTION_ID>", For reconnect
        oauthRedirectUrl: "https://www.example.com"
    )

    func makeUIView(context: Context) -> WKWebView {
        let quilttConnector = QuilttConnector.init()
        quilttConnector.authenticate(token: "eyJhbGciOiJIUzUxMiJ9.eyJuYmYiOjE3MDIyNzgzMjMsImlhdCI6MTcwMjI3ODMyMywianRpIjoiM2FmNzJlZTMtMzlmZi00MGJkLTkyN2YtNjUzMjYyNTQxNDRiIiwiaXNzIjoiYXV0aC5xdWlsdHQuaW8iLCJhdWQiOiJhcGkucXVpbHR0LmlvIiwiZXhwIjoxNzAyMzY0NzIzLCJ2ZXIiOjQsInN1YiI6InBfMTY3SERMQXFuV05VSURIN0tVQXdyMVoiLCJkaWQiOiJhcGlfMTJ2NTdrTzJMOUpmMTBuTlJvOEY5MSIsIm9pZCI6Im9yZ18xN1I5cFlJV090YTlmaUlITEN2RDF5NSIsImVpZCI6ImVudl8xNUo2R1QydEl0bGE5cmhVTmZNVVVpMSJ9.pD-26WMwr-Ne77PrnnoqRCGxj7W07z15kErt2-9GWErRnbiFk5KACuvyNM37czW5jSLDOSnuio0MibGQxgcEnA")
        return quilttConnector.connect(config: config)
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Use this method to update the WKWebView with new configuration settings.
    }
}

#Preview {
    ConnectorView()
}
