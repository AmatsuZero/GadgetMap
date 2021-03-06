//
//  RequestBuillder.swift
//  AMapAPI
//
//  Created by modao on 2018/3/12.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import Foundation

public protocol RequestBuildable {
    associatedtype ResponseType
    func toURLComponents() -> URLComponents
}

extension URL {
    static var amapBaseURL: URL {
        return URL(string: "http://restapi.amap.com/v3/")!
    }
}

extension URLComponents {
    var sig: String? {
        guard let key = AMapManager.shared?.privateKey, let queryPart = self.query else {
            return nil
        }
        return "sig=md5(\(queryPart)\(key))"
    }
}

extension GeoRequest: RequestBuildable {
    public typealias ResponseType = GeoResponse
    public func toURLComponents() -> URLComponents {
        let url = URL.amapBaseURL.appendingPathComponent("geocode").appendingPathComponent("geo")
        var components = URLComponents(string: url.absoluteString)
        let add = address.reduce("")  { return $0.isEmpty ? $1 : $0 + "|" + $1 }
        let addressItem = URLQueryItem(name: "address", value: add)
        let cityItem = URLQueryItem(name:"city", value: city)
        let batchItem = URLQueryItem(name: "batch", value: "\(batch)")
        let outputItem = URLQueryItem(name: "output", value: output.rawValue)
        let callbackItem = URLQueryItem(name: "callback", value: callback)
        let keyItem = URLQueryItem(name: "key", value: AMapManager.shared?.token)
        let sigItem = URLQueryItem(name: "sig", value: sig ? components?.sig: nil)
        components?.queryItems = [addressItem, cityItem, batchItem, sigItem, outputItem, callbackItem, keyItem]
        return components!
    }
    var request: URLRequest? {
        var req = URLRequest(url: toURLComponents().url!)
        req.httpMethod = "GET"
        return req
    }
}

extension RegeoRequest: RequestBuildable {
    public typealias ResponseType = RegeoResponse
    public func toURLComponents() -> URLComponents {
        let url = URL.amapBaseURL.appendingPathComponent("geocode").appendingPathComponent("regeo")
        var components = URLComponents(string: url.absoluteString)
        let locations = location.map { "\($0.coordinate.latitude),\($0.coordinate.longitude)" }.reduce("") { return $0.isEmpty ? $1 : $0 + "|" + $1 }
        let locItem = URLQueryItem(name: "location", value: locations)
        let keyItem = URLQueryItem(name: "key", value: AMapManager.shared?.token)
        let pois = poitype?.reduce("") { return $0.isEmpty ? $1 : $0 + "|" + $1 }
        let poiItem = URLQueryItem(name: "poitype", value: pois)
        let radiusItem = URLQueryItem(name: "radius", value: "\(radius)")
        let extItem = URLQueryItem(name: "extensions", value: extensions.rawValue)
        let rdLitem = URLQueryItem(name: "roadlevel", value: roadlevel?.rawValue == nil ? nil : "\(roadlevel!.rawValue)")
        let outputItem = URLQueryItem(name: "output", value: output.rawValue)
        let cbItem = URLQueryItem(name: "callback", value: callback)
        var items = [locItem, poiItem, radiusItem, extItem, rdLitem, outputItem, cbItem, keyItem]
        if let value = roadlevel?.rawValue {
            let rdLitem = URLQueryItem(name: "roadlevel", value: "\(value)")
            items.append(rdLitem)
        }
        if let value = strategy?.rawValue {
            let item = URLQueryItem(name: "homeorcorp", value: "\(value)")
            items.append(item)
        }
        let sigItem = URLQueryItem(name: "sig", value: sig ? components?.sig : nil)
        items.append(sigItem)
        components?.queryItems = items
        return components!
    }
}

extension GeoSearchService: RequestBuildable {
    public typealias ResponseType = GeoSearchResponse
    public func toURLComponents() -> URLComponents {
        let url = URL.amapBaseURL.appendingPathComponent("place").appendingPathComponent("text")
        var components = URLComponents(string: url.absoluteString)
        let kwItem = URLQueryItem(name: "keywords",
                                  value: keywords.reduce("") { return $0.isEmpty ? $1 : $0 + "|" + $1 })
        let typesItem = URLQueryItem(name: "types",
                                     value: types.reduce("") { return $0.isEmpty ? $1 : $0 + "|" + $1 })
        let cityItem = URLQueryItem(name: "city", value: city)
        let childrenItem = URLQueryItem(name: "children", value: showChildren ? "\(1)" : "\(0)")
        let limitItem = URLQueryItem(name: "citylimit", value: "\(cityLimit)")
        let offSetItem = URLQueryItem(name: "offset", value: "\(offset)")
        let pageItem = URLQueryItem(name: "page", value: "\(page)")
        let buildingItem = URLQueryItem(name: "building", value: building)
        let floorItem = URLQueryItem(name: "floor", value: floor)
        let extItem = URLQueryItem(name: "extensions", value: extensions.rawValue)
        let outputItem = URLQueryItem(name: "output", value: output.rawValue)
        let callbackItem = URLQueryItem(name: "callback", value: callback)
        let keyItem = URLQueryItem(name: "key", value: AMapManager.shared?.token)
        let sigItem = URLQueryItem(name: "sig", value: sig ? components?.sig : nil)
        components?.queryItems = [kwItem, typesItem, cityItem, childrenItem, limitItem, offSetItem,pageItem,
                                  buildingItem, floorItem, extItem, sigItem, outputItem, callbackItem, keyItem]
        return components!
    }
}
