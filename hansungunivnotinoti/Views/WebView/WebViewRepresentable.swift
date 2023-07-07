//
//  NoticeWebView.swift
//  testproject
//
//  Created by Finny Jakey on 2023/06/23.
//

import SwiftUI
import WebKit

struct WebViewRepresentable: UIViewRepresentable {
    var url: String

    func makeUIView(context: Context) -> WKWebView {
        guard let url = URL(string: self.url) else {
            return WKWebView()
        }
        
        let webview = WKWebView()
        webview.load(URLRequest(url: url))
        
        return webview
    }

    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<WebViewRepresentable>) {
        
    }
}

struct WebViewRepresentable_Previews: PreviewProvider {
    static var previews: some View {
        WebViewRepresentable(url: "https://example.com")
    }
}
