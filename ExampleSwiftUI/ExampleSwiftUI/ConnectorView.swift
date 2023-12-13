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
        connectorId: "mobile-sdk-prod-test",
//        connectionId: "<CONNECTION_ID>", For reconnect
        oauthRedirectUrl: "https://tom-quiltt.github.io/expo-redirect/swift"
    )

    func makeUIView(context: Context) -> WKWebView {
        let quilttConnector = QuilttConnector.init()
        quilttConnector.authenticate(token: "eyJhbGciOiJIUzUxMiJ9.eyJuYmYiOjE3MDI0MTY4NDIsImlhdCI6MTcwMjQxNjg0MiwianRpIjoiMDgzYzlkNjgtYjA2ZC00NTNkLTlkYzEtZTQ0M2I0ZWM2Mzc5IiwiaXNzIjoiYXV0aC5xdWlsdHQuaW8iLCJhdWQiOiJhcGkucXVpbHR0LmlvIiwiZXhwIjoxNzAyNTAzMjQyLCJ2ZXIiOjQsInN1YiI6InBfMTJzajhSMzNoN250Q3RMcTZPUlZVUyIsImRpZCI6ImFwaV8xMnV0N3h2WGFHYjBTYk42eWtibXBWIiwib2lkIjoib3JnXzE3UjlwWUlXT3RhOWZpSUhMQ3ZEMXk1IiwiZWlkIjoiZW52XzE2ZGZrU1RzR3hRbjFZYUo4aDZTekxtIn0.zhhp5ndkV0YwqpMmI3DqB4--jAkUZAh02T2bvOFwHVDawqmRzP6Oivj38PtVjzrKQIaqdDZbGovhC9z91ygiSw")
        let webview = quilttConnector.connect(config: config,
                                              onEvent: { eventType, metadata in
                                                print("onEvent \(eventType), \(metadata)")
                                              },
                                              onExitSuccess: { metadata in
                                                print("onExitSuccess \(metadata)")
                                                // TODO: Maybe use @Binding to show connection id to HomeView
                                              },
                                              onExitAbort: { metadata in
                                                print("onExitAbort \(metadata)")
                                                // TODO: Figure out how to navigate back to HomeView
                                              },
                                              onExitError: { metadata in
                                                print("onExitError \(metadata)")
                                              })
        return webview
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Use this method to update the WKWebView with new configuration settings.
    }
}

#Preview {
    ConnectorView()
}
