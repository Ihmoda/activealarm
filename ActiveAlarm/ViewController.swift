import UIKit
import CoreMotion

protocol TurnAlarmOff {
    // Passes bool to AlarmViewController to switch off alarm
    
    func AlarmOff(yesOrNo: Bool)
    
}

class ViewController: UIViewController {
    
    var delegate : TurnAlarmOff?
    
    var motionManager = CMMotionManager()
    let opQueue = OperationQueue()
    
    var date = NSDate()
    
    var right = false
    var left = false
    var counter = 0
    
    var timer = Timer()
    var seconds = 60
    var tolerance: Double = 1.0
    
    var passedInFromAlarm = ""
    
    @IBOutlet weak var counterLabel: UILabel!
    @IBOutlet weak var thresholdSlider: UISlider!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(date)
        self.runTimer()
        
        if motionManager.isDeviceMotionAvailable {
            print("We can detect device motion")
            startReadingMotionData()
        }
        else {
            print("We cannot detect device motion")
        }
        
        print(passedInFromAlarm)
        
    }

    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self,   selector: (#selector(ViewController.updateLabel)), userInfo: nil, repeats: true)
    }
    
    @objc func updateLabel(){
        self.counterLabel.text = String(counter)
    }
    
    func checkIfRequirementMet() {
        // Dismissed view after a certain number of shakes
        if counter >= 30 {
            delegate?.AlarmOff(yesOrNo: true)
            self.counter = 0
            dismiss(animated: true, completion: nil)
        }
    }
    
    func startReadingMotionData() {
        // set read speed
        motionManager.deviceMotionUpdateInterval = 0.02
        // start reading
        motionManager.startDeviceMotionUpdates(to: opQueue) {
            (data: CMDeviceMotion?, error: Error?) in
            
            if let mydata = data {
                let x = mydata.userAcceleration.x
                let y = mydata.userAcceleration.y
                if self.left && self.right {
                    self.counter += 1
                    print(self.counter)
                    self.left = false
                    self.right = false
                    self.checkIfRequirementMet()
                }
                if x < -self.tolerance {
                    self.left = true
                } else if y > self.tolerance {
                    self.right = true
                }
            }
        }
    }
    
    
    
    func degrees(_ radians: Double) -> Double {
        return 180/Double.pi * radians
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        tolerance = Double(1.0 + sender.value)
    }
    
}
