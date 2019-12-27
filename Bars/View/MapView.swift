//
//  MapVeiw.swift
//  Bars
//
//  Created by Федор Рубченков on 27.12.2019.
//  Copyright © 2019 Федор Рубченков. All rights reserved.
//

import UIKit
import MapKit

class MapView: UIView {
    
    lazy var map: MKMapView = {
        let map = MKMapView()
        map.showsScale = true
        map.showsUserLocation = true
        map.showsBuildings = true
        map.userTrackingMode = .followWithHeading
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        self.addSubview(map)
        NSLayoutConstraint.activate([
            map.topAnchor.constraint(equalTo: self.topAnchor),
            map.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            map.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            map.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
}
