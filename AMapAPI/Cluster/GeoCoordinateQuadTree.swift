//
//  GeoCoordinateQuadTree.swift
//  AMapAPI
//
//  Created by modao on 2018/3/13.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import Foundation
import MapKit

public class GeoCoordinateQuadTree {

    fileprivate let root: GeoQuadTreeNode

    public init(data: [GeoMapQuadTreeNodeDataDelegate]) {
        let world = GeoMapBoundingBox.init(x0: 19, y0: -166, xf: 72, yf: -53)
        let dataArray = data.map { $0.quadTreeNodeData }
        root = GeoQuadTreeNode(data: dataArray, boundingBox: world, capacity: 4)
    }

    public func clusteredAnnotations(in rect: MKMapRect, zoomScale: MKZoomScale) -> [MKAnnotation] {
        let cellSize = zoomScale.cellSize
        let scaleFactor = Double(zoomScale/cellSize)
        let minX = floor(MKMapRectGetMidX(rect)*scaleFactor)
        let maxX = floor(MKMapRectGetMaxX(rect)*scaleFactor)
        let minY = floor(MKMapRectGetMinY(rect)*scaleFactor)
        let maxY = floor(MKMapRectGetMaxY(rect)*scaleFactor)
        var clusterAnnotations = [MKAnnotation]()
        for x in Int(minX)...Int(maxX) {
            for y in Int(minY)...Int(maxY) {
                let mapRect = MKMapRect(origin: MKMapPoint(x: Double(x)/scaleFactor, y: Double(y)/scaleFactor),
                                        size: MKMapSize(width: 1.0/scaleFactor, height: 1.0/scaleFactor))
                var totalX: CLLocationDegrees = 0
                var totalY: CLLocationDegrees = 0
                var count = 0
                root.gatherData(in: GeoMapBoundingBox(rect: mapRect)) { data in
                    totalX += data.x
                    totalY += data.y
                    count += 1
                }
                if count == 1 {
                    let coordinate = CLLocationCoordinate2D(latitude: totalX, longitude: totalY)
                    let annotation = GeoClusterAnnotation(coordinate: coordinate, count: count)
                    clusterAnnotations.append(annotation)
                } else if count > 1 {
                    let coordinate = CLLocationCoordinate2D(latitude: totalX/Double(count),
                                                            longitude: totalY/Double(count))
                    let annotation = GeoClusterAnnotation(coordinate: coordinate, count: count)
                    clusterAnnotations.append(annotation)
                }
            }
        }
        return clusterAnnotations
    }
}


extension MKZoomScale {
    var zoomlevel: Int {
        let totalTilesAtMaxZoom = MKMapSizeWorld.width/256.0
        let zoomLevelAtMaxZoom = log2(totalTilesAtMaxZoom)
        return Int(Swift.max(0, zoomLevelAtMaxZoom + floor(log2(Double(self))+0.5)))
    }
    var cellSize: CGFloat {
        switch zoomlevel {
        case 13...15: return 64
        case 16...18: return 32
        case 19: return 16
        default: return 88
        }
    }
}
