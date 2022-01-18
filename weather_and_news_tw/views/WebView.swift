//
//  WebView.swift
//  weather_and_news_tw
//
//  Created by 周固廷 on 2022/1/12.
//

import Foundation
import SwiftUI
import WebKit

struct WebView: UIViewRepresentable{
    let urlStr:String

    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return  webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        //更新時用的(make時也會呼叫到這裡)
        if let url = URL(string: urlStr){
            let request = URLRequest(url: url)
            uiView.load(request)
        }
    
    }
    
    
    
    typealias UIViewType = WKWebView
    
    
}
