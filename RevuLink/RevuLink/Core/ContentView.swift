//
//  ContentView.swift
//  RevuLink
//
//  Created by Abdul Moiz on 02/05/2025.
//

import SwiftUI
import WebKit

struct ContentView: View {
    @State private var showSplashScreen = true
    private var webURL: String = "https://app.revulink.net"

    var body: some View {
        NavigationStack {
            ZStack {
                if showSplashScreen {
                    SplashScreenView()
                        .transition(CustomSplashTransition(isRoot: true))
                } else {
                    WebView(webLink: webURL)
                        .ignoresSafeArea()
                }
            }
            .task {
                try? await Task.sleep(for: .seconds(0.5))
                withAnimation(.smooth(duration: 0.55)) {
                    showSplashScreen = false
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
