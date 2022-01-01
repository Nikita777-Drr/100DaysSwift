//
//  DetailTableViewController.swift
//  Extantion
//
//  Created by User on 21.12.2021.
//

import UIKit

class DetailTableViewController: UITableViewController{
    
    var listURL = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaults.standard
        
        if let savedPeople = defaults.object(forKey: "list") as? Data{
            let jsonDecode = JSONDecoder()
            do{
                listURL = try jsonDecode.decode([String].self, from: savedPeople)
            }catch{
                print("Failed save")
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listURL.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = listURL[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let sb = storyboard?.instantiateViewController(withIdentifier: "Celler") as? ActionViewController {
            sb.script.text = listURL[indexPath.row]
            navigationController?.pushViewController(sb, animated: true)
        }
    }
    func save(){
        let jsonEncoder = JSONEncoder()
        if let saveData = try? jsonEncoder.encode(listURL){
            let defaults = UserDefaults.standard
            defaults.set(saveData, forKey: "list")
        }
    }
}
