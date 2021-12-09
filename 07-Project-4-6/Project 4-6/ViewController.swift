//
//  ViewController.swift
//  Project 4-6
//
//  Created by User on 11.11.2021.
//

import UIKit

class ViewController: UITableViewController {
    var listWord:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addWord))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh))
        
        let list = listWord.joined(separator: "\n")
        start()
    }
    func start(){
        listWord.removeAll(keepingCapacity: true)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listWord.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = listWord[indexPath.row]
        return cell
    }
    @objc func addWord(){
        let ac = UIAlertController(title: "Enter word!", message: nil, preferredStyle: .alert)
        
        ac.addTextField()
        let submitAction = UIAlertAction(title: "ok", style: .default){[weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }
        ac.addAction(submitAction)
        present(ac, animated: true, completion: nil)
    }
    func submit(_ answer:String){
        listWord.insert(answer, at: 0)
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    @objc func refresh(){
        listWord.removeAll()
        tableView.reloadData()
    }

}

