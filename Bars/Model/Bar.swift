//
//  Bar.swift
//  Bars
//
//  Created by Федор Рубченков on 27.12.2019.
//  Copyright © 2019 Федор Рубченков. All rights reserved.
//

import Foundation
import MapKit

class Bar: MKMapItem {
    
    var distance: CLLocationDistance = 100000
    
    func makeAnnotation(for map: MKMapView) {
        let barAnn = MKPointAnnotation()
        barAnn.title = self.name
        barAnn.coordinate = self.placemark.coordinate
        map.addAnnotation(barAnn)
    }
    
    init(placemark: MKPlacemark, name: String) {
        super.init(placemark: placemark)
        self.name = name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
