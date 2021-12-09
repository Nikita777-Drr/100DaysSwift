//
//  ViewController.swift
//  Project 7
//
//  Created by User on 12.11.2021.
//

import UIKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var allPetition = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "info", style: .plain, target: self, action: #selector(showInfo))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(filterPetition))
        performSelector(inBackground: #selector(fetchJSON), with: nil)
        performSelector(inBackground: #selector(filterSA), with: nil)
        
    }
    
    @objc func fetchJSON(){
        let urlString:String
        if navigationController?.tabBarItem.tag == 0{
           urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        }else {
            urlString =  "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        if let url = URL(string: urlString){
            if let data = try? Data(contentsOf: url){
                parse(json: data)
                return
            }
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }
    
    @objc func showInfo(){
        let ac = UIAlertController(title: "Info!", message: "You use API!", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    @objc func filterPetition(){
        let ac = UIAlertController(title: "Enter word for filter.", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let searchAction = UIAlertAction(title: "Search", style: .default){[weak self, weak ac] _ in
            guard let sa = ac?.textFields?[0].text else {return}
            self?.filterSA(sa)
        }
        ac.addAction(searchAction)
        ac.addAction(UIAlertAction(title: "Cancel", style: .default){[weak self, weak ac] _ in
            self?.petitions = self!.allPetition
            self?.tableView.reloadData()
        })
        present(ac, animated: true)
    }
    @objc func filterSA(_ wordFilter:String){
        petitions = allPetition.filter({
            $0.title.localizedCaseInsensitiveContains(wordFilter) || $0.body.localizedCaseInsensitiveContains(wordFilter)
        })
            
    }
    @objc func showError(){
        let ac = UIAlertController(title: "Error", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "ok", style:.default, handler: nil))
        present(ac, animated: true, completion: nil)
          
    }
    func parse(json:Data){
        let decoder = JSONDecoder()
        if let jsonPetition = try? decoder.decode(Petitions.self, from: json){
            petitions = jsonPetition.results
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        }else{
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.petitionItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }


}

