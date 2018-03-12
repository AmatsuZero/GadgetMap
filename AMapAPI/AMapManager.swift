//
//  AMapManager.swift
//  AMapAPI
//
//  Created by modao on 2018/3/12.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import Foundation

public enum AMapOutputType: String {
    case json = "JSON"
    case xml = "XML"
}

public final class AMapManager {
    static var shared: AMapManager?
    let token: String
    let privateKey: String
    private init(key: String, privateKey: String) {
        token = key
        self.privateKey = privateKey
    }

    enum AMapService {
        case geo(GeoRequest)
        case regeo(RegeoRequest)
    }

    @discardableResult
    class func initialize(key: String, privateKey: String = "") -> AMapManager {
        guard shared == nil  else { return shared! }
        shared = AMapManager(key: key, privateKey: privateKey)
        return shared!
    }
}

