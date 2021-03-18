//
//  WebViewVC.swift
//  UnSAFE_Bank
//
//  Created by Tarun Kaushik on 30/03/20.
//  Copyright © 2020 lucideus. All rights reserved.
//

import UIKit
import WebKit

class WebViewVC: UIViewController,WKUIDelegate{
    
    var webView:WKWebView!
    
    var webViewTitle:String?
    var urlString:String?
    
    override func loadView() {
        super.loadView()
        let webViewConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webViewConfiguration)
        webView.uiDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let title = webViewTitle{
            self.navigationItem.title = title
        }
        
        if let urlstr = self.urlString,let url = URL(string: urlstr){
            webView.load(URLRequest(url: url))
        }
        
        if #available(iOS 11.0, *) {
            self.navigationItem.largeTitleDisplayMode = .never
            self.navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
    }
}
