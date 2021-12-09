//
//  ViewController.swift
//  Виселица_Project 7-9
//
//  Created by User on 20.11.2021.
//

import UIKit

class ViewController: UIViewController {
    var currentAnswer:UITextField!
    var letterButtons = [UIButton]()
    var solution = [String]()
    var letter = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z","_","_"]
    var currentWord:String = "silwor"
    
    var correctLetters = [String]()
    
    var errors = 0{
        didSet{
            errorLabel.text = "Number of errors - \(errors)"
        }
    }
    var errorLabel:UILabel!
    
    
    override func loadView() {
        super.loadView()
        view = UIView()
        view.backgroundColor = .yellow
        
        
        currentAnswer = UITextField()
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Enter letter"
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)
        
        errorLabel = UILabel()
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.font = UIFont.systemFont(ofSize: 17)
        errorLabel.isUserInteractionEnabled = false
        view.addSubview(errorLabel)
        
        
        let buttonView = UIView()
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonView)
        let buttonView2 = UIView()
        buttonView2.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonView2)
        let buttonView3 = UIView()
        buttonView3.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonView3)
        let buttonView4 = UIView()
        buttonView4.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonView4)
        
        NSLayoutConstraint.activate([
            errorLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            errorLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            currentAnswer.widthAnchor.constraint(equalToConstant: 350),
            currentAnswer.heightAnchor.constraint(equalToConstant: 70),
            currentAnswer.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 110),
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonView.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor, constant: 120),
            buttonView.widthAnchor.constraint(equalToConstant: 400),
            buttonView.heightAnchor.constraint(equalToConstant: 100),
            buttonView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonView2.topAnchor.constraint(equalTo: buttonView.bottomAnchor, constant: 10),
            buttonView2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonView2.widthAnchor.constraint(equalToConstant: 400),
            buttonView2.heightAnchor.constraint(equalToConstant: 100),
            buttonView3.topAnchor.constraint(equalTo: buttonView2.bottomAnchor, constant: 10),
            buttonView3.widthAnchor.constraint(equalToConstant: 400),
            buttonView3.heightAnchor.constraint(equalToConstant: 100),
            buttonView3.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonView4.topAnchor.constraint(equalTo: buttonView3.bottomAnchor, constant: 10),
            buttonView4.widthAnchor.constraint(equalToConstant: 400),
            buttonView4.heightAnchor.constraint(equalToConstant: 100),
            buttonView4.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonView4.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor,constant: -5)
            
        ])
        sizeButton(index: 0, maxSize: 7, view: buttonView)
        sizeButton(index: 7, maxSize: 7, view: buttonView2)
        sizeButton(index: 14, maxSize: 7, view: buttonView3)
        sizeButton(index: 21, maxSize: 7, view: buttonView4)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let ac = UIAlertController(title: "Игра виселица!", message: "Тебе нужно угадать слово, право на ошибку дается лишь 7 раз!", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "ok", style: .default))
        present(ac, animated: true)
        loadLevel()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "info", style: .plain, target: self, action: #selector(infoButton))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "New game", style: .plain, target: self, action: #selector(newGame))
        
        
    }
    @objc func infoButton(){
        let ac = UIAlertController(title: "Игра виселица!", message: "Тебе нужно угадать слово, право на ошибку дается лишь 7 раз!", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "ok", style: .default))
        present(ac, animated: true)
    }
    func sizeButton(index:Int, maxSize:Int, view:UIView){
        var widht = 56
        var height = 50
        for i in 0..<maxSize{
            let buttonsTap = UIButton(type: .system)
            buttonsTap.titleLabel?.font = UIFont.systemFont(ofSize: 35)
            buttonsTap.layer.borderWidth = 1
            buttonsTap.layer.borderColor = UIColor.lightGray.cgColor
            buttonsTap.layer.cornerRadius = 10
            buttonsTap.addTarget(self, action: #selector(letterButton), for: .touchUpInside)
            buttonsTap.setTitle(letter[index + i], for: .normal)
            let frame = CGRect(x: widht * i, y: height , width: widht, height: height)
            buttonsTap.frame = frame
            view.addSubview(buttonsTap)
            letterButtons.append(buttonsTap)
            
        }
    }
    @objc func letterButton(_ sender:UIButton){
        guard let buttonTap = sender.titleLabel?.text else{return}
        
        if currentWord.folding(options: .diacriticInsensitive, locale: .current).contains(buttonTap){
            correctLetters.append(buttonTap)
            correct()
        }else{
            inCorrect()
        }
        
        sender.isHidden = true
    }
    func correct(){
        var wordText = ""
        var wordComplet = true
        
        for i in currentWord{
            let strLetters = String(i)
            if correctLetters.contains(strLetters.folding(options: .diacriticInsensitive, locale: .current)){
                wordText += "\(strLetters)"
            }else {
                wordText += "_ "
                wordComplet = false
            }
            currentAnswer.text = wordText.trimmingCharacters(in: .whitespaces)
            
            if currentAnswer.text == currentWord{
                if wordComplet {
                    for btn in letterButtons{
                        btn.isUserInteractionEnabled = false
                    }
                    let ac = UIAlertController(title: "Congretulations", message: "You finc word: \(currentWord)", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "ok", style: .default))
                    present(ac, animated: true)
                }
            }
            
        }
        
    }
    func inCorrect(){
        errors += 1
        
        if errors == 7{
            for btn in letterButtons{
                btn.isUserInteractionEnabled = false
            }
            let ac = UIAlertController(title: "You lose", message: "Word in game: \(currentWord)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "ok", style: .default))
            present(ac, animated: true)
            
        }
        
    }
    
    @objc func newGame(){
        let ac = UIAlertController(title: "New game?", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "yes", style: .default, handler: newGameStart))
        ac.addAction(UIAlertAction(title: "no", style: .default, handler: nil))
        present(ac, animated: true)
    }
    @objc func newGameStart(_ action:UIAlertAction){
        performSelector(inBackground: #selector(loadLevel), with: nil)
    }
    @objc func loadLevel(){
        if let levelUrl = Bundle.main.url(forResource: "english", withExtension: "txt"){
            if let levelContents = try? String(contentsOf: levelUrl){
                solution = levelContents.components(separatedBy: "\n")
            }
        }
        if solution.isEmpty{
            solution.append("silrow")
        }
        performSelector(onMainThread: #selector(startGame), with: nil, waitUntilDone: false)
        for i in letterButtons{
            i.isHidden = false
        }
    }
    @objc func startGame(){
        currentWord = solution.randomElement()!.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        for btn in letterButtons{
            btn.isUserInteractionEnabled = true
            btn.setTitleColor(.black, for: .normal)
        }
        currentAnswer.text = String(repeating: "_ ", count: currentWord.count).trimmingCharacters(in: .whitespaces)
        
        errors = 0
        correctLetters = [String]()
        
    }

}

