//
//  RegeoService.swift
//  AMapAPI
//
//  Created by modao on 2018/3/12.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import Foundation
import CoreLocation

public struct RegeoRequest {
    enum RegeoRequestExtension: String {
        case base = "base"
        case all = "all"
    }
    enum RegeoRoadMapLevel: Int {
        /// 显示所有道路
        case all = 0
        /// 过滤非主干道路，仅输出主干道路数据
        case main = 1
    }
    enum RegeoPOIStrategy: Int {
        /// 不对召回的排序策略进行干扰。
        case none = 0
        /// 综合大数据分析将居家相关的 POI 内容优先返回，即优化返回结果中 pois 字段的poi顺序。
        case home = 1
        /// 综合大数据分析将公司相关的 POI 内容优先返回，即优化返回结果中 pois 字段的poi顺序。
        case company = 2
    }
    /// 经纬度坐标
    var location: [CLLocation]
    /// 返回附近POI类型
    var poitype: [Int]?
    /// 搜索半径
    var radius: Int
    /// 返回结果控制
    var extensions: RegeoRequestExtension
    /// 批量查询控制
    var batch: Bool
    /// 道路等级
    var roadlevel: RegeoRoadMapLevel?
    var sig: Bool
    /// 返回数据格式类型
    var output: AMapOutputType
    /// 回调函数
    var callback: String?
    /// 是否优化POI返回顺序
    var strategy: RegeoPOIStrategy?
    init(location: [CLLocation], poitype: [Int]? = nil,
         radius: Int = 1000, extensions: RegeoRequestExtension = .base,
         batch: Bool = false, roadLevel: RegeoRoadMapLevel? = nil,
         sig: Bool = false, output: AMapOutputType = .json,
         callback: String? = nil, homeorcorp: RegeoPOIStrategy? = .none) {
        self.location = location
        self.poitype = poitype
        self.radius = radius
        self.extensions = extensions
        self.batch = batch
        self.roadlevel = roadLevel
        self.sig = sig
        self.output = output
        self.callback = callback
        self.strategy = homeorcorp
    }
}

public struct RegeoResponse: Codable {
    enum CodingKeys: String, CodingKey {
        case regeoCode = "regeocode"
        case infoCode = "infocode"
        case status, info
    }
    struct RegeoCode: Codable {
        struct RegeoAddressComponent: Codable {
            let province: String
            let city: [String]
            let cityCode: String
            let district: String
            let adcode: String
            let township: String
            let towncode: String
            let neighborhood: GeoNeighborhood
            let building: GeoBuilding
            let streetNumber: GeoStreet
            let country: String
            let businessAreas: [GeoBusiness]?
            enum CodingKeys: String, CodingKey {
                case province, city, district, adcode, township, towncode, neighborhood
                case building, streetNumber, country, businessAreas
                case cityCode = "citycode"
            }
        }
        let formattedAddress: String
        let addressComponent: RegeoAddressComponent
        let roads: [GeoRoad]?
        let roadinters: [GeoRoadinter]?
        let pois: [GeoPOI]?
        let aois: [GeoAOI]?
        enum CodingKeys: String, CodingKey {
            case formattedAddress = "formatted_address"
            case addressComponent, roads, roadinters, pois, aois
        }
    }
    let status: String
    let info: String
    let infoCode: String
    let regeoCode: RegeoCode

    func errorInfo() -> Error? {
        return ServiceError(code: Int(info)!)
    }
}
