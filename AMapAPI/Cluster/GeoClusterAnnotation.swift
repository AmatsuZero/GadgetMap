//
//  GeoClusterAnnotation.swift
//  AMapAPI
//
//  Created by modao on 2018/3/13.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import UIKit
import MapKit

class GeoClusterAnnotation:NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    let count: Int
    init(coordinate: CLLocationCoordinate2D, count: Int) {
        self.coordinate = coordinate
        self.count = count
        super.init()
    }
    override var hash: Int {
        return "\(coordinate.latitude)\(coordinate.longitude)".hashValue
    }
}
