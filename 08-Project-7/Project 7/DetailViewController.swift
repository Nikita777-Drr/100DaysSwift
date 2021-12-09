//
//  DetailViewController.swift
//  Project 7
//
//  Created by User on 13.11.2021.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    var wkWeb:WKWebView!
    var petitionItem:Petition?
    override func loadView() {
        wkWeb = WKWebView()
        view = wkWeb
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        guard let petitionItem = petitionItem else{return}
        
      
        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style> body { font-size: 150%; } </style>
        </head>
        <body>
        \(petitionItem.body)
        </body>
        </html>
        """
        wkWeb.loadHTMLString(html, baseURL: nil)
    }
    
}
