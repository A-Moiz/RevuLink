//
//  WebViewCoordinator.swift
//  RevuLink
//
//  Created by Abdul Moiz on 02/05/2025.
//

import Foundation
import WebKit

class WebViewCoordinator: NSObject, WKNavigationDelegate {
    var parent: WebViewContainer

    init(parent: WebViewContainer) {
        self.parent = parent
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        parent.isLoading = true
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        parent.canGoBack = webView.canGoBack
        parent.isLoading = false
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        parent.isLoading = false
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        parent.isLoading = false
    }
}
