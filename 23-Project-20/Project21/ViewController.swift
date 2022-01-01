//
//  ViewController.swift
//  Project21
//
//  Created by User on 24.12.2021.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Scedule", style: .plain, target: self, action: #selector(scheduleLocal))
    }
    
    @objc func registerLocal(){
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert,.badge,.sound]){(granted, error) in
            if granted{
                print("Yea")
            }else {
                print("D'oh")
            }
        }
    }
    @objc func scheduleLocal(timeInterval:TimeInterval){
        requestCategory()
        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications()
        
        let content = UNMutableNotificationContent()
        content.title = "Late wake up call"
        content.body = "Main text goes here"
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData":"fizzbuzz"]
        content.sound = UNNotificationSound.default
        
        var dataComponents = DateComponents()
        dataComponents.hour = 10
        dataComponents.minute = 30
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dataComponents, repeats: true)

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
       
        center.add(request)
    }
    func requestCategory(){
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        let show = UNNotificationAction(identifier: "show", title: "Tell me more...", options: .foreground)
        let show2 = UNNotificationAction(identifier: "show2", title: "Remind me later", options:.foreground)
        let category = UNNotificationCategory(identifier: "alarm", actions: [show,show2], intentIdentifiers: [], options: [])
        
        center.setNotificationCategories([category])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        if let customData = userInfo["customData"] as? String{
            print("Custom data received: \(customData)")
            
            switch response.actionIdentifier{
            case UNNotificationDefaultActionIdentifier:
                let ac = UIAlertController(title: "Hello", message: "Begin work?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "GO!", style: .cancel))
                present(ac, animated: true)
            case "show":
                let ac = UIAlertController(title: "Hello", message: "Show notification?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .cancel))
                present(ac, animated: true)
            case "show2":
                scheduleLocal(timeInterval: 84600)
            default:
                break
            }
        }
        completionHandler()
    }

}

