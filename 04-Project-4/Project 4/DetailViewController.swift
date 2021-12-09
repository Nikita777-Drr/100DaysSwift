//
//  DetailViewController.swift
//  Project 4
//
//  Created by User on 05.11.2021.
//

import UIKit

class DetailViewController: UITableViewController {

    var websites:[String] = ["apple.com", "hackingwithswift.com"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "WebSites"
        let list = websites.joined(separator: "\n")
        print(list)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websites.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cel = tableView.dequeueReusableCell(withIdentifier: "Site", for: indexPath)
        cel.textLabel?.text = websites[indexPath.row]
        return cel
    }
  
    
    
}
