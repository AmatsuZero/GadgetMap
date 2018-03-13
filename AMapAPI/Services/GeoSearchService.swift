//
//  GeoSearch.swift
//  GadgetMap
//
//  Created by modao on 2018/3/12.
//  Copyright © 2018年 MockingBot. All rights reserved.
//

import Foundation

public struct GeoSearchService {
    /// 查询关键字
    public var keywords: [String]
    /// 查询POI类型
    public var types: [String]
    /// 查询城市
    public var city: String?
    /// 仅返回指定城市数据
    public var cityLimit: Bool
    /// 是否按照层级展示子POI数据
    public var showChildren: Bool
    /// 每页记录数据
    public var offset: Int
    /// 当前页数
    public var page: Int
    /// 搜索楼层
    public var floor: String?
    /// 返回结果控制
    public var extensions: GeoRequestExtension
    /// 数字签名
    public var sig: Bool
    /// 返回数据格式类型
    public var output: AMapOutputType
    /// 回调函数
    public var callback: String?
    /// 建筑物的POI编号
    public var building: String?

    public init(keywords: [String], types: [String], city: String? = nil,
         cityLimit: Bool = false, showChildren: Bool = false, offset: Int = 20,
         page: Int = 1, building: String? = nil, floor: String? = nil,
         extensions: GeoRequestExtension = .base, useSig: Bool = false,
         outputType: AMapOutputType = .json, callback: String? = nil) {
        self.keywords = keywords
        self.types = types
        self.city = city
        self.cityLimit = cityLimit
        self.showChildren = showChildren
        self.page = page
        self.building = building
        self.offset = offset
        self.floor = floor
        self.extensions = extensions
        self.sig = useSig
        self.output = outputType
        self.callback = callback
    }
}

public struct GeoSearchResponse: Codable {
    public struct GeoSuggestion: Codable {
        struct GeoCity: Codable {
            let name: String
            let num: String
            let citycode: String
            let adcode: String
        }
        let keywords: String?
        let cities: [GeoCity]
        public init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            keywords = try? values.decode(String.self, forKey: .keywords)
            cities = try values.decode(Array<GeoCity>.self, forKey: .cities)
        }
    }
    public struct GeoSearchPOI: Codable, GeoMapQuadTreeNodeDataDelegate {
        public struct GeoIndoorData: Codable {
            let cpid: String?
            let floor: String?
            let truefloor: String?
            let cmsid: String?
            public init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                cpid = try? values.decode(String.self, forKey: .cpid)
                floor = try? values.decode(String.self, forKey: .floor)
                truefloor = try? values.decode(String.self, forKey: .truefloor)
                cmsid = try? values.decode(String.self, forKey: .cmsid)
            }
        }
        public struct GeoSearchPhoto: Codable {
            let title: String?
            let url: String?
            public init(from decoder: Decoder) throws {
                let values = try decoder.container(keyedBy: CodingKeys.self)
                title = try? values.decode(String.self, forKey: .title)
                url = try? values.decode(String.self, forKey: .url)
            }
        }
        public struct GeoBizExtension: Codable {
            let rating: String?
            let cost: String?
            let meal_ordering: String?
            let seat_ordering: String?
            let ticket_ordering: String?
            let hotel_ordering: String?
        }
        public struct GeoChildren: Codable {
            let id: String
            let name: String
            let sname: String
            let location: String
            let address: String
            let distance: String
            let subtype: String
        }
        public let id: String
        public let name: String
        public let type: String
        public let typecode: String
        public let biz_type: String?
        public let address: String
        public let location: String
        public let distance: String?
        public let tel: String?
        public let postcode: String?
        public let website: String?
        public let email: String?
        public let pcode: String?
        public let pname: String?
        public let citycode: String?
        public let cityname: String
        public let adcode: String?
        public let adname: String
        public let entr_location: String?
        public let exit_location: String?
        public let navi_poiid: String?
        public let gridcode: String?
        public let alias: String?
        public let business_area: String?
        public let parking_type: String?
        public let tag: String?
        public let indoor_map: String?
        public let indoor_data: GeoIndoorData
        public let groupbuy_num: String?
        public let discount_num: String?
        public let biz_ext: GeoBizExtension?
        public let event: String?
        public let importance: String?
        public let shopid: String?
        public let shopinfo: String?
        public let poiweight: String?
        public let match: String
        public let recommend: String
        public let timestamp: String?
        public let children: [GeoChildren]
        public let photos: [GeoSearchPhoto]
        public var clLocation: CLLocation? {
            let coordinates = location.components(separatedBy: ",")
            guard let lat = coordinates.first, let lon = coordinates.last,
                let latitude = CLLocationDegrees(lat),
                let longitude = CLLocationDegrees(lon) else {
                    return nil
            }
            return CLLocation(latitude: latitude, longitude: longitude)
        }
        public var quadTreeNodeData: GeoMapQuadTreeNodeData {
            let loc = clLocation?.coordinate
            return GeoMapQuadTreeNodeData(x: loc?.latitude ?? 0,
                                          y: loc?.longitude ?? 0,
                                          data: self)
        }
        public init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            id = try values.decode(String.self, forKey: .id)
            name = try values.decode(String.self, forKey: .name)
            tag = try? values.decode(String.self, forKey: .tag)
            type = try values.decode(String.self, forKey: .type)
            typecode = try values.decode(String.self, forKey: .typecode)
            biz_type = try? values.decode(String.self, forKey: .biz_type)
            address = try values.decode(String.self, forKey: .address)
            location = try values.decode(String.self, forKey: .location)
            tel = try? values.decode(String.self, forKey: .tel)
            postcode = try? values.decode(String.self, forKey: .postcode)
            website = try? values.decode(String.self, forKey: .website)
            email = try? values.decode(String.self, forKey: .email)
            pcode = try? values.decode(String.self, forKey: .pcode)
            pname = try? values.decode(String.self, forKey: .pname)
            citycode = try? values.decode(String.self, forKey: .citycode)
            cityname = try values.decode(String.self, forKey: .cityname)
            adcode = try? values.decode(String.self, forKey: .adcode)
            adname = try values.decode(String.self, forKey: .adname)
            importance = try? values.decode(String.self, forKey: .importance)
            shopid = try? values.decode(String.self, forKey: .shopid)
            shopinfo = try? values.decode(String.self, forKey: .shopinfo)
            poiweight = try? values.decode(String.self, forKey: .poiweight)
            distance = try? values.decode(String.self, forKey: .distance)
            navi_poiid = try? values.decode(String.self, forKey: .navi_poiid)
            entr_location = try? values.decode(String.self, forKey: .entr_location)
            business_area = try? values.decode(String.self, forKey: .business_area)
            exit_location = try? values.decode(String.self, forKey: .exit_location)
            match = try values.decode(String.self, forKey: .match)
            recommend = try values.decode(String.self, forKey: .recommend)
            indoor_map = try? values.decode(String.self, forKey: .indoor_map)
            indoor_data = try values.decode(GeoIndoorData.self, forKey: .indoor_data)
            groupbuy_num = try? values.decode(String.self, forKey: .groupbuy_num)
            discount_num = try? values.decode(String.self, forKey: .discount_num)
            biz_ext = try? values.decode(GeoBizExtension.self, forKey: .biz_ext)
            event = try? values.decode(String.self, forKey: .event)
            children = try values.decode(Array<GeoChildren>.self, forKey: .children)
            photos = try values.decode(Array<GeoSearchPhoto>.self, forKey: .photos)
            timestamp = try? values.decode(String.self, forKey: .timestamp)
            alias = try? values.decode(String.self, forKey: .alias)
            gridcode = try? values.decode(String.self, forKey: .gridcode)
            parking_type = try? values.decode(String.self, forKey: .parking_type)
        }
    }
    private let status: String
    private let info: String
    private let infocode: Int
    public let count: Int
    public let suggestion: GeoSuggestion
    public let pois: [GeoSearchPOI]
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decode(String.self, forKey: .status)
        infocode = (try Int(values.decode(String.self, forKey: .infocode)))!
        guard status == "1" else {
            throw ServiceError(code: infocode)!
        }
        info = try values.decode(String.self, forKey: .info)
        count = (try Int(values.decode(String.self, forKey: .count)))!
        suggestion = try values.decode(GeoSuggestion.self, forKey: .suggestion)
        pois = try values.decode(Array<GeoSearchPOI>.self, forKey: .pois)
    }
}
