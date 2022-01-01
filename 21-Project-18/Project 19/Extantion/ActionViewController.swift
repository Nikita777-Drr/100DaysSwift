//
//  ActionViewController.swift
//  Extantion
//
//  Created by User on 19.12.2021.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers

class ActionViewController: UIViewController{

    @IBOutlet var script: UITextView!
    
    var pageTitle = ""
    var pageURL = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addList))
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(addjustForKeyBoard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(addjustForKeyBoard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        if let imputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = imputItem.attachments?.first {
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String){[weak self] (dict, error) in
                    guard let itemDictionary = dict as? NSDictionary else {return}
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else {return}
                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""
                    
                    DispatchQueue.main.async {
                        self?.title = self?.pageTitle
                    }
                    
                }
            }
        }
    
    }
    @objc func addList(){
        let ac = UIAlertController(title: "Add command", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        ac.addAction(UIAlertAction(title: "alert(document.title);", style: .default){[weak self, weak ac] _ in
            self?.script.text = "alert(document.title);"
        })
        ac.addAction(UIAlertAction(title: "Save text", style: .default){[weak self, weak ac] _ in
            if let cell = self?.storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailTableViewController{
                cell.listURL.append(self!.script.text)
                cell.save()
            }
        })
        ac.addAction(UIAlertAction(title: "Open detail list", style: .default){[weak self, weak ac] _ in
            if let cell = self?.storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailTableViewController{
                self?.navigationController?.pushViewController(cell, animated: true)
            }
        })
        present(ac, animated: true)
    }
    
    @objc func addjustForKeyBoard(notification:Notification){
        guard let keyBoardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyBoardScreenAndFrame = keyBoardValue.cgRectValue
        let keyBoardViewAndFrame = view.convert(keyBoardScreenAndFrame, from: view.window)
        if notification.name == UIResponder.keyboardWillHideNotification{
            script.contentInset = .zero
        }else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyBoardViewAndFrame.height - view.safeAreaInsets.bottom, right: 0)
            
        }
        script.scrollIndicatorInsets = script.contentInset
        let selectRange = script.selectedRange
        script.scrollRangeToVisible(selectRange)
    }

    @IBAction func done() {
        let item = NSExtensionItem()
        let argument:NSDictionary = ["customJavaScript":script.text ]
        let webDictionry:NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey:argument]
        let customJavaScript = NSItemProvider(item: webDictionry, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]
        extensionContext?.completeRequest(returningItems: [item])
    }


}
