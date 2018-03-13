//
//  ViewController.swift
//  Demo
//
//  Created by modao on 2018/3/13.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import UIKit
import AMapAPI
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    let apiKey = "08e16d6e813d70419d0f59d1379ffbe7"
    
    var coordinateQuadTree: GeoCoordinateQuadTree? {
        didSet {
            if let tree = coordinateQuadTree {
                
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AMapManager.initialize(key: apiKey)
        let decoder = JSONDecoder()
        var req = GeoSearchService(keywords: ["北京大学"], types: ["高等院校"])
        req.city = "北京"
        req.showChildren = true
        req.offset = 20
        req.page = 1
        req.extensions = .all
        URLSession.shared.dataTask(with: req.toURLComponents().url!) { [weak self] data, response, error in
            if let jsonData = data {
                do {
                    let geocode = try decoder.decode(GeoSearchResponse.self, from: jsonData)
                    self?.coordinateQuadTree = GeoCoordinateQuadTree(data: geocode.pois)
                } catch(let e) {
                   print(e.localizedDescription)
                }
            }
        }.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//MARK: - MapView Delegate
extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {

    }
}
