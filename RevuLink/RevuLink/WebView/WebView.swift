//
//  WebView.swift
//  RevuLink
//
//  Created by Abdul Moiz on 02/05/2025.
//

import SwiftUI
import WebKit

struct WebView: View {
    // MARK: - Properties
    /// The web link to be loaded.
    @State var webLink: String
    /// Tracks whether the web view can navigate back.
    @State private var canGoBack = false
    /// Indicates if the web content is still loading.
    @State private var isLoading = true
    /// Tracks the current URL that's actually loaded in the webview
    @State private var currentLoadedURL: String = ""
    /// Used to dismiss the view if navigation can't go back.
    @Environment(\.dismiss) var dismiss
    /// The actual WKWebView instance being controlled.
    private let webView = WKWebView()
    /// Custom back button handler to override default back navigation
    var onBackButtonPressed: ((String) -> Bool)? = nil
    /// Callback for when the "remember me" state changes
    var onRememberMeChanged: ((Bool) -> Void)? = nil
    /// Callback for when a page finishes loading
    var onPageFinishedLoading: ((String) -> Void)? = nil
    
    // MARK: - Body
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                WebViewContainer(
                    url: URL(string: webLink)!,
                    canGoBack: $canGoBack,
                    isLoading: $isLoading,
                    currentLoadedURL: $currentLoadedURL,
                    webView: webView,
                    onRememberMeChanged: onRememberMeChanged,
                    onPageFinishedLoading: onPageFinishedLoading
                )
                .ignoresSafeArea()
            }

            // Loading spinner while content is loading
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
            }
        }
//        // MARK: - Toolbar Navigation
//        .toolbar {
//            ToolbarItem(placement: .navigationBarLeading) {
//                Button(action: {
//                    if let onBackButtonPressed = onBackButtonPressed, onBackButtonPressed(currentLoadedURL) {
//                        return
//                    } else if webView.canGoBack {
//                        webView.goBack()
//                    } else {
//                        dismiss()
//                    }
//                }) {
//                    NavigationBackButton()
//                }
//            }
//        }
        // MARK: - onAppear: Load Web Request
        .onAppear {
            print("onAppear: Loading \(webLink)")
            loadWebURL(webLink)
        }
        // MARK: - onChange: Handle URL updates
        .onChange(of: webLink) { oldValue, newValue in
            print("onChange: WebLink changed from \(oldValue) to \(newValue)")
            loadWebURL(newValue)
        }
    }
    
    // MARK: - Helper function to load a URL
    private func loadWebURL(_ urlString: String) {
        let request = URLRequest(
            url: URL(string: urlString)!,
            cachePolicy: .reloadIgnoringLocalCacheData
        )
        print("Loading URL: \(urlString)")
        webView.load(request)
    }
}
