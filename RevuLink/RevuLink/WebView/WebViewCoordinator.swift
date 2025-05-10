//
//  WebViewCoordinator.swift
//  RevuLink
//
//  Created by Abdul Moiz on 02/05/2025.
//

import Foundation
import WebKit
import PhotosUI
// MARK: - WebViewCoordinator
/// Coordinator for WebViewContainer that handles navigation and UI events in WKWebView.
class WebViewCoordinator: NSObject, WKNavigationDelegate {
    // MARK: - Properties
    /// Reference to the parent WebViewContainer to update its bindings.
    var parent: WebViewContainer
    
    // MARK: - Initializer
    init(parent: WebViewContainer) {
        self.parent = parent
    }
    
    // MARK: - WKNavigationDelegate Methods
    /// Called when navigation starts, sets isLoading to true.
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        parent.isLoading = true
    }

    /// Called when navigation finishes, updates canGoBack and isLoading.
    /// Also checks if the page is empty and reloads if needed.
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        parent.canGoBack = webView.canGoBack
        parent.isLoading = false

        // Check if the loaded content is empty or malformed
        webView.evaluateJavaScript("document.body.innerHTML") { (result, error) in
            if let html = result as? String {
                let trimmed = html.trimmingCharacters(in: .whitespacesAndNewlines)
                if trimmed.isEmpty || trimmed == "<body></body>" {
                    let request = URLRequest(url: self.parent.url, cachePolicy: .reloadIgnoringLocalCacheData)
                    webView.load(request)
                }
            }
        }
    }

    /// Called when navigation fails, sets isLoading to false.
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        parent.isLoading = false
    }

    /// Called when navigation fails during provisional stage, sets isLoading to false.
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        parent.isLoading = false
    }
}

// MARK: - WKUIDelegate
extension WebViewCoordinator: WKUIDelegate {
    /// Presents an alert dialog when JavaScript `alert()` is triggered in the web view.
    func webView(_ webView: WKWebView,
                 runJavaScriptAlertPanelWithMessage message: String,
                 initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping () -> Void) {

        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completionHandler()
        })

        // Attempt to present alert using the current view controller
        if let vc = webView.window?.rootViewController {
            vc.present(alert, animated: true, completion: nil)
        } else {
            completionHandler()
        }
    }

    /// Handles window.open() or target="_blank" by loading the request in the same web view.
    func webView(_ webView: WKWebView,
                 createWebViewWith configuration: WKWebViewConfiguration,
                 for navigationAction: WKNavigationAction,
                 windowFeatures: WKWindowFeatures) -> WKWebView? {

        // Load new content in the same web view
        webView.load(navigationAction.request)
        return nil
    }
}
