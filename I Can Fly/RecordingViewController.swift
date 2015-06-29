//
//  RecordingViewController.swift
//  I Can Fly
//
//  Created by Frank Luan on 6/28/15.
//  Copyright (c) 2015 Frank LSF. All rights reserved.
//

import UIKit
import Charts
import CoreMotion

class RecordingViewController: UIViewController {

    var updateInterval = 0.3
    
    var motionManager = CMMotionManager()
    
    var accelerationData = LineChartDataSet(yVals: nil, label: "Accl")
    var xLabels = [String]()
    var loopCount = 0
    
    @IBOutlet weak var toggleButton: UIButton!
    @IBOutlet weak var chartView: LineChartView!
    
    override func viewDidLoad() {
        // Initialize Motion Manager
        motionManager.accelerometerUpdateInterval = updateInterval
        motionManager.gyroUpdateInterval = updateInterval
        
        // Initialize Chart
        chartView.legend.enabled = false
        chartView.rightAxis.enabled = false
        let nf = NSNumberFormatter()
        nf.maximumFractionDigits = 2
        nf.numberStyle = .DecimalStyle
        chartView.leftAxis.valueFormatter = nf
        chartView.backgroundColor = UIColor.clearColor()
        
        accelerationData.drawCubicEnabled = true
        
        // Start Motion Manager
        motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue()) { data, error in
            self.recordAccelerationData(data)
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // MARK: - Core Motion
    
    func recordAccelerationData(data: CMAccelerometerData) {
        ++loopCount
        let accl = data.acceleration
        let modulus = sqrt(accl.x * accl.x + accl.y * accl.y + accl.z * accl.z)
        let entry = ChartDataEntry(value: Float(modulus), xIndex: loopCount)
        accelerationData.addEntry(entry)
        xLabels.append(String(loopCount))
        chartView.data = LineChartData(xVals: xLabels, dataSet: accelerationData)
        NSLog("Acceleration data point: \(data)")
    }
    
    func recordGyroData(data: CMGyroData) {
        NSLog("gyro \(data)")
    }
    
    // MARK: - Controls
    
    @IBAction func toggleButtonTouched(sender: UIButton) {
        if motionManager.accelerometerActive {
            motionManager.stopAccelerometerUpdates()
        } else {
            motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue()) { data, error in
                self.recordAccelerationData(data)
            }
        }
    }

}
