//
//  EmbeddedCheckout.swift
//  MPGS Hoste
//
//  Created by Nawaf Abdullah on 02/05/2023.
//

import SwiftUI
import WebKit
 
@available(iOS 13.0, *)
public struct EmbeddedCheckout: UIViewRepresentable {
    var hostUrl: String
    var sessionId: String
    @Binding var paymentFinished: Bool

    func makeUIView(context: Context) -> WKWebView {
        let wKWebView = WKWebView()
        wKWebView.navigationDelegate = context.coordinator
        return wKWebView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let html = "<html> <header> <meta name='viewport' content='width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0'> </header> <head> <script src='" + self.hostUrl + "/static/checkout/checkout.min.js'></script> <script type='text/javascript'> Checkout.configure({ session: { id: '" + self.sessionId + "' } }).then(() => { Checkout.showEmbeddedPage('#embed-target'); }) </script> </head> <body> <div id='embed-target'> </div> </body> </html>"
        webView.scrollView.isScrollEnabled = false
        webView.loadHTMLString(html, baseURL: Bundle.main.bundleURL)
    }
    
    func makeCoordinator() -> WebViewCoordinator {
        WebViewCoordinator(self)
    }
    
    class WebViewCoordinator: NSObject, WKNavigationDelegate {
        var parent: EmbeddedCheckout
        
        init(_ parent: EmbeddedCheckout) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if navigationAction.request.url!.description.contains("resultIndicator") {
                self.parent.paymentFinished = true
            }
            else {
                self.parent.paymentFinished = false
            }
            decisionHandler(.allow)
        }
    }
}
 
