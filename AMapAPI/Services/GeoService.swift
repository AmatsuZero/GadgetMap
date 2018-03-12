//
//  GeoServices.swift
//  AMapAPI
//
//  Created by modao on 2018/3/12.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import Foundation
import CoreLocation

public struct GeoRequest {
    /// 结构化地址信息
    /// 规则遵循：国家、省份、城市、区县、城镇、乡村、街道、门牌号码、屋邨、大厦，如：北京市朝阳区阜通东大街6号。
    /// 如果需要解析多个地址的话，请用"|"进行间隔，并且将 batch 参数设置为 true，最多支持 10 个地址进进行"|"分割形式的请求。
    var address: [String]
    /// 指定查询的城市
    /// 可选输入内容包括：指定城市的中文（如北京）、指定城市的中文全拼（beijing）、citycode（010）、adcode（110000）。
    /// 当指定城市查询内容为空时，会进行全国范围内的地址转换检索。
    var city: String?
    /// 批量查询控制
    /// batch 参数设置为 true 时进行批量查询操作，最多支持 10 个地址进行批量查询。
    /// batch 参数设置为 false 时进行单点查询，此时即使传入多个地址也只返回第一个地址的解析查询结果。
    var batch: Bool
    /// 是否添加数字签名
    var sig: Bool
    /// 返回数据格式类型
    /// 可选输入内容包括：JSON，XML。设置 JSON 返回结果数据将会以JSON结构构成；如果设置 XML 返回结果数据将以 XML 结构构成。
    var output: AMapOutputType
    /// 回调函数
    /// callback 值是用户定义的函数名称，此参数只在 output 参数设置为 JSON 时有效。
    var callback: String?

    init(address: [String], city: String? = nil, batch: Bool? = nil, sig: Bool = false, output: AMapOutputType = .json, callback: String? = nil) {
        self.address = address
        self.city = city
        if let isBatchSupport = batch {
            self.batch = isBatchSupport
        } else {
            self.batch = address.count > 1 ? true : false
        }
        self.sig = sig
        self.output = output
        self.callback = callback
    }
}

public struct GeoResponse: Codable {
    struct Geocode: Codable {
        let formattedAddress: String
        let province: String
        var city: String
        let cityCode: String
        let district: String
        let township: String?
        let street: String?
        let number: String?
        let adcode: String
        let location: String
        let building: GeoBuilding
        let neighborhood: GeoNeighborhood
        let level: GeoLevel

        enum CodingKeys: String, CodingKey {
            case formattedAddress = "formatted_address"
            case cityCode = "citycode"
            case province, city, district, township, street, number, adcode
            case location, level
            case building, neighborhood
        }

        enum GeoLevel: String, Codable {
            case country = "国家"
            case province = "省"
            case city = "市"
            case district = "区县"
            case developmentZone = "开发区"
            case township = "乡镇"
            case village = "村庄"
            case bussinessArea = "热点商圈"
            case poi = "兴趣点"
            case street = "门牌号"
            case unit = "单元号"
            case road = "道路"
            case cross = "道路交叉口"
            case station = "公交站台、地铁站"
            case unknown = "未知"
        }

        public init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            formattedAddress = try values.decode(String.self, forKey: .formattedAddress)
            province = try values.decode(String.self, forKey: .province)
            city = try values.decode(String.self, forKey: .city)
            cityCode = try values.decode(String.self, forKey: .cityCode)
            district = try values.decode(String.self, forKey: .district)
            township = try? values.decode(String.self, forKey: .township)
            street = try? values.decode(String.self, forKey: .street)
            number = try? values.decode(String.self, forKey: .number)
            adcode = try values.decode(String.self, forKey: .adcode)
            location = try values.decode(String.self, forKey: .location)
            building = try values.decode(GeoBuilding.self, forKey: .building)
            neighborhood = try values.decode(GeoNeighborhood.self, forKey: .neighborhood)
            level = try values.decode(GeoLevel.self, forKey: .level)
        }

        var clLocation: CLLocation? {
            let coordinates = location.components(separatedBy: ",")
            guard let lat = coordinates.first, let lon = coordinates.last,
                let latitude = CLLocationDegrees(lat),
                let longitude = CLLocationDegrees(lon) else {
                    return nil
            }
            return CLLocation(latitude: latitude, longitude: longitude)
        }
    }
    
    private let status: String
    private let info: String
    private let infoCode: Int
    private let count: Int
    let geoCodes: [Geocode]

    enum CodingKeys: String, CodingKey {
        case infoCode = "infocode"
        case geoCodes = "geocodes"
        case status, info, count
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decode(String.self, forKey: .status)
        infoCode = (try Int(values.decode(String.self, forKey: .infoCode)))!
        guard status == "1" else {
            throw ServiceError(code: infoCode)!
        }
        info = try values.decode(String.self, forKey: .info)
        count = (try Int(values.decode(String.self, forKey: .count)))!
        geoCodes = try values.decode(Array<Geocode>.self, forKey: .geoCodes)
    }
}
