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
    var onRememberMeChanged: ((Bool) -> Void)?
    var onPageFinishedLoading: ((String) -> Void)?
    
    func makeUIView(context: Context) -> WKWebView {
        let contentController = webView.configuration.userContentController
        contentController.add(context.coordinator, name: "rememberMeChanged")
        
        webView.uiDelegate = context.coordinator
        webView.navigationDelegate = context.coordinator
        webView.load(URLRequest(url: url))
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {
        var parent: WebViewContainer
        
        init(_ parent: WebViewContainer) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.isLoading = true
        }
        
        // MARK: - JavaScript alert()
        func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String,
                     initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
            presentAlert(message: message, webView: webView, actions: [
                UIAlertAction(title: "OK", style: .default, handler: { _ in
                    completionHandler()
                })
            ])
        }
        
        // MARK: - JavaScript confirm()
        func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String,
                     initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
            presentAlert(message: message, webView: webView, actions: [
                UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                    completionHandler(false)
                }),
                UIAlertAction(title: "OK", style: .default, handler: { _ in
                    completionHandler(true)
                })
            ])
        }
        
        // MARK: - JavaScript prompt()
        func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String,
                     defaultText: String?, initiatedByFrame frame: WKFrameInfo,
                     completionHandler: @escaping (String?) -> Void) {
            let alert = UIAlertController(title: nil, message: prompt, preferredStyle: .alert)
            alert.addTextField { $0.text = defaultText }
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
                completionHandler(nil)
            })
            alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                let input = alert.textFields?.first?.text
                completionHandler(input)
            })
            
            present(alert: alert, webView: webView)
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            print("Finished loading: \(String(describing: webView.url))")
            parent.isLoading = false
            parent.canGoBack = webView.canGoBack
            if let currentURL = webView.url?.absoluteString {
                parent.currentLoadedURL = currentURL
                print("Currently loaded URL: \(currentURL)")

                DispatchQueue.main.async {
                    self.parent.onPageFinishedLoading?(currentURL)
                }
                
                if currentURL.contains("/login/") {
                    injectRememberMeObserver(webView)
                }
                if currentURL.contains("/dashboard/") {
                    checkForLoginCookies(webView)
                }
            }
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                     decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let url = navigationAction.request.url?.absoluteString {
                if url == "https://app.revulink.net/login/" || url == "https://app.revulink.net/login" {
                    if let newURL = URL(string: "https://app.revulink.net/login/?app") {
                        print("Redirecting to: \(newURL)")
                        webView.load(URLRequest(url: newURL))
                    }
                    decisionHandler(.cancel)
                    return
                }
            }
            
            decisionHandler(.allow)
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.isLoading = false
        }
        
        // MARK: - WKScriptMessageHandler
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            if message.name == "rememberMeChanged", let isChecked = message.body as? Bool {
                print("Remember me checkbox changed: \(isChecked)")
                DispatchQueue.main.async {
                    self.parent.onRememberMeChanged?(isChecked)
                }
            }
        }
        
        // MARK: - Helper functions for JavaScript injection and cookie handling
        private func injectRememberMeObserver(_ webView: WKWebView) {
            let script = """
            (function() {
                console.log('Searching for remember me checkbox...');
                let rememberCheckbox = document.querySelector('input[type="checkbox"][name="remember"]');
                if (rememberCheckbox) {
                    console.log('Remember me checkbox found!');
                    // Send initial state
                    window.webkit.messageHandlers.rememberMeChanged.postMessage(rememberCheckbox.checked);
                    
                    // Add event listener for changes
                    rememberCheckbox.addEventListener('change', function() {
                        console.log('Remember me changed to: ' + this.checked);
                        window.webkit.messageHandlers.rememberMeChanged.postMessage(this.checked);
                    });
                } else {
                    console.log('Remember me checkbox not found');
                }
            })();
            """
            
            webView.evaluateJavaScript(script) { result, error in
                if let error = error {
                    print("Error injecting remember me observer: \(error)")
                } else {
                    print("Remember me observer injected successfully")
                }
            }
        }
        
        private func checkForLoginCookies(_ webView: WKWebView) {
            webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { cookies in
                let hasLoginCookies = cookies.contains { cookie in
                    return cookie.name.contains("auth") ||
                           cookie.name.contains("token") ||
                           cookie.name.contains("session") ||
                           cookie.name.contains("remember") ||
                           cookie.name.contains("login")
                }
                
                if hasLoginCookies {
                    print("Found authentication cookies - user is logged in")
                    DispatchQueue.main.async {
                        self.parent.onRememberMeChanged?(true)
                    }
                }
            }
        }
        
        private func presentAlert(message: String, webView: WKWebView, actions: [UIAlertAction]) {
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            actions.forEach { alert.addAction($0) }
            present(alert: alert, webView: webView)
        }
        
        private func present(alert: UIAlertController, webView: WKWebView) {
            if let rootVC = UIApplication.shared.connectedScenes
                .compactMap({ ($0 as? UIWindowScene)?.keyWindow })
                .first?.rootViewController {
                rootVC.present(alert, animated: true, completion: nil)
            }
        }
    }
}
