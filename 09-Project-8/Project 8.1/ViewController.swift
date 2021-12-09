//
//  ViewController.swift
//  Project 8.1
//
//  Created by User on 16.11.2021.
//

import UIKit

class ViewController: UIViewController {
    var cluesLabel:UILabel!
    var answerLabel:UILabel!
    var currentAnswer: UITextField!
    var scoreLabel:UILabel!
    var lettersButton = [UIButton]()
    var activateButton = [UIButton]()
    var solution = [String]()
    var score = 0{
        didSet{
            scoreLabel.text = "Score: \(score)"
        }
    }
    var level = 1
    var answer1 = 0
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "score: 0"
        view.addSubview(scoreLabel)
        
        cluesLabel = UILabel()
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.text = "CLUES"
        cluesLabel.numberOfLines = 0
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(cluesLabel)
        
        answerLabel = UILabel()
        answerLabel.translatesAutoresizingMaskIntoConstraints = false
        answerLabel.font = UIFont.systemFont(ofSize: 24)
        answerLabel.text = "ANSWERS"
        answerLabel.numberOfLines = 0
        answerLabel.textAlignment = .right
        answerLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        view.addSubview(answerLabel)
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Tap letter to guess"
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)
            
        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("SUBMIT", for: .normal)
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        submit.layer.borderWidth = 1
        submit.layer.cornerRadius = 15
        submit.layer.borderColor = UIColor.lightGray.cgColor
        view.addSubview(submit)
        
        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("CLEAR", for: .normal)
        clear.addTarget(self, action: #selector(clearTapper), for: .touchUpInside)
        clear.layer.borderWidth = 1
        clear.layer.cornerRadius = 15
        clear.layer.borderColor = UIColor.lightGray.cgColor
        view.addSubview(clear)
        
        let buttonViews = UIView()
        buttonViews.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonViews)
            
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
            
            answerLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            answerLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            answerLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
            answerLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
            submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            submit.heightAnchor.constraint(equalToConstant: 44),
            clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
            clear.heightAnchor.constraint(equalToConstant: 44),
            buttonViews.widthAnchor.constraint(equalToConstant: 750),
            buttonViews.heightAnchor.constraint(equalToConstant: 320),
            buttonViews.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonViews.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
            buttonViews.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
            
        ])
        
        
        let widht = 150
        let height = 80
        
        for row in 0..<4{
            for col in 0..<5{
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                letterButton.layer.borderWidth = 1
                letterButton.layer.cornerRadius = 15
                letterButton.layer.borderColor = UIColor.lightGray.cgColor
                
                letterButton.setTitle("WWW", for: .normal)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                
                let frame = CGRect(x: col * widht, y: row * height, width: widht, height: height)
                letterButton.frame = frame
                buttonViews.addSubview(letterButton)
                lettersButton.append(letterButton)
                
            }
        }
        
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadLevel()
        DispatchQueue.global(qos:.userInteractive).async {
            self.loadView()
        }
    }
    @objc func letterTapped(_ sender: UIButton){
        guard let buttonTitle = sender.titleLabel?.text  else {return}
        currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
        activateButton.append(sender)
        sender.isHidden = true
    }
    @objc func submitTapped(_ sender: UIButton) {
        guard let answerText = currentAnswer.text else { return }

        if let solutionPosition = solution.firstIndex(of: answerText) {
            activateButton.removeAll()

            var splitAnswers = answerLabel.text?.components(separatedBy: "\n")
            splitAnswers?[solutionPosition] = answerText
            answerLabel.text = splitAnswers?.joined(separator: "\n")

            currentAnswer.text = ""
            score += 1
            answer1 += 1

            if answer1 == 7{
                answer1 = 0
                let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: nextLevel))
                present(ac, animated: true)
            }
        }else {
            currentAnswer.text = ""
            for i in activateButton{
                i.isHidden = false
            }
            activateButton.removeAll()
            
            let ac = UIAlertController(title: "Error", message: "Try again", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
            score -= 1
        }
    }
    
    func nextLevel(action:UIAlertAction){
        level += 1
        solution.removeAll(keepingCapacity: true)
        
        loadLevel()
        
        for btn in lettersButton{
            btn.isHidden = false
        }
    }
    @objc func clearTapper(_ sender: UIButton){
        currentAnswer.text = ""
        for btn in activateButton{
            btn.isHidden = false
        }
        activateButton.removeAll()
    }
    
    @objc func loadLevel(){
        var clueString = ""
        var solutionString = ""
        var letterBits = [String]()
        
        if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt"){
            if let levelContents = try? String(contentsOf: levelFileURL){
                var lines = levelContents.components(separatedBy: "\n")
                lines.shuffle()
                
                
                for (index, line) in lines.enumerated(){
                    let parts = line.components(separatedBy: ": ")
                    let answer = parts[0]
                    let clue = parts[1]
                    
                    clueString += "\(index + 1). \(clue)\n"
                    
                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                    solutionString += "\(solutionWord.count) letters\n"
                    solution.append(solutionWord)
                    
                    let bits = answer.components(separatedBy: "|")
                    letterBits += bits
                }
            }
        }
        cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
        answerLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        letterBits.shuffle()
        
        if letterBits.count == lettersButton.count{
            for i in 0..<lettersButton.count{
                lettersButton[i].setTitle(letterBits[i], for: .normal)
            }
        }
    }
    


}

