//
//  ViewController.swift
//  Detect-a-Beacon
//
//  Created by Dmitry Reshetnik on 10.05.2020.
//  Copyright © 2020 Dmitry Reshetnik. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var distanceReading: UILabel!
    @IBOutlet weak var idReading: UILabel!
    
    var locationManager: CLLocationManager?
    var isBeaconFound: Bool = false
    var circle: UIView! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()
        
        circle = UIView(frame: CGRect(x: view.frame.midX - 128, y: view.frame.midY - 128, width: 256, height: 256))
        circle.layer.cornerRadius = 128
        circle.layer.backgroundColor = CGColor.init(srgbRed: 0, green: 0, blue: 0, alpha: 1)
        circle.layer.borderWidth = 2
        circle.backgroundColor = .clear
        view.addSubview(circle)
        view.backgroundColor = .gray
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let beacon = beacons.first {
            if !isBeaconFound {
                let ac = UIAlertController(title: "Found", message: "We found beacon with id: \(beacon.uuid.uuidString)", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
                isBeaconFound = true
            }
            idReading.text = beacon.uuid.uuidString
            update(distance: beacon.proximity)
        } else {
            idReading.text = "id"
            update(distance: .unknown)
        }
    }
    
    func startScanning() {
        let uuid = UUID(uuidString: "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0")!
//        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let beaconRegion = CLBeaconRegion(uuid: uuid, major: 123, minor: 456, identifier: "Beacon")
        
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(satisfying: CLBeaconIdentityConstraint(uuid: uuid, major: 123, minor: 456))
    }
    
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 0.8) {
            switch distance {
            case .far:
                self.view.backgroundColor = UIColor.blue
                self.distanceReading.text = "FAR"
                self.circle.transform = CGAffineTransform.identity
                self.circle.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
            case .near:
                self.view.backgroundColor = UIColor.orange
                self.distanceReading.text = "NEAR"
                self.circle.transform = CGAffineTransform.identity
                self.circle.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            case .immediate:
                self.view.backgroundColor = UIColor.red
                self.distanceReading.text = "RIGHT HERE"
                self.circle.transform = CGAffineTransform.identity
            default:
                self.view.backgroundColor = UIColor.gray
                self.distanceReading.text = "UNKNOWN"
                self.circle.transform = CGAffineTransform.identity
                self.circle.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
            }
        }
    }


}

