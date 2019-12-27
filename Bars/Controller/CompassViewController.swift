//
//  ViewController.swift
//  Bars
//
//  Created by Федор Рубченков on 27.12.2019.
//  Copyright © 2019 Федор Рубченков. All rights reserved.
//

import UIKit
import MapKit

protocol SegueDelegate: class {
    func onBarNameTapped()
}

class CompassViewController: UIViewController {

    let locationManager = CLLocationManager()
    let compassView = CompassView()
    let regionRadius = 5000
    let serialQueue = DispatchQueue.global(qos: .userInitiated)
    var bars = BarStore(allbars: [Bar]())
    var nearest: Bar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        compassView.delegate = self
        view = compassView
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        locationManager.startUpdatingHeading()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .darkContent }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
}

extension CompassViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.startUpdatingLocation()
        guard let location = locationManager.location else { return }
        bars.findBars(currentLocation: locationManager.location!.coordinate) { (store) in
            self.bars.getDistance(source: MKMapItem(placemark: MKPlacemark(coordinate: location.coordinate)), bars: store, getNearest: { finalStore in
                var nearestBar = finalStore[0]
                for item in finalStore {
                    if item.distance < nearestBar.distance {
                        nearestBar = item
                    }
                }
                self.nearest = nearestBar
                DispatchQueue.main.async {
                    self.compassView.nameActivity.stopAnimating()
                    self.compassView.barName.isHidden = false
                    self.compassView.barName.setTitle(nearestBar.name, for: .normal)
                    if nearestBar.distance != 100000 {
                        self.compassView.activity.stopAnimating()
                        self.compassView.distance.isHidden = false
                        self.compassView.distance.text = String(describing: self.nearest!.distance)
                    }
                }
            })
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        if newHeading.headingAccuracy < 0 { return }
        guard let near = nearest else { return }
        let heading: CLLocationDirection = ((newHeading.trueHeading > 0) ? newHeading.trueHeading : newHeading.magneticHeading)
        guard let location = locationManager.location else { return }
        let bearing = getBearing(location: location, bar: near)
        let res = CGFloat(heading) - CGFloat(bearing)
        UIView.animate(withDuration: 0.5)
        {
            let angle = CGFloat(res).degreesToRadians
            self.compassView.arrow.transform = CGAffineTransform(rotationAngle: -CGFloat(angle))
            print(heading, bearing)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func getBearing(location: CLLocation, bar: Bar) -> CGFloat {
        let latSource = CGFloat(location.coordinate.latitude).degreesToRadians
        let lonSource = CGFloat(location.coordinate.longitude).degreesToRadians
        
        let latBar = CGFloat(bar.placemark.coordinate.latitude).degreesToRadians
        let lonBar = CGFloat(bar.placemark.coordinate.longitude).degreesToRadians
        
        let dLon = lonBar - lonSource
        
        let y = sin(dLon)*cos(latBar)
        let x = cos(latSource)*sin(latBar) - sin(latSource)*cos(latBar)*cos(dLon)
        let radiansBearing = atan2(y, x)
        
        return (radiansBearing.radiansToDegrees>0) ? radiansBearing.radiansToDegrees : radiansBearing.radiansToDegrees + 360
    }
    
}

extension CompassViewController: SegueDelegate {
    
    func onBarNameTapped() {
        let VC = MapViewController()
        guard let nearest = self.nearest else {
            let alert = UIAlertController(title: "Wait please", message: "It's recommended for you to be patient", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))

            DispatchQueue.main.async {
                self.present(alert, animated: true)
            }
            return
        }
        VC.bar = nearest
        navigationController?.pushViewController(VC, animated: true)
    }
}

extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}
