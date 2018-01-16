//
//  SquatViewController.swift
//  ActiveAlarm
//
//  Created by Andy Kwong on 1/15/18.
//  Copyright © 2018 Omar Ihmoda. All rights reserved.
//

import Foundation
import UIKit
import CoreMotion

class SquatViewController: UIViewController {
    
    var motionManager = CMMotionManager()
    let opQueue = OperationQueue()
    
    var date = NSDate()
    
    let sampleInterval = 1.0/50
    
    var up = false
    var down = false
    var counter = 0
    
    var timer = Timer()
    var seconds = 60
    var tolerance: Double = 1.0
    
    var rateAlongGravityBuffer = [Double]()
    
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
                let gravity = mydata.gravity
                let rotationRate = mydata.rotationRate
                
                let rateAlongGravity = rotationRate.x * gravity.x + rotationRate.y * gravity.y + rotationRate.z * gravity.z
                if self.down && self.up {
                    self.counter += 1
                    print(self.counter)
                    self.down = false
                    self.up = false
                }
//                if x < -self.tolerance {
//                    self.down = true
//                } else if y > self.tolerance {
//                    self.up = true
//                }
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
