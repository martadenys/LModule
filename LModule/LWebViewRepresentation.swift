//
//  LWebViewRepresentation.swift
//  
//
//  Created by Dmitriy Holovnia on 03.07.2023.
//

import UIKit
import SwiftUI
import WebKit

@available(iOS 14.0, *)
struct LWebViewRepresentation: UIViewRepresentable {
    
    internal let url: URL
    @Binding internal var loadingInProgress: Bool

    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences = WKWebpagePreferences()
        configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.allowsBackForwardNavigationGestures = true
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) { }

    func makeCoordinator() -> Coordinator {
        let coordinator = Coordinator(self)
        return coordinator
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        
        var webView: LWebViewRepresentation
        
        init(_ webView: LWebViewRepresentation) {
            self.webView = webView
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            self.webView.loadingInProgress = true
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            self.webView.loadingInProgress = false
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            self.webView.loadingInProgress = false
        }

        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            self.webView.loadingInProgress = false
        }
    }
}

