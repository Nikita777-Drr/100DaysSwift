//
//  ViewController.swift
//  Project 13-15
//
//  Created by User on 11.12.2021.
//

import UIKit

class ViewController: UITableViewController {
    var country = [Country]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        
        if let url = URL(string: urlString){
            if let data = try? Data(contentsOf: url){
                parse(json: data)
            }
        }
        
    }
    func parse(json:Data){
        let decoder = JSONDecoder()
        
        if let jsonCountry = try? decoder.decode(Countries.self, from: json){
            country = jsonCountry.results
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return country.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let countries = country[indexPath.row]
        cell.textLabel?.text = countries.title
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let sb = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailTableViewController{
            let detail = country[indexPath.row]
            sb.countries.append(detail.title)
            sb.countries.append(detail.url)
            sb.countries.append(detail.body)
            sb.countries.append(String(detail.signaturesNeeded))
            navigationController?.pushViewController(sb, animated: true)
        }
    }
}

