import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    var motionManager = CMMotionManager()
    let opQueue = OperationQueue()
    
    var date = NSDate()
    
    var right = false
    var left = false
    var counter = 0
    
    var timer = Timer()
    var seconds = 60
    
    @IBOutlet weak var counterLabel: UILabel!
    
    
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
    }
    
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self,   selector: (#selector(ViewController.updateLabel)), userInfo: nil, repeats: true)
    }
    
    @objc func updateLabel(){
        self.counterLabel.text = String(counter)
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
                }
                if x < -1.0 {
                    self.left = true
                } else if y > 1.0 {
                    self.right = true
                }
                
                
            }
            
            
        }
    }
    
    
    
    func degrees(_ radians: Double) -> Double {
        return 180/Double.pi * radians
    }
    
}
