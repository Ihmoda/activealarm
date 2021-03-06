//
//  AlarmViewController.swift
//  ActiveAlarm
//
//  Created by Omar Ihmoda on 1/14/18.
//  Copyright © 2018 Omar Ihmoda. All rights reserved.
//

import UIKit
import UserNotifications


class AlarmViewController: UIViewController, UNUserNotificationCenterDelegate, UIPickerViewDelegate, UIPickerViewDataSource, TurnAlarmOff {
    
 
    let content = UNMutableNotificationContent()
    var dateComponents = DateComponents()
    var dateComponents2 = DateComponents()
    var pickerData = ["Shake", "Walk"]
    var selectedActivity: String = ""
    var alarmOff = false
    var identifier: String = ""

    var switchView = "Walk"
    private var notification: NSObjectProtocol?
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var activityPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerLocal()
    
        UNUserNotificationCenter.current().delegate = self
        self.activityPicker.delegate = self
        self.activityPicker.dataSource = self
    
        
        // Do any additional setup after loading the view.
    
    }

    
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.selectedActivity = self.pickerData[row]
        return self.pickerData[row]
    }

    func setAlarm(){
        print("setAlarm")
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey:
            "Active Alarm", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey:
            "Rise and Shine", arguments: nil)
        
        // Deliver the notification at specified time
        content.sound = UNNotificationSound(named: "analog_watch.wav")
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        // Schedule the notification.
        self.identifier = "\(self.selectedActivity) 1"
        print(self.identifier)
        let request = UNNotificationRequest(identifier: self.identifier, content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: nil)
    }
    
    func setAlarm2(){
        print("setAlarm")
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey:
            "Active Alarm", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey:
            "Rise and Shine", arguments: nil)
        
        // Deliver the notification at specified time
        content.sound = UNNotificationSound(named: "analog_watch.wav")
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents2, repeats: true)
        
        // Schedule the notification.
        self.identifier = "\(self.selectedActivity) 2"
        print(self.identifier)
        let request = UNNotificationRequest(identifier: self.identifier, content: content, trigger: trigger)
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: nil)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        self.switchView = response.notification.request.identifier
        if switchView.contains("Shake") {
            performSegue(withIdentifier: "shakePage", sender: nil)
        } else if switchView.contains("Walk") {
            performSegue(withIdentifier: "walkPage", sender: self)
        }
        
        completionHandler()
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

       dateComponents.hour = hour
       dateComponents.minute = minute
       dateComponents2.hour = hour
       dateComponents2.minute = minute + 1
        
       self.setAlarm()
       self.setAlarm2()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "shakePage" {
            
            let shakeVC = segue.destination as! ViewController
            shakeVC.passedInFromAlarm = "I'm from the alarm page"
            shakeVC.delegate = self
            
        }
        else if segue.identifier == "walkPage" {
            
            let walkVC = segue.destination as! pedometerViewController
            walkVC.passedInFromAlarm = "Woohoo!"
            
        }
    }
    
    func AlarmOff(yesOrNo: Bool) {
        // This function is needed to conform to the protocol TurnAlarmOff
        // as defined in ViewController and pedometerViewController
        self.alarmOff = true
        
    UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
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
