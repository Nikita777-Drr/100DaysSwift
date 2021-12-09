//
//  ViewController.swift
//  Project 2
//
//  Created by User on 01.11.2021.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    @IBOutlet var labelScope: UILabel!
    @IBOutlet var maxScoreLabel: UILabel!
    
    var countries = [String]()
    var scope = 0
    var maxScore = 0
    var correctAnswer = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTappet))
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        let defaults = UserDefaults.standard
        maxScore = defaults.object(forKey: "score") as? Int ?? 0
        
        askQuestion()
        
    }
    func askQuestion(action:UIAlertAction! = nil) {
        
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        saveResullRecord()
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        title = countries[correctAnswer].uppercased()
        labelScope.text = "Scope: " + String(scope)
        maxScoreLabel.text = "Record: " + String(maxScore)
    }
    func saveResullRecord(){
        var message = "Your record - \(scope)"
        if scope > maxScore{
            maxScore += 1
            let ac = UIAlertController(title: "Record!", message: message, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            present(ac, animated: true)
        }
        
        saveScore()
    }
    
    @IBAction func buttonFlagTap(_ sender: UIButton) {
        var title:String
        var message:String
        
        if sender.tag == correctAnswer{
            scope += 1
            title = "Correct"
            message =  "You scope is \(scope)"
 
        }else {
            title = "Wrong"
            message = "Флаг \(countries[correctAnswer]) под номером " + String(correctAnswer + 1)
            scope -= 1
        }
        
        if scope == 10{
            let ac = UIAlertController(title: "You win!!!", message: "Начнем игру заново!", preferredStyle: .actionSheet)
            ac.addAction(UIAlertAction(title: "ok", style: .default, handler: askQuestion))
            present(ac, animated: true, completion: nil)
            scope = 0
        }else {
            let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Countinue", style: .default, handler: askQuestion))
            present(ac, animated: true, completion: nil)
        }
        
        
    }
    @objc func shareTappet(){
        let message = "Hello, man!"
        
        let vc = UIActivityViewController(activityItems: [message], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true, completion: nil)
        
    }
    func saveScore(){
        let defaults = UserDefaults.standard
        defaults.set(maxScore, forKey:"score")
        
    }
}

