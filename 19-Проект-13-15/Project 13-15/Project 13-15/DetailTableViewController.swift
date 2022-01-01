//
//  DetailTableViewController.swift
//  Project 13-15
//
//  Created by User on 11.12.2021.
//

import UIKit

class DetailTableViewController: UITableViewController {
    
    var countries = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Celler",for: indexPath)
        cell.textLabel?.text = countries[indexPath.row]
        
        return cell

    }
    

}
