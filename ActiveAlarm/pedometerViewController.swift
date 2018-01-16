//
//  pedometerViewController.swift
//  ActiveAlarm
//
//  Created by Omar Ihmoda on 1/14/18.
//  Copyright © 2018 Omar Ihmoda. All rights reserved.
//

import UIKit
import CoreMotion


class pedometerViewController: UIViewController {
    
    var delegate : TurnAlarmOff?
    var numberOfSteps = 0
    let pedometer = CMPedometer()
    
    var timer = Timer()
    let timerInterval = 1.0
    var timeElapsed:TimeInterval = 0.0
    var stepcounting = false
    
    var passedInFromAlarm = ""
    
    
    @IBOutlet weak var stepCounterLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.runTimer()
        
        if CMPedometer.isStepCountingAvailable() {
            print("We can detect steps")
            startReadingPedometerData()
        }
        else {
            print("We cannot detect steps")
        }
        
        print(passedInFromAlarm)

        // Do any additional setup after loading the view.
    }
    
    func checkIfRequirementMet() {
        if numberOfSteps >= 30 {
            delegate?.AlarmOff(yesOrNo: true)
            self.numberOfSteps = 0
            dismiss(animated: true, completion: nil)
        }
    }
    
    func startReadingPedometerData(){
        pedometer.startUpdates(from: Date(), withHandler: { (pedometerData, error) in
            if let pedData = pedometerData{
                print("step")
                self.numberOfSteps = pedData.numberOfSteps as! Int
            }
        })
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self,   selector: (#selector(ViewController.updateLabel)), userInfo: nil, repeats: true)
    }
    
    @objc func updateLabel(){
        self.stepCounterLabel.text = String(self.numberOfSteps)
        self.checkIfRequirementMet() // Checks to see if user has completed x number of steps
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

