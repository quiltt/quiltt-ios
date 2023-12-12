//
//  ContentView.swift
//  ExampleSwiftUIQuilttConnector
//
//  Created by Tom Lee on 12/1/23.
//

import SwiftUI
import QuilttConnector

struct HomeView: View {
    @State var connectionId = "No Connection ID"
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: ConnectorView().navigationBarBackButtonHidden(true)) {
                    Text("Launch Connector")
                }
                .padding()
                .background(Color(red: 0.3, green: 0, blue: 0.5, opacity: 1))
                .foregroundColor(.white)
                .font(.headline)
                .cornerRadius(10)
            }
            .navigationTitle("Home View")
        }
    }
}

#Preview {
    HomeView()
}
