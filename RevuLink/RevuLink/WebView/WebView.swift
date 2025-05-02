//
//  WebView.swift
//  RevuLink
//
//  Created by Abdul Moiz on 02/05/2025.
//

import SwiftUI
import WebKit

struct WebView: View {
    @State var webLink: String
    @State private var canGoBack = false
    @State private var isLoading = true
    @Environment(\.dismiss) var dismiss
    private let webView = WKWebView()

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                WebViewContainer(
                    url: URL(string: webLink)!,
                    canGoBack: $canGoBack,
                    isLoading: $isLoading,
                    webView: webView
                )
                .ignoresSafeArea()
            }

            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    if webView.canGoBack {
                        webView.goBack()
                    } else {
                        dismiss()
                    }
                }) {
                    NavigationBackButton()
                }
            }
        }
    }
}
