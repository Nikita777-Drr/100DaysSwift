//
//  ViewController.swift
//  Project 5
//
//  Created by User on 06.11.2021.
//

import UIKit

class ViewController: UITableViewController {
    var allWOrds = [String]()
    var userWords = [String]()
    
    var saveWordNow = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promFromAnswer))
        
        if let startWordURL = Bundle.main.url(forResource: "start", withExtension: "txt"){
            if let startWord = try? String(contentsOf: startWordURL){
                allWOrds = startWord.components(separatedBy: "\n")
            }
        }
        if allWOrds.isEmpty{
            allWOrds = ["silkworm"]
        }
        let defaults = UserDefaults.standard
        if let savedWord = defaults.object(forKey: "word") as? Data{
            let jsonDecode = JSONDecoder()
            do{
                userWords = try jsonDecode.decode([String].self, from: savedWord)
            }catch{
                print("Failed!")
            }
        }
        startGame()
    }
    @objc func startGame(){
        title = allWOrds.randomElement()
        userWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
        saveWord()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userWords.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = userWords[indexPath.row]
        return cell
    }
    @objc func promFromAnswer(){
        let ac = UIAlertController(title: "Enter answer!", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let submitAction = UIAlertAction(title: "Submit", style: .default){[weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else {return}
            self?.submit(answer)
        }
        ac.addAction(submitAction)
        saveWord()
        present(ac, animated: true, completion: nil)
        
    }
    func submit(_ answer:String){
        let answerSubmit = answer.lowercased()
        
        if isPossible(str: answerSubmit){
            if isOriginal(str: answerSubmit){
                if isReal(str: answerSubmit){
                    userWords.insert(answer, at: 0)
                    
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                } else {
                   showErrorMessge(name: answerSubmit)
                }
            } else {
                showErrorMessge(name: answerSubmit)
            }
        } else {
            showErrorMessge(name: answerSubmit)
        }
        
    }
    // проверка слова
    func showErrorMessge(name:String){
        let errortitle:String
        let erroeMessage:String
        
        if isPossible(str: name) == false{
            guard let title = title?.lowercased() else {return }
            errortitle = "IS POSSIBLE:word not possible!"
            erroeMessage = "You can not spell that word from \(title)"
            let vc = UIAlertController(title: errortitle, message: erroeMessage, preferredStyle: .alert)
            vc.addAction(UIAlertAction(title: "ok", style: .default))
            present(vc, animated: true)
        }else if isOriginal(str:name) == false{
            errortitle = "IS ORIGINAL:Word use already!"
            erroeMessage = "Be more original!"
            let vc = UIAlertController(title: errortitle, message: erroeMessage, preferredStyle: .alert)
            vc.addAction(UIAlertAction(title: "ok", style: .default))
            present(vc, animated: true)
        }else if isReal(str: name) == false{
            errortitle = "IS REAL:Word not recoding"
            erroeMessage = "You can not just make them up, you now!"
            let vc = UIAlertController(title: errortitle, message: erroeMessage, preferredStyle: .alert)
            vc.addAction(UIAlertAction(title: "ok", style: .default))
            present(vc, animated: true)
        }
    }
    func isPossible(str:String)->Bool{
        guard var tempWord = title?.lowercased() else{return false}
        
        for letter in str{
            if let position = tempWord.firstIndex(of: letter){
                tempWord.remove(at: position)
            }else{
                return false
            }
        }
        return true
    }
    func isOriginal(str:String)->Bool{
        return !userWords.contains(str)
    }
    func isReal(str:String)->Bool{
        if str.count > 2 {
            return true
        }
        let text = UITextChecker()
        let range = NSRange(location: 0, length: str.utf16.count)
        let missPelledRange = text.rangeOfMisspelledWord(in: str, range: range, startingAt: 0, wrap: false, language: "en")
        return missPelledRange.location == NSNotFound
    }
    func saveWord(){
        let jsonEncoder = JSONEncoder()
        if let saveWord = try? jsonEncoder.encode(userWords){
            let defaaults = UserDefaults.standard
            defaaults.set(saveWord, forKey: "word")
        }else {
            print("failed")
        }
    }

}

