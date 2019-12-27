//
//  MapViewController.swift
//  Bars
//
//  Created by Федор Рубченков on 27.12.2019.
//  Copyright © 2019 Федор Рубченков. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    let mapView = MapView()
    var bar = Bar(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 300, longitude: 300)), name: "PseudoBar")
    let regionRadius: CLLocationDistance = 1000
    
    override func viewDidLoad(){
        super.viewDidLoad()
        view = mapView
        let regionSpan = MKCoordinateRegion(center: bar.placemark.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
//        let options = [
//            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center),
//            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)
//        ]
//        bar.openInMaps(launchOptions: options)
        makeAnnotation(for: mapView.map)
        mapView.map.setRegion(regionSpan, animated: true)
        print(bar.name!, bar.distance)
    }
    
    func makeAnnotation(for map: MKMapView) {
        let barAnn = MKPointAnnotation()
        barAnn.title = bar.name
        barAnn.coordinate = bar.placemark.coordinate
        map.addAnnotation(barAnn)
    }
}

