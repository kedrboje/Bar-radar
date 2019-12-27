//
//  BarStore.swift
//  Bars
//
//  Created by Федор Рубченков on 27.12.2019.
//  Copyright © 2019 Федор Рубченков. All rights reserved.
//

import Foundation
import MapKit

class BarStore: NSObject {
    
    var allbars: [Bar]!
    
    init(allbars: [Bar]) {
        self.allbars = allbars
    }
    
    func findBars(currentLocation: CLLocationCoordinate2D, callback: @escaping ([Bar])->Void) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "бар"
        request.region = MKCoordinateRegion(center: currentLocation, latitudinalMeters: 7000, longitudinalMeters: 7000)
        let search = MKLocalSearch(request: request)
        search.start() { response, _ in
            guard let response = response else { return }
            for (_, item) in response.mapItems.enumerated() {
                self.allbars.append(Bar(placemark: item.placemark, name: item.name!))
            }
            callback(self.allbars)
        }
    }
    
    func getDistance(source: MKMapItem, bars: [Bar], getNearest: @escaping ([Bar])->Void) {
        for bar in bars {
            let request = MKDirections.Request()
            request.source = source
            request.destination = bar
            request.transportType = .walking
            let directions = MKDirections.init(request: request)
            directions.calculate { (response, _) in
                guard let response = response else { return }
                bar.distance = response.routes.first!.distance
            }
        }
        let _ = getNearest(self.allbars)
    }
    
}
