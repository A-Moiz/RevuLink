//
//  ContentView.swift
//  RevuLink
//
//  Created by Abdul Moiz on 02/05/2025.
//

import SwiftUI
import WebKit

// MARK: - ContentView
/// The main entry point of the app, responsible for displaying the splash screen, intro view, and web content.
/// It manages the navigation flow between these views based on state changes.
struct ContentView: View {
    // MARK: - Properties
    // State to track whether the splash screen is visible
    @State private var showSplashScreen = true
    // State to track whether the intro view is visible
    @State private var showIntroView = true
    // URLs for the web content to display
    private var webURL: String = "https://app.revulink.net"
    private var loginURL: String = "https://app.revulink.net/login/"
    // Force view refresh when navigating
    @State private var navigationCounter = 0
    // Track the current URL being displayed
    @State private var currentURL: String = "https://app.revulink.net"
    
    var body: some View {
        NavigationStack {
            // MARK: - Main View Structure
            ZStack {
                // Display splash screen while showSplashScreen is true
                if showSplashScreen {
                    SplashScreenView()
                        .transition(CustomSplashTransition(isRoot: true))
                } else {
                    // After splash screen, display either the intro view or web view
                    if showIntroView {
                        IntroView {
                            // When continuing from intro, go to login URL
                            currentURL = loginURL
                            showIntroView = false
                        }
                    } else {
                        // Web view will display the current URL
                        WebView(webLink: currentURL, onBackButtonPressed: handleBackNavigation)
                            .ignoresSafeArea()
                        // Force recreate the view when URL changes
                            .id("\(currentURL)-\(navigationCounter)")
                    }
                }
            }
            // MARK: - Task to Remove Caches and Data
            .task {
                // Clear cookies and cache to prevent any stored data issues
                HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
                URLCache.shared.removeAllCachedResponses()
                
                // Remove all website data stored in WKWebView's data store
                let dataStore = WKWebsiteDataStore.default()
                dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
                    dataStore.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), for: records) {}
                }
                
                // Set the initial URL to the main web URL
                currentURL = webURL
                
                // Adding a delay before transitioning from splash screen
                try? await Task.sleep(for: .seconds(0.5))
                // MARK: - Transition Splash Screen to the Next View
                withAnimation(.smooth(duration: 0.55)) {
                    showSplashScreen = false
                }
            }
        }
    }
    
    // MARK: - Navigation Handler
    private func handleBackNavigation(currentWebURL: String) -> Bool {
        // Check if the current URL contains the login path
        if currentWebURL.contains("/login/") {
            currentURL = webURL
            navigationCounter += 1
            return true
        }
        return false
    }
}

#Preview {
    ContentView()
}
