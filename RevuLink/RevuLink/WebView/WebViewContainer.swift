//
//  WebViewContainer.swift
//  RevuLink
//
//  Created by Abdul Moiz on 02/05/2025.
//

import Foundation
import SwiftUI
import WebKit
// MARK: - WebViewContainer
/// A SwiftUI wrapper for WKWebView using UIViewRepresentable.
/// Binds back-navigation, loading state and current page, and allows coordination via a delegate.
struct WebViewContainer: UIViewRepresentable {
    // MARK: - Properties
    let url: URL
    @Binding var canGoBack: Bool
    @Binding var isLoading: Bool
    @Binding var currentLoadedURL: String
    let webView: WKWebView
    
    func makeUIView(context: Context) -> WKWebView {
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebViewContainer
        
        init(_ parent: WebViewContainer) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.isLoading = true
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.isLoading = false
            parent.canGoBack = webView.canGoBack
            if let currentURL = webView.url?.absoluteString {
                parent.currentLoadedURL = currentURL
                print("Currently loaded URL: \(currentURL)")
            }
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.isLoading = false
        }
    }
}
