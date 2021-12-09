//
//  ViewController2.swift
//  Project 4
//
//  Created by User on 05.11.2021.
//

import UIKit
import WebKit


class ViewController2: UITableViewController {
    var websites:[String] = ["apple.com", "hackingwithswift.com"]
    var webview:WKWebView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(websites)
        let url = URL(string: "https://" + websites[0])!
        webview?.load(URLRequest(url: url))
        webview?.allowsBackForwardNavigationGestures = true
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websites.count
    }
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "HEL", for: indexPath)
//        cell.textLabel?.text = websites[indexPath.row]
//        return cell
//    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "SITE") as? DetailViewController
        navigationController?.pushViewController(vc!, animated: true)
    }

}
