import SwiftUI
import QuilttConnector
import WebKit

struct ConnectorView: View {
    @Binding var showHomeView: Bool
    @Binding var connectionId: String
    var body: some View {
        WebView(showHomeView: $showHomeView, connectionId: $connectionId)
    }
}

struct WebView: UIViewRepresentable {
    @Binding var showHomeView: Bool
    @Binding var connectionId: String
    @State var config = QuilttConnectorConnectConfiguration(
        connectorId: "mobile-sdk-sandbox",
//        connectionId: "<CONNECTION_ID>", For reconnect
        oauthRedirectUrl: "https://tom-quiltt.github.io/expo-redirect/swift"
    )

    func makeUIView(context: Context) -> WKWebView {
        let quilttConnector = QuilttConnector.init()
        quilttConnector.authenticate(token: "eyJhbGciOiJIUzUxMiJ9.eyJuYmYiOjE3MDI1MDc4MTUsImlhdCI6MTcwMjUwNzgxNSwianRpIjoiYzgxMmFhM2YtMTJjMy00NjlhLTliMjktMmQ1NmJkMzFjNWQxIiwiaXNzIjoiYXV0aC5xdWlsdHQuaW8iLCJhdWQiOiJhcGkucXVpbHR0LmlvIiwiZXhwIjoxNzAyNTk0MjE1LCJ2ZXIiOjQsInN1YiI6InBfMTY3SERMQXFuV05VSURIN0tVQXdyMVoiLCJkaWQiOiJhcGlfMTJ2NTdrTzJMOUpmMTBuTlJvOEY5MSIsIm9pZCI6Im9yZ18xN1I5cFlJV090YTlmaUlITEN2RDF5NSIsImVpZCI6ImVudl8xNUo2R1QydEl0bGE5cmhVTmZNVVVpMSJ9.0-6b3C4MjR2huBtIHVq2nFRMXg1T_ePXb_0FLOtXuF-sS-9v0ZttCHFF9kLwbLyIOU6A6xdcBNgQxQabsyelWw")
        let webview = quilttConnector.connect(config: config,
                                              onEvent: { eventType, metadata in
                                                print("onEvent \(eventType), \(metadata)")
                                              },
                                              onExitSuccess: { metadata in
                                                print("onExitSuccess \(metadata)")
                                                connectionId = metadata.connectionId!
                                                showHomeView = true
                                                // TODO: Maybe use @Binding to show connection id to HomeView
                                              },
                                              onExitAbort: { metadata in
                                                print("onExitAbort \(metadata)")
                                                showHomeView = true
                                              },
                                              onExitError: { metadata in
                                                print("onExitError \(metadata)")
                                                showHomeView = true
                                              })
        return webview
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Use this method to update the WKWebView with new configuration settings.
    }
}

#Preview {
    ConnectorView(showHomeView: .constant(false), connectionId: .constant("connectionId"))
}
