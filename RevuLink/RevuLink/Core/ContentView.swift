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
    private var loginURL: String = "https://app.revulink.net/login/?app"
    private var dashboardURL: String = "https://app.revulink.net/dashboard/"
    // Force view refresh when navigating
    @State private var navigationCounter = 0
    // Track the current URL being displayed
    @State private var currentURL: String = "https://app.revulink.net"
    // AppStorage to track if user is remembered
    @AppStorage("isUserRemembered") private var isUserRemembered = false
    // State to track loading state during login process
    @State private var isLoadingAuthentication = false
    
    var body: some View {
        NavigationStack {
            // MARK: - Main View Structure
            ZStack {
                if showSplashScreen {
                    SplashScreenView()
                        .transition(CustomSplashTransition(isRoot: true))
                } else {
                    if showIntroView {
                        IntroView(isUserRemembered: isUserRemembered) {
                            showIntroView = false
                            if isUserRemembered {
                                isLoadingAuthentication = true
                                currentURL = loginURL
                            } else {
                                currentURL = loginURL
                            }
                        }
                    } else {
                        ZStack {
                            WebView(
                                webLink: currentURL,
                                onBackButtonPressed: handleBackNavigation,
                                onRememberMeChanged: handleRememberMeChanged,
                                onPageFinishedLoading: handlePageFinishedLoading
                            )
                            .ignoresSafeArea()
                            .id("\(currentURL)-\(navigationCounter)")

                            if isLoadingAuthentication {
                                Color.black.opacity(0.6)
                                    .edgesIgnoringSafeArea(.all)
                                
                                VStack {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle())
                                        .scaleEffect(2.0)
                                        .padding()
                                    
                                    Text("Authenticating...")
                                        .foregroundColor(.white)
                                        .font(.headline)
                                        .padding()
                                }
                            }
                        }
                    }
                }
            }
            .task {
                if isUserRemembered {
                    currentURL = loginURL
                } else {
                    currentURL = loginURL
                }
                
                try? await Task.sleep(for: .seconds(0.5))
                withAnimation(.smooth(duration: 0.55)) {
                    showSplashScreen = false
                }
            }
        }
    }
    
    // MARK: - Navigation Handler
    private func handleBackNavigation(currentWebURL: String) -> Bool {
        if currentWebURL.contains("/login/") {
            currentURL = loginURL
            navigationCounter += 1
            return true
        }
        return false
    }
    
    // MARK: - Remember Me Handler
    private func handleRememberMeChanged(isRemembered: Bool) {
        print("Remember me state changed to: \(isRemembered)")
        isUserRemembered = isRemembered
    }
    
    // MARK: - Page Finished Loading Handler
    private func handlePageFinishedLoading(url: String) {
        print("Page finished loading: \(url)")
        if isLoadingAuthentication {
            if url.contains("/login/") {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    print("Redirecting to dashboard after login page loaded")
                    currentURL = dashboardURL
                    navigationCounter += 1
                }
            }
            if url.contains("/dashboard/") {
                print("Dashboard loaded, hiding authentication overlay")
                isLoadingAuthentication = false
            }
        }
    }
}

#Preview {
    ContentView()
}
