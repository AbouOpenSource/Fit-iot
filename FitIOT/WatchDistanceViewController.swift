//
//  WatchDistanceViewController.swift
//  FitIOT
//
//  Created by sanou abou on 15/10/2019.
//  Copyright © 2019 sanou abou. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import SQLite3

class WatchDistanceViewController: UIViewController, CLLocationManagerDelegate
{
    
    var db = Database()
    
    //for compute the distance
    let locationManager = CLLocationManager()
    var tableauxCLLOcation : [CLLocation] = []
    var distance: CLLocationDistance = 0.0
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var labelUnit: UILabel!
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    var timer = Timer()
    var isTimerRunning = false
    var counter = 0.0
    override func viewDidLoad() {
         db.openDatabase()
        // db.createTable()
        
    
        
        
        //test of authorization
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        super.viewDidLoad()
        saveButton.isHidden=true
        resumeButton.isHidden=true
        //test if all is enabled
    
    }
    /*Function overloadinf of locationManger*/
   
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print()
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        let getLat:CLLocationDegrees = locValue.latitude
        let getLon:CLLocationDegrees = locValue.longitude
        
        let position :CLLocation = CLLocation(latitude:getLat , longitude: getLon)
        tableauxCLLOcation.append(position)
        totalDistance(of: tableauxCLLOcation)
        
        
    }
    
    
    
    
    
    
    @IBAction func resumeDidTap(_ sender: Any) {
        saveButton.isHidden=true
        resumeButton.isHidden=true
        startButton.isHidden=false
        if !isTimerRunning {
            timer=Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(runTimer), userInfo: nil, repeats: true)
            isTimerRunning=true
            
            startButton.setTitle("Stop", for: .normal)
        }
        else
        {
            timer.invalidate()
            startButton.isHidden=true
            resumeButton.isHidden=false
            saveButton.isHidden=false
            isTimerRunning=false
        }
    }
    
    
    
    
    
    
    
    
    @IBAction func startDidTap(_ sender: Any) {
        if !isTimerRunning {
            timer=Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(runTimer), userInfo: nil, repeats: true)
            isTimerRunning=true
            activeLocation()
            startButton.setTitle("Stop", for: .normal)
        }
        else
        {
            
        timer.invalidate()
            startButton.isHidden=true
            resumeButton.isHidden=false
            saveButton.isHidden=false
            isTimerRunning=false
            desactiveLocation()
        }
    }
    
    @IBAction func saveDidTap(_ sender: Any) {
      let item = Running(time: String(counter),distance: String(distance))
       // db.addRunning(running: item)
        db.addRunning(running: item)
        
    }
    
    /**
     *method call each 0.1 second
     */
    @objc func runTimer(){
        
        //distanceLabel.text(totalDistance(of: tableauxCLLOcation))
       // print(tableauxCLLOcation)
        counter+=0.1
        let flooredCounter = Int(floor(counter))
        let hour = flooredCounter/3600
        let minute = (flooredCounter % 3600) / 60
        
        var minuteString = "\(minute)"
        
        if minute < 10 {
            minuteString = "0\(minute)"
        }
        let second = (flooredCounter % 3600) % 60
        var secondString = "\(second)"
        if second < 10
        {
            secondString = "0\(second)"
        }
        let decisecond = String(format:"%.1f",counter).components(separatedBy: ".").last!
        timerLabel.text = "\(hour):\(minuteString):\(secondString).\(decisecond)"
        
        if distance>1000{
            labelUnit.text="km"
            distanceLabel.text = String(distance.rounded()/1000)
            
        }else{
            distanceLabel.text = String(distance.rounded())
        }
        
        }
    

    func totalDistance(of locations: [CLLocation]) {
        
        var previousLocation: CLLocation?
        locations.forEach { location in
            if let previousLocation = previousLocation {
                distance += location.distance(from: previousLocation)
            }
            previousLocation = location
        }
    }

    func activeLocation(){
           if CLLocationManager.locationServicesEnabled() {
         locationManager.delegate = self
         locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
         locationManager.startUpdatingLocation()
         }
    }
    func desactiveLocation(){
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.stopUpdatingLocation()
        }
    }




}
