//
//  DetailViewController.swift
//  Project 16
//
//  Created by User on 13.12.2021.
//

import UIKit
import WebKit

class DetailViewController: UIViewController, WKNavigationDelegate {
    var webView:WKWebView!
    var town:String?
    
    override func loadView() {
        super.loadView()
        
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL(string: town!)!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
 
    }

}
