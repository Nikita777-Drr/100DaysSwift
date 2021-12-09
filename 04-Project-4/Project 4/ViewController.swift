//
//  ViewController.swift
//  Project 4
//
//  Created by User on 04.11.2021.
//

import UIKit
import WebKit

class DetailViewController: UIViewController, WKNavigationDelegate {
    var webView:WKWebView?
    var progressView:UIProgressView!
    var webSite:String!
    
    override func loadView() {
        webView = WKWebView()
        webView?.navigationDelegate = self
        view = webView
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView?.reload))
        let forward = UIBarButtonItem(barButtonSystemItem: .fastForward, target: webView, action: #selector(webView?.goForward))
        let back = UIBarButtonItem(barButtonSystemItem: .rewind, target: webView, action: #selector(webView?.goBack))
        
        
        toolbarItems = [progressButton,spacer,refresh,back,forward]
        navigationController?.isToolbarHidden = false
        
        webView!.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        let url = URL(string: "https://" + webSite)!
        webView?.load(URLRequest(url: url))
        webView?.allowsBackForwardNavigationGestures = true
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if  keyPath == "estimatedProgress"{
            progressView.progress = Float(webView!.estimatedProgress)
        }
    }
    @objc func openTapped(){
        let vc = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        vc.addAction(UIAlertAction(title: webSite, style: .default, handler: openPage))
        
        vc.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true, completion: nil)
    }
    func openPage(action:UIAlertAction){
        guard let actionTitle = action.title  else {return}
        guard let url = URL(string: "https://" + actionTitle) else {return}
        webView?.load(URLRequest(url: url))
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url
        if let host = url?.host{
            for ws in webSite{
                if host.contains(ws){
                    decisionHandler(.allow)
                    return
                }else if host.contains("twitter.com"){
                    let vc = UIAlertController(title: "Error", message: "", preferredStyle: .alert)
                    vc.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                    present(vc, animated: true)
                }
            }
        }
        decisionHandler(.cancel)

    }
}

