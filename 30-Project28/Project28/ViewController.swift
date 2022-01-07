//
//  ViewController.swift
//  Project28
//
//  Created by User on 05.01.2022.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    
    var passwordUnlock = ""

    @IBOutlet var secret: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Nothing to see here"
        
        let notification = NotificationCenter.default
        notification.addObserver(self, selector: #selector(addJustForKeyBoard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notification.addObserver(self, selector: #selector(addJustForKeyBoard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notification.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
    }
    
    @objc func addJustForKeyBoard(notification:Notification){
        guard let keyBoardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyBoardScreenAndFrame = keyBoardValue.cgRectValue
        let keyBoardViewAndFrame = view.convert(keyBoardScreenAndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification{
            secret.contentInset = .zero
        }else{
            secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyBoardViewAndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        secret.scrollIndicatorInsets = secret.contentInset
        let selectRange = secret.selectedRange
        secret.scrollRangeToVisible(selectRange)
    }
    
    @IBAction func authenticateTapped(_ sender: Any) {
        let context = LAContext()
        var error:NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason){[weak self] success, authenticationError in
                DispatchQueue.main.async {
                    if success{
                        self?.unlockSecretMessage()
                        self?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self?.saveSecretMessage))
                    }else{
                        self?.unlockPassword(str: "Authentication failed")
                    }
                }
            }
        }else{
            self.unlockPassword(str: "Biometry unavailable")
        }
    }
    
    func unlockPassword(str:String){
        let ac = UIAlertController(title: str, message: "Enter password", preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "OK", style: .default){[weak self] _ in
            guard let password = ac.textFields?[0].text else {return}
            if let text = KeychainWrapper.standard.string(forKey: "PassWord"){
                self?.passwordUnlock = text
                if password == self?.passwordUnlock{
                    self?.unlockSecretMessage()
                    self?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self?.saveSecretMessage))
                }else{
                    self?.unlockPassword(str: str)
                }
            }
        })
        ac.addAction(UIAlertAction(title: "Задать пароль", style: .default){[weak self] _ in
            guard let password = ac.textFields?[0].text else {return}
            self?.passwordUnlock = password
            self?.savePassword()
            self?.unlockPassword(str: str)
        })
        
        self.present(ac, animated: true)
    }
    
    func unlockSecretMessage(){
        secret.isHidden = false
        title = "Secret stuff!"
        
        if let text = KeychainWrapper.standard.string(forKey: "SecretMessage"){
            secret.text = text
        }
    }
    @objc func saveSecretMessage(){
        guard secret.isHidden == false else {return}
        
        KeychainWrapper.standard.set(secret.text, forKey: "SecretMessage")
        secret.resignFirstResponder()
        secret.isHidden = true
        title = "Nothing to see here"
    }
    func savePassword(){
        KeychainWrapper.standard.set(passwordUnlock, forKey: "PassWord")
    }
}

