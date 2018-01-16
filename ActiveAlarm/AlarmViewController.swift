//
//  AlarmViewController.swift
//  ActiveAlarm
//
//  Created by Omar Ihmoda on 1/14/18.
//  Copyright © 2018 Omar Ihmoda. All rights reserved.
//

import UIKit
import UserNotifications



class AlarmViewController: UIViewController {
    let content = UNMutableNotificationContent()
    var dateComponents = DateComponents()
    
    private var notification: NSObjectProtocol?
    
    
    @IBOutlet weak var datePicker: UIDatePicker!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerLocal()
        
        // Do any additional setup after loading the view.
    }
        

    func setAlarm(){
        print("setAlarm")
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey:
            "Hello!", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey:
            "Hello_message_body", arguments: nil)
        
        // Deliver the notification in five seconds.
        content.sound = UNNotificationSound(named: "analog_watch.wav")
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        // Schedule the notification.
        let request = UNNotificationRequest(identifier: "FiveSecond", content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
        
    func registerLocal() {
        print("register")
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Yay!")
            } else {
                print("D'oh")
            }
        }
    }
    
    
    @IBAction func setAlarmPressed(_ sender: UIButton) {
        print("Hit")
        
        let calendar = Calendar.current
        let date = datePicker.date
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        //print(amPMSwitch.isOn)

//        if let hour = datePicker.date {
//            if !amPMSwitch.isOn {
//                dateComponents.hour = Int(hour)
//            } else {
//                dateComponents.hour = Int(hour)! + 12
//            }
//        }
//
//        if let minute = minuteTextField.text {
//            dateComponents.minute = Int(minute)
//        }
        dateComponents.hour = hour
        dateComponents.minute = minute
        
       print(dateComponents.hour)
       print(dateComponents.minute)
       self.setAlarm()
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
