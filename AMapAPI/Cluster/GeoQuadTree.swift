//
//  CoordinateQuadTree.swift
//  AMapAPI
//
//  Created by modao on 2018/3/12.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import Foundation
import MapKit

public protocol GeoMapQuadTreeNodeDataDelegate {
    var quadTreeNodeData: GeoMapQuadTreeNodeData { get }
}

public struct GeoMapQuadTreeNodeData {
    var x: CLLocationDegrees
    var y: CLLocationDegrees
    var data: GeoMapQuadTreeNodeDataDelegate
}

public struct GeoMapBoundingBox {
    var x0: CLLocationDegrees
    var xf: CLLocationDegrees
    var y0: CLLocationDegrees
    var yf: CLLocationDegrees

    init(x0: CLLocationDegrees, y0: CLLocationDegrees, xf: CLLocationDegrees, yf: CLLocationDegrees) {
        self.x0 = x0
        self.y0 = y0
        self.xf = xf
        self.yf = yf
    }

    init(rect: MKMapRect) {
        let topLeft = MKCoordinateForMapPoint(rect.origin)
        let bottomRight = MKCoordinateForMapPoint(MKMapPoint(x: MKMapRectGetMaxX(rect), y: MKMapRectGetMaxY(rect)))
        let minLat = bottomRight.latitude
        let maxLat = topLeft.latitude
        let minLon = topLeft.longitude
        let maxLon = bottomRight.longitude
        self.init(x0: minLat, y0: minLon, xf: maxLat, yf: maxLon)
    }

    func contains(data: GeoMapQuadTreeNodeData) -> Bool {
        let containsX = x0 <= data.x && data.x <= xf
        let containsY = y0 <= data.y && data.y <= yf
        return containsX && containsY
    }

    func isIntersected(with b2: GeoMapBoundingBox) -> Bool {
        return x0 <= b2.xf && xf >= b2.x0 && y0 <= b2.yf && yf >= b2.y0
    }

    var rect: MKMapRect {
        let topLeft = MKMapPoint(x: x0, y: y0)
        let bottomRight = MKMapPoint(x: xf, y: yf)
        return MKMapRect(origin: MKMapPoint(x: topLeft.x,
                                            y: bottomRight.y),
                         size: MKMapSize(width: fabs(bottomRight.x-topLeft.x),
                                         height: fabs(bottomRight.y-topLeft.y)))
    }
}

public final class GeoQuadTreeNode {
    var northWest: GeoQuadTreeNode?
    var northEast: GeoQuadTreeNode?
    var southWest: GeoQuadTreeNode?
    var southEast: GeoQuadTreeNode?
    let boundingBox: GeoMapBoundingBox
    let bucketCapcity: Int
    var points = [GeoMapQuadTreeNodeData]()

    public init(boundingBox: GeoMapBoundingBox, bucketCapcity: Int) {
        self.boundingBox = boundingBox
        self.bucketCapcity = bucketCapcity
    }

    convenience init(data: [GeoMapQuadTreeNodeData], boundingBox: GeoMapBoundingBox, capacity: Int) {
        self.init(boundingBox: boundingBox, bucketCapcity: capacity)
        data.forEach { nodeData in
            self.insertData(data: nodeData)
        }
    }

    func subdivide()  {
        let xMid = (boundingBox.xf+boundingBox.x0)/2
        let yMid = (boundingBox.yf+boundingBox.y0)/2
        let northWestBox = GeoMapBoundingBox(x0: boundingBox.x0, y0: boundingBox.y0, xf: xMid, yf: yMid)
        northWest = GeoQuadTreeNode(boundingBox: northWestBox, bucketCapcity: bucketCapcity)
        let northEastBox = GeoMapBoundingBox(x0: xMid, y0: boundingBox.y0, xf: boundingBox.xf, yf: yMid)
        northEast = GeoQuadTreeNode(boundingBox: northEastBox, bucketCapcity: bucketCapcity)
        let southWestBox = GeoMapBoundingBox(x0: boundingBox.x0, y0: yMid, xf: xMid, yf: boundingBox.yf)
        southWest = GeoQuadTreeNode(boundingBox: southWestBox, bucketCapcity: bucketCapcity)
        let southEastBox = GeoMapBoundingBox(x0: xMid, y0: yMid, xf: boundingBox.xf, yf: boundingBox.yf)
        southEast = GeoQuadTreeNode(boundingBox: southEastBox, bucketCapcity: bucketCapcity)
    }

    @discardableResult
    func insertData(data: GeoMapQuadTreeNodeData) -> Bool {
        guard boundingBox.contains(data: data) else {
            return false
        }
        if points.count < bucketCapcity {
            points.append(data)
            return true
        }
        if northWest == nil { subdivide() }
        if northWest?.insertData(data: data) == true { return true }
        if northEast?.insertData(data: data) == true { return true }
        if southWest?.insertData(data: data) == true { return true }
        if southEast?.insertData(data: data) == true { return true }
        return false
    }

    func gatherData(in range: GeoMapBoundingBox, callback: (GeoMapQuadTreeNodeData) -> Void) {
        guard boundingBox.isIntersected(with: range) else { return }
        points.forEach { point in
            if range.contains(data: point) {
                callback(point)
            }
        }
        guard let nw = northWest else { return }
        nw.gatherData(in: range, callback: callback)
        northEast?.gatherData(in: range, callback: callback)
        southWest?.gatherData(in: range, callback: callback)
        southEast?.gatherData(in: range, callback: callback)
    }

    func forEach(block: (GeoQuadTreeNode) -> Void) {
        block(self)
        guard let nw = northWest else { return }
        nw.forEach(block: block)
        northEast?.forEach(block: block)
        southWest?.forEach(block: block)
        southEast?.forEach(block: block)
    }
}
